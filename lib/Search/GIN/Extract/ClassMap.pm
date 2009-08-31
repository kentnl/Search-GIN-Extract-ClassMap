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
use aliased 'Search::GIN::Extract::ClassMap::Isa'  => 'IsaClassMap';
use aliased 'Search::GIN::Extract::ClassMap::Does' => 'DoesClassMap';
use aliased 'Search::GIN::Extract::ClassMap::Like' => 'LikeClassMap';
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

has 'extract_isa'  => ( 'isa', SGE_IsaClassMap,  rw, coerce, default => sub { IsaClassMap->new() } );
has 'extract_does' => ( 'isa', SGE_DoesClassMap, rw, coerce, default => sub { DoesClassMap->new() } );
has 'extract'      => ( 'isa', SGE_LikeClassMap, rw, coerce, default => sub { LikeClassMap->new() } );

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

