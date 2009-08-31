use strict;
use warnings;
package Search::GIN::Extract::ClassMap::Role;

# ABSTRACT: The ClassMap core role for generally representing all the user config.

use Moose::Role;

=head1 SYNOPSIS

  {
    package Foo;
    use MooseX::Role;
    with 'Search::GIN::Extract::ClassMap::Role';

    sub matches {
      my ( $self, $object );
      my @m;

      for ( $self->classmap_entries ) {
        if( $object->some_criteria( $_ ) ) {
          push @m, $self->classmap_get( $_ );
        }
      }
      return @m;
    }

  }

=cut

=head1 REQUIRED METHODS

=head2 matches

Must take an object and return a list of L<Search::GIN::Extract> items to use for it

=head3 signature: ->matches( $object )

=head3 returns: L<Search::GIN::Extract> @items

=cut

requires 'matches';

use MooseX::Types::Moose qw( :all );
use MooseX::AttributeHelpers;
use Search::GIN::Extract::ClassMap::Types qw( :all );
use namespace::autoclean;


=head1 ATTRIBUTES

=head2 classmap

This is a key => value pair set mapping classes to some Extractor to use for that class

=head3 types:

=head4 HashRef [ L<Search::GIN::Extract::ClassMap::Types/Extractor> ]

=head4 L<Search::Extract::ClassMap:Types/CoercedClassMap>

=head3 provides:

=head4 classmap_entries

=head4 classmap_set

=head4 classmap_get

=cut

has classmap => (
  isa       => CoercedClassMap,
  coerce    => 1,
  is        => 'rw',
  default   => sub { +{} },
  metaclass => 'Collection::Hash',
  provides  => {
    keys => 'classmap_entries',
    set  => 'classmap_set',
    get  => 'classmap_get',
  },
);

=head1 METHODS

=head2 extract_values

extracts values from all matching rules for the object

=head3 signature: ->extract_values( $object )

=cut

sub extract_values {
  my ( $self, $object ) = @_;
  return map { $_->extract_values( $object ) } $self->matches( $object );
}

1;

