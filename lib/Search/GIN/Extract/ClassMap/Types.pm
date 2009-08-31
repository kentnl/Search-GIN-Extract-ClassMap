package Search::GIN::Extract::ClassMap::Types;

# $Id:$
use strict;
use warnings;
use MooseX::Types::Moose qw( :all );
use MooseX::Types -declare => [
  qw[
    IsaClassMap
    DoesClassMap
    LikeClassMap
    Extractor
    CoercedClassMap
    ]
];

class_type IsaClassMap,  { class => 'Search::GIN::Extract::ClassMap::Isa' };
class_type DoesClassMap, { class => 'Search::GIN::Extract::ClassMap::Does' };
class_type LikeClassMap, { class => 'Search::GIN::Extract::ClassMap::Like' };
subtype Extractor, as Object, where {
  $_->does('Search::GIN::Extract')
    or $_->isa('Search::GIN::Extract');
};

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

coerce Extractor, from ArrayRef, via {
  require Search::GIN::Extract::Attributes;
  Search::GIN::Extract::Attributes->new( attributes => $_ )

};
coerce Extractor, from CodeRef, via {
  require Search::GIN::Extract::Callback;
  Search::GIN::Extract::Callback->new( extract => $_ );
};

subtype CoercedClassMap, as HashRef, where {
  for my $v ( values %{$_} ) {
    return unless is_Extractor($v);
  }
  return 1;
}, message {
  for my $k ( keys %{$_} ) {
    next if is_Extractor( $_->{$k} );
    return "Key $k in the hash expected Search::GIN::Extract implementation";
  }
};

coerce CoercedClassMap, from HashRef, via {
  my $newhashref = {};
  my $old        = $_;
  for my $key ( keys %{$old} ) {
    $newhashref->{$key} = to_Extractor( $old->{$key} );
  }
  return $newhashref;
};

1;

