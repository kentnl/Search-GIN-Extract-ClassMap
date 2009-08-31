package Search::GIN::Extract::ClassMap;

# Delegate Extraction based on class.

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Types::Moose qw(:all);
use MooseX::Has::Sugar;
use MooseX::AttributeHelpers;
use Carp ();
use Scalar::Util qw( reftype blessed );
use Search::GIN::Extract::ClassMap::Types qw( :all );
use aliased 'Search::GIN::Extract::ClassMap::Isa'  => 'CMIsa';
use aliased 'Search::GIN::Extract::ClassMap::Does' => 'CMDoes';
use aliased 'Search::GIN::Extract::ClassMap::Like' => 'CMLike';
use namespace::autoclean;

with qw(
  Search::GIN::Extract
  Search::GIN::Keys::Deep
);

=head1 SYNOPSIS

  my $extractor = Search::GIN::Extract::ClassMap->new(
    extract_isa => {
      'Foo' => [qw( bar baz quux )],
      'Bar' => Search::GIN::Extract::AttributeIndex->new(),
      'Baz' => sub { shift; my $object = shift; { a => $object->a() } },
    },
    extract_does => {

    },
    extract =>  {
      /* either ISA or DOES */
    },
  );

=cut

has 'extract_isa'  => ( 'isa', IsaClassMap,  rw, coerce, default => sub { CMIsa->new() } );
has 'extract_does' => ( 'isa', DoesClassMap, rw, coerce, default => sub { CMDoes->new() } );
has 'extract'      => ( 'isa', LikeClassMap, rw, coerce, default => sub { CMLike->new() } );

sub extract_values {
  my ( $self, $object ) = @_;
  my @found;
  my ( $isa, $does, $all );
  push @found, $self->extract_isa->extract_for($object);
  push @found, $self->extract_does->extract_for($object);
  push @found, $self->extract->extract_for($object);
  return @found;
}

1;

