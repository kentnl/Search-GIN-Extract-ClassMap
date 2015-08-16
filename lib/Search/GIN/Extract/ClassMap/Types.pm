use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Types;

# ABSTRACT: Types for Search::GIN::Extract::ClassMap, mostly for coercing.

our $VERSION = '1.000003';

# AUTHORITY

use MooseX::Types::Moose qw( :all );
use MooseX::Types -declare => [
  qw[
    IsaClassMap
    DoesClassMap
    LikeClassMap
    Extractor
    CoercedClassMap
    ],
];

=type C<IsaClassMap>

=over 4

=item C<class_type> : L<< C<::ClassMap::Isa>|Search::GIN::Extract::ClassMap::Isa >>

=item C<coerces_from>: C<HashRef>

=back

=cut

## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
class_type IsaClassMap, { class => 'Search::GIN::Extract::ClassMap::Isa' };

coerce IsaClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Isa;
  'Search::GIN::Extract::ClassMap::Isa'->new( classmap => $_ );
};

=type C<DoesClassMap>

=over 4

=item C<class_type>: L<< C<::ClassMap::Does>|Search::GIN::Extract::ClassMap::Does >>

=item coerces from: C<HashRef>

=back

=cut

class_type DoesClassMap, { class => 'Search::GIN::Extract::ClassMap::Does' };

coerce DoesClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Does;
  'Search::GIN::Extract::ClassMap::Does'->new( classmap => $_ );
};

=type C<LikeClassMap>

=over 4

=item C<class_type>: L<< C<::ClassMap::Like>|Search::GIN::Extract::ClassMap::Like >>

=item coerces from: C<HashRef>

=back

=cut

class_type LikeClassMap, { class => 'Search::GIN::Extract::ClassMap::Like' };

coerce LikeClassMap, from HashRef, via {
  require Search::GIN::Extract::ClassMap::Like;
  'Search::GIN::Extract::ClassMap::Like'->new( classmap => $_ );
};

=type C<Extractor>

Mostly here to identify things that derive from L<< C<Search::GIN::Extract>|Search::GIN::Extract >>

=over 4

=item C<subtype>: C<Object>

=item coerces from: C<ArrayRef[ Str ]>

Coerces into a L<< C<::Extract::Attributes>|Search::GIN::Extract::Attributes >> instance.

=item coerces from: C<CodeRef>

Coerces into a L<< C<::Extract::Callback>|Search::GIN::Extract::Callback >> instance.

=back

=cut

subtype Extractor, as Object, where {
  $_->does('Search::GIN::Extract')
    or $_->isa('Search::GIN::Extract');
};

coerce Extractor, from ArrayRef [Str], via {
  require Search::GIN::Extract::Attributes;
  Search::GIN::Extract::Attributes->new( attributes => $_ );

};
coerce Extractor, from CodeRef, via {
  require Search::GIN::Extract::Callback;
  Search::GIN::Extract::Callback->new( extract => $_ );
};

=type C<CoercedClassMap>

This is here to implement a ( somewhat hackish ) semi-deep recursive coercion.

Ensures all keys are of type L</Extractor> in order to be a valid C<HashRef>,
and coerces to L</Extractor>'s where possible.

=over 4

=item C<subtype>: C<HashRef[ Extractor ]>

=item coerces from: C<HashRef[ coerce Extractor ]>

=back

=cut

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

