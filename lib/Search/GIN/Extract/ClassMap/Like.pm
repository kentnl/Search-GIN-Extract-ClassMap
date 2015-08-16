use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Like;

# ABSTRACT: Map Extractors based on what an object 'isa' or 'does'

# AUTHORITY

use Moose qw( with blessed );
use namespace::autoclean;

=head1 ROLES

=head2 L<Search::GIN::Extract::ClassMap::Role>

=cut

with 'Search::GIN::Extract::ClassMap::Role';

no Moose;
__PACKAGE__->meta->make_immutable;

=head1 METHODS

=head2 matches

returns a list of extractors that are in the map for the object.

=head3 signature: ->matches( $object )

=head3 return: Search::GIN::Extract @items

=cut

sub matches {
  my ( $self, $extractee ) = @_;
  my @m;
  return @m if not blessed $extractee;
  for my $class ( $self->classmap_entries ) {
    if ( $extractee->isa($class) or $extractee->does($class) ) {
      push @m, $self->classmap_get($class);
    }
  }
  return @m;
}

1;

