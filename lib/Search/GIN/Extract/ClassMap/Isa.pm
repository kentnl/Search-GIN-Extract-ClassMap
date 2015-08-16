use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Isa;

# ABSTRACT: Map Extractors based on an objects inheritance

our $VERSION = '1.000000';

# AUTHORITY

use Moose qw( with blessed );
use namespace::autoclean;

with 'Search::GIN::Extract::ClassMap::Role';

no Moose;
__PACKAGE__->meta->make_immutable;

=method C<matches>

  # List of Search::GIN::Extract objects
  my ( @extractors ) = $isa_object->matches( $extractee );

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
    if ( $extractee->isa($class) ) {
      push @m, $self->classmap_get($class);
    }
  }
  return @m;
}

1;

