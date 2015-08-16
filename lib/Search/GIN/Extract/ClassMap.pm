use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap;
$Search::GIN::Extract::ClassMap::VERSION = '0.01060818';
# ABSTRACT: Delegate Extraction based on class.

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moose 0.90 qw( with has );
use Search::GIN::Extract::ClassMap::Types qw( IsaClassMap DoesClassMap LikeClassMap );
use aliased 'Search::GIN::Extract::ClassMap::Isa'  => 'CMIsa';
use aliased 'Search::GIN::Extract::ClassMap::Does' => 'CMDoes';
use aliased 'Search::GIN::Extract::ClassMap::Like' => 'CMLike';
use namespace::autoclean;







with qw(
  Search::GIN::Extract
);

















































has 'extract_isa'  => ( 'isa', IsaClassMap,  'is', 'rw', 'coerce', 1, default => sub { CMIsa->new() } );
has 'extract_does' => ( 'isa', DoesClassMap, 'is', 'rw', 'coerce', 1, default => sub { CMDoes->new() } );
has 'extract'      => ( 'isa', LikeClassMap, 'is', 'rw', 'coerce', 1, default => sub { CMLike->new() } );

no Moose;
__PACKAGE__->meta->make_immutable;









sub extract_values {
  my ( $self, $extractee ) = @_;
  my @found;
  for ( $self->extract_isa, $self->extract_does, $self->extract ) {
    push @found, $_->extract_values($extractee);
  }
  return @found;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Search::GIN::Extract::ClassMap - Delegate Extraction based on class.

=head1 VERSION

version 0.01060818

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

In reality, the form is more like this:

my $extractor = Search::GIN::Extract::ClassMap->new(
  extract_isa => {
    'Foo' => Search::GIN::Extract::*,
    'Bar' => Search::GIN::Extract::*,
    'Baz' => Search::GIN::Extract::*,
  },
  extract_does => {

  },
  extract =>  {
    /* either ISA or DOES */
  },
);

With the minor exception of the 2 exception cases, passing
an array ref, or a coderef, which internally are typecasted to
L<Search::GIN::Extract::Attributes> and L<Search::GIN::Extract::Callback>
automatically.

=head1 ROLES

=head2 L<Search::GIN::Extract>

=head1 ATTRIBUTES

=head2 extract_isa

Applied on all objects where $object->isa( $classname );

=head3 types:

=head4 HashRef[ L<Search::GIN::Extract::ClassMap::Types/Extractor> ] ->

=head4 L<Search::GIN::Extract::ClassMap::Types/CoercedClassMap> ->

=head4 L<Search::GIN::Extract::ClassMap::Isa>

HashRef's are automatically type-cast.

=head2 extract_does

Applied on all objects where $object->does( $classname );

=head3 types:

=head4 HashRef[ L<Search::GIN::Extract::ClassMap::Types/Extractor> ] ->

=head4 L<Search::GIN::Extract::ClassMap::Types/CoercedClassMap> ->

=head4 L<Search::GIN::Extract::ClassMap::Does>

HashRef's are automatically type-cast.

=head2 extract_does

Applied on all objects where $object->does( $classname ) OR $object->isa( $classname );

this doesn't make complete sense, but its handy for lazy people.

=head3 types:

=head4 HashRef[ L<Search::GIN::Extract::ClassMap::Types/Extractor> ]

=head4 L<Search::GIN::Extract::ClassMap::Types/CoercedClassMap> ->

=head4 L<Search::GIN::Extract::ClassMap::Like>

HashRef's are automatically type-cast.

=head1 METHODS

=head2 extract_values

=head3 for: L<Search::GIN::Extract>

=head1 WARNING

This is an early release, API is prone to change without much warning, but best attempts will be made to avoid the need.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
