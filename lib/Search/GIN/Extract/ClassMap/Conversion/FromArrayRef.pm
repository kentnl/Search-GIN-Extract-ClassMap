package Search::GIN::Extract::ClassMap::Conversion::FromArrayRef;

# $Id:$
use strict;
use warnings;
use Moose;
use Scalar::Util qw( reftype blessed );
use Sub::Name;
with "Search::GIN::Extract::ClassMap::Conversion";
use namespace::autoclean;

has '+_identify' => ( required => 0, default => sub { \&__identify  });
has '+_convert'  => ( required => 0, default => sub { \&__convert  });

sub __identify {
  my ( $self, $item ) = @_;
  return if blessed( $item );
  return if reftype( $item ) ne 'ARRAY';
  return 1;
}

sub __convert {
  my ( $self, $item ) = @_;
  return $self->_generate_extractor( $item );
}

=head2 _generate_raw_attr_extractor

Generates a sub that will return a value out of an object.

Note that this assumes the object is using a hashref for its backing store, and completely circumvents
the whole accessor layer/MOP, the whole works.

If  you want proper attributes, use & to use their accessors.

The returned function can be called like so:

  $extractor->$sub( $object )

and it will return the value from object its supposed to find.

=head4 signature: ->_generate_raw_attr_extractor( $attr_name );

=cut

sub _generate_raw_attr_extractor {
  my ( $self, $attrname ) = @_;
  return subname( "<raw_attr_extractor for $attrname>", sub {
    my ( $extractor, $object ) = @_;
    if ( not exists $object->{$attrname} ) {
      Carp::carp("The property $attrname does not exist on the objects hash");
      return;
    }
    return $object->{$attrname};
  });
}

=head2 _generate_sub_call_extractor

Generates a sub that will call a sub on an object to return its value.

For example:

  ->_generate_sub_call_extractor( 'foo' );

Will return a sub that:

  $extractor->$sub( $object )

Will perform

  $object->foo();

=head4 signature: ->_generate_sub_call_extractor( $subname )

=cut

sub _generate_sub_call_extractor {
  my ( $self, $subname ) = @_;
  return subname("<sub_call_extractor for $subname>",sub {
    my ( $extractor, $object, @rest ) = @_;
    my $call = $object->can($subname);
    if ( not defined $call ) {
      Carp::carp("Can't call the method $subname on this object");
      return;
    }
    return $object->$call(@rest);
  });
}

=head2 _generate_extractor

Converts the specification hashref of [qw( &bar foo )] into a function that
can be called on an object to return a hashmap.

The generated function can be called like $extractor->$sub( $object )  and it returns a
lovely hashref.

At present we don't use the meta-model anywhere to extract stuff, its just a dumb extractor
convenience. Its more powerfull that way. Maybe we'll put some ways to access things without
going through accessors later.

=head4 signature: ->_generate_extractor([qw( hash_key &sub_name )]);

=cut

sub _generate_extractor {
  my ( $self, $extractor_ref ) = @_;
  my @to_extract = @{$extractor_ref};
  my %attrmap;
  for (@to_extract) {
    my $key = $_;
    if ( $key =~ /^&/ ) {
      $key =~ s/^&//;
      $attrmap{$key} = $self->_generate_sub_call_extractor($key);
      next;
    }
    $attrmap{$key} = $self->_generate_raw_attr_extractor($key);
  }
  #############
  return subname('<generated extractor>', sub {
    ####
    use Data::Dump qw( dump );
    my ( $extractor, $object, @rest ) = @_;
    my %collection;
    for my $key ( keys %attrmap ) {
      my $sub = $attrmap{$key};
      $collection{$key} = $extractor->$sub( $object, @rest );
    }
    return $extractor->process_keys( %collection );
    ####
  });
  ############
}


1;

