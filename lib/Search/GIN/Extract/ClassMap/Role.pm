use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Role;
$Search::GIN::Extract::ClassMap::Role::VERSION = '0.01060818';
# ABSTRACT: The ClassMap core role for generally representing all the user config.

use Moose::Role 0.90;




































requires 'matches';

use MooseX::Types::Moose qw( :all );
use Search::GIN::Extract::ClassMap::Types qw( :all );
use namespace::autoclean;























has classmap => (
  isa     => CoercedClassMap,
  coerce  => 1,
  is      => 'rw',
  default => sub { +{} },
  traits  => [qw( Hash )],
  handles => {
    'classmap_entries' => 'keys',
    'classmap_set'     => 'set',
    'classmap_get'     => 'get',
  },
);











sub extract_values {
  my ( $self, $object ) = @_;
  return map { $_->extract_values($object) } $self->matches($object);
}

no Moose::Role;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Search::GIN::Extract::ClassMap::Role - The ClassMap core role for generally representing all the user config.

=head1 VERSION

version 0.01060818

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

=head1 REQUIRED METHODS

=head2 matches

Must take an object and return a list of L<Search::GIN::Extract> items to use for it

=head3 signature: ->matches( $object )

=head3 returns: L<Search::GIN::Extract> @items

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

=head1 METHODS

=head2 extract_values

extracts values from all matching rules for the object

=head3 signature: ->extract_values( $object )

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
