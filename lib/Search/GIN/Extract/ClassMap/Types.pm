package Search::GIN::Extract::ClassMap::Types;

# $Id:$
use strict;
use warnings;
use MooseX::Types::Moose qw( :all );
use Scalar::Util qw( refaddr );
use MooseX::Types -declare => [
  qw[
    SGE_ClassMap
    SGE_IsaClassMap
    SGE_DoesClassMap
    SGE_LikeClassMap
    SGE_ClassMapConversion
    SGE_ConversionTable
    Extractor
    CoercedClassMap
    ]
];

class_type 'Search::GIN::Extract::ClassMap::Isa';

role_type SGE_ClassMap,           { role  => 'Search::GIN::Extract::ClassMap' };
class_type SGE_IsaClassMap,       { class => 'Search::GIN::Extract::ClassMap::Isa' };
class_type SGE_DoesClassMap,      { class => 'Search::GIN::Extract::ClassMap::Does' };
class_type SGE_LikeClassMap,      { class => 'Search::GIN::Extract::ClassMap::Like' };
role_type SGE_ClassMapConversion, { role  => 'Search::GIN::Extract::ClassMap::Conversion' };
subtype Extractor, as Object, where {
  $_->does('Search::GIN::Extract')
    or $_->isa('Search::GIN::Extract')
};

subtype SGE_ConversionTable, as ArrayRef [SGE_ClassMapConversion];

#use Search::GIN::Extract::ClassMap::Isa  ();
#use Search::GIN::Extract::ClassMap::Does ();
#use Search::GIN::Extract::ClassMap::Like ();
use Search::GIN::Extract::Attributes ();
use Search::GIN::Extract::Callback  ();
#use Search::GIN::Extract::Conversion::FromArrayRef ();
#use Search::GIN::Extract::Conversion::FromCodeRef ();


coerce SGE_IsaClassMap, from HashRef, via { 'Search::GIN::Extract::ClassMap::Isa'->new( classmap => $_ ); };
coerce SGE_DoesClassMap, from HashRef, via { 'Search::GIN::Extract::ClassMap::Does'->new( classmap => $_ ); };
coerce SGE_LikeClassMap, from HashRef, via { 'Search::GIN::Extract::ClassMap::Like'->new( classmap => $_ ); };

coerce Extractor, from ArrayRef, via { Search::GIN::Extract::Attributes->new( attributes => $_ ) };
coerce Extractor, from CodeRef, via { Search::GIN::Extract::Callback->new( extract => $_ ); };

{
  my $checkedHashRefs;

  subtype CoercedClassMap, as HashRef, where {
    return unless exists $checkedHashRefs->{ refaddr($_) };
    for my $key ( keys %{ $_ } ){
      return unless is_Extractor( $_->{$key} );
    }
    return 1;
  };

  coerce CoercedClassMap, from HashRef, via {
      my $newhashref = {};
      my $old = $_;
      for my $key ( keys %{ $old } ){
        $newhashref->{$key} = to_Extractor( $old->{$key} );
      }
      $checkedHashRefs->{ refaddr( $newhashref ) } = 1;
      return $newhashref;
  };
}

1;

