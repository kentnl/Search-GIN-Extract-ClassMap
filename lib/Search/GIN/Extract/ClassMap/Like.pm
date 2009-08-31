package Search::GIN::Extract::ClassMap::Like;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Types::Moose qw( :all );
use namespace::autoclean;
with 'Search::GIN::Extract::ClassMap::Base';

sub matches {
  my ( $self, $object ) = @_;
  return if not blessed $object;
  for my $class ( $self->classmap_entries ) {
    if ( $object->isa($class) or $object->does($class) ) {
      return $self->classmap_get($class);
    }
  }
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

