package Search::GIN::Extract::ClassMap::Base;

# $Id:$
use strict;
use warnings;
use Moose::Role;

requires 'matches';

use MooseX::Types::Moose qw( :all );
use MooseX::AttributeHelpers;
use Search::GIN::Extract::ClassMap::Types qw( :all );
use namespace::autoclean;
with qw( Search::GIN::Keys::Deep );

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

sub extract_for {
  my ( $self, $object ) = @_;
  my @found;
  if ( my $i = $self->matches($object) ) {
    push @found, $i->extract_values($object);
  }
  return @found;
}

1;

