use strict;
use warnings;
package Search::GIN::Extract::ClassMap::Does;
$Search::GIN::Extract::ClassMap::Does::VERSION = '0.01060818';
# ABSTRACT: Map Extractors based on what an object 'does'

use Moose;
use MooseX::Types::Moose qw( :all );
use namespace::autoclean;







with 'Search::GIN::Extract::ClassMap::Role';













sub matches {
  my ( $self, $object ) = @_;
  my @m;
  return @m if not blessed $object;
  for my $class ( $self->classmap_entries ) {
    if ( $object->does($class) ) {
      push @m, $self->classmap_get($class);
    }
  }
  return @m;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Search::GIN::Extract::ClassMap::Does - Map Extractors based on what an object 'does'

=head1 VERSION

version 0.01060818

=head1 ROLES

=head2 L<Search::GIN::Extract::ClassMap::Role>

=head1 METHODS

=head2 matches

returns a list of extractors that are in the map for the object.

=head3 signature: ->matches( $object )

=head3 return: Search::GIN::Extract @items

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
