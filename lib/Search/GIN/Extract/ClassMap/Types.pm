package Search::GIN::Extract::ClassMap::Types;

# $Id:$
use strict;
use warnings;
use MooseX::Types::Moose qw( :all );
use Scalar::Util qw( refaddr );
use MooseX::Types -declare => [
  qw[
    IsaClassMap
    DoesClassMap
    LikeClassMap
    Extractor
    CoercedClassMap
    ]
];


class_type IsaClassMap,       { class => 'Search::GIN::Extract::ClassMap::Isa' };
class_type DoesClassMap,      { class => 'Search::GIN::Extract::ClassMap::Does' };
class_type LikeClassMap,      { class => 'Search::GIN::Extract::ClassMap::Like' };
subtype Extractor, as Object, where {
  $_->does('Search::GIN::Extract')
    or $_->isa('Search::GIN::Extract')
};

use Search::GIN::Extract::Attributes ();
use Search::GIN::Extract::Callback  ();

coerce IsaClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Isa;
  'Search::GIN::Extract::ClassMap::Isa'->new( classmap => $_ );
};
coerce DoesClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Does;
  'Search::GIN::Extract::ClassMap::Does'->new( classmap => $_ );
};
coerce LikeClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Like;
  'Search::GIN::Extract::ClassMap::Like'->new( classmap => $_ );
};

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

