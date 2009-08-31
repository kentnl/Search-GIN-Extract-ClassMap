package Search::GIN::Extract::ClassMap::Conversion::FromCodeRef;

# $Id:$
use strict;
use warnings;
use Moose;
use Scalar::Util qw( reftype blessed );
use Sub::Name;
with "Search::GIN::Extract::ClassMap::Conversion";
use namespace::autoclean;

has '+_identify' => ( required => 0, default => sub { \&__identify  });
has '+_convert'  => ( required => 0, default => sub { \&__convert  });

sub __identify {
  my ( $self, $item ) = @_;
  return if blessed( $item );
  return if reftype( $item ) ne 'CODE';
  return 1;
}

sub __convert {
  my ( $self, $item ) = @_;
  return subname('<Wrapped_sub>', sub {
    my( $extractor, $object, @args ) = @_ ;
    my hashref = $extractor->$item( $object, @args );
    return $extractor->process_keys( %{ $hashref } );
  });
}


1;

