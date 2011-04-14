use strict;
use warnings;

package Search::GIN::Extract::ClassMap::Types;
BEGIN {
  $Search::GIN::Extract::ClassMap::Types::VERSION = '0.01060815';
}

# ABSTRACT: Types for Search::GIN::Extract::ClassMap, mostly for coercions.

# $Id:$
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



subtype Extractor, as Object, where {
  $_->does('Search::GIN::Extract')
    or $_->isa('Search::GIN::Extract');
};

coerce Extractor, from ArrayRef [Str], via {
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


__END__
=pod

=head1 NAME

Search::GIN::Extract::ClassMap::Types - Types for Search::GIN::Extract::ClassMap, mostly for coercions.

=head1 VERSION

version 0.01060815

=head1 TYPES

=head2 IsaClassMap

=head3 class_type

=head4 L<Search::GIN::Extract::ClassMap::Isa>

=head3 COERCIONS

=head4 HashRef

=head2 DoesClassMap

=head3 class_type

=head4 L<Search::GIN::Extract::ClassMap::Does>

=head3 COERCIONS

=head4 HashRef

=head2 LikeClassMap

=head3 class_type

=head4 L<Search::GIN::Extract::ClassMap::Like>

=head3 COERCIONS

=head4 HashRef

=head2 Extractor

Mostly here to identify things that derive from L<Search::GIN::Extract>

=head3 subtype

=head4 Object

=head3 COERCIONS

=head4 ArrayRef[ Str ]

Coerces into a L<Search::GIN::Extract::Attributes> instance.

=head4 CodeRef

Coerces into a L<Search::GIN::Extract::Callback> instance.

=head2 CoercedClassMap

This is here to implement a ( somewhat hackish ) semi-deep recursive coercion.

Ensures all keys are of type L</Extractor> in order to be a valid hashref,
and applies L</Extractor>'s coercions where possible.

=head3 subtype

=head4 HashRef

=head3 COERCIONS

=head4 HashRef

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

