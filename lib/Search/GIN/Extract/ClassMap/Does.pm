use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Does;

# ABSTRACT: Map Extractors based on an objects roles.

# AUTHORITY

use Moose qw( with blessed );
use namespace::autoclean;

with 'Search::GIN::Extract::ClassMap::Role';

no Moose;
__PACKAGE__->meta->make_immutable;

=method C<matches>

  # List of Search::GIN::Extract objects
  my ( @extractors ) = $does_object->matches( $extractee );

returns a list of extractors that are in the map for the object.

  for my $extractor ( @extractors ) {
    my $metadata = $extractor->extract_values( $extractee );
  }

=cut

sub matches {
  my ( $self, $extractee ) = @_;
  my @m;
  return @m if not blessed $extractee;
  for my $class ( $self->classmap_entries ) {
    if ( $extractee->does($class) ) {
      push @m, $self->classmap_get($class);
    }
  }
  return @m;
}

1;

