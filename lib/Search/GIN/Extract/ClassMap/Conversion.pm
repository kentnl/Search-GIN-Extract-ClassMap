package Search::GIN::Extract::ClassMap::Conversion;

# $Id:$
use strict;
use warnings;
use Moose::Role;
use MooseX::Types::Moose qw( :all );
use MooseX::Has::Sugar;
use MooseX::AttributeHelpers;
with qw( Search::GIN::Keys::Deep );

has '_identify' => ( isa => CodeRef, rw, required, init_arg => 'identify' );
has '_convert'  => ( isa => CodeRef, rw, required, init_arg => 'convert' );

sub identify {
  my ( $self, @args ) = @_;
  my $sub = $self->_identify;
  return $self->$sub(@args);
}

sub convert {
  my ( $self, @args ) = @_;
  my $sub = $self->_convert;
  return $self->$sub(@args);
}

sub BUILD {
  my ($self) = @_;
  $self->_identify;
  $self->_convert;
}

1;

