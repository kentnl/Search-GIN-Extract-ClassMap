
use strict;
use warnings;

use Test::More tests                         => 3;
use aliased 'Search::GIN::Extract::ClassMap' => 'CM';

my $map = new_ok( CM,
  [
    extract      => {},
    extract_isa  => {},
    extract_does => {},
  ]
);

$map = new_ok( CM,
  [
    extract      => { baz => [qw( asd )], },
    extract_isa  => { foo => [qw( asd )], },
    extract_does => { bar => [qw( asd )], },
  ]
);

{

  package baz;
  use Moose;

  has 'attr' => ( isa => "Str", is => "rw", default => "world" );

  sub asd {
    return "hello";
  }
}

$map = new_ok( CM, [ extract => {
    baz => [qw( asd attr )]
} ] );

use Data::Dump qw( dump );

dump $map->extract_values( baz->new() );

$map = new_ok( CM, [ extract => { baz => sub {
  my ( $self ) = @_;
  { "foo" => $self->asd };
}} ] );

use Data::Dump qw( dump );

dump $map->extract_values( baz->new() );

