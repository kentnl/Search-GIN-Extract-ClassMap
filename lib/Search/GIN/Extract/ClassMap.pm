use 5.006;    # our
use strict;
use warnings;

package Search::GIN::Extract::ClassMap;

# ABSTRACT: Delegate Extraction based on class.

our $VERSION = '1.000000';

# AUTHORITY

use Moose 0.90 qw( with has );
use Search::GIN::Extract::ClassMap::Types qw( IsaClassMap DoesClassMap LikeClassMap );
use aliased 'Search::GIN::Extract::ClassMap::Isa'  => 'CMIsa';
use aliased 'Search::GIN::Extract::ClassMap::Does' => 'CMDoes';
use aliased 'Search::GIN::Extract::ClassMap::Like' => 'CMLike';
use namespace::autoclean;

with qw(  Search::GIN::Extract );

=attr C<extract_isa>

  my $object = Search::GIN::Extract::ClassMap->new(
    extract_isa => $isa_thing
  );
  # or
  $object->extract_isa( $isa_thing )


Applied on all objects where $object->isa( $classname );

=head3 C<$isa_thing>

=over 4

=item C<< HashRef[ L<Extractor|Search::GIN::Extract::ClassMap::Types/Extractor> ] >>

=item L<< C<CoercedClassMap>|Search::GIN::Extract::ClassMap::Types/CoercedClassMap >>

=item L<< C<::ClassMap::Isa>|Search::GIN::Extract::ClassMap::Isa >>

C<HashRef>'s are automatically type-cast.

=back

=cut

has 'extract_isa' => ( 'isa', IsaClassMap, 'is', 'rw', 'coerce', 1, default => sub { CMIsa->new() } );

=attr C<extract_does>

  my $object =  Search::GIN::Extract::ClassMap->new(
    extract_does => $does_thing
  );
  # or
  $object->extract_does( $does_thing );

Applied on all objects where $object->does( $classname );

=head3 C<$does_thing>

=over 4

=item C<< HashRef[ L<Extractor|Search::GIN::Extract::ClassMap::Types/Extractor> ] >>

=item L<< C<CoercedClassMap>|Search::GIN::Extract::ClassMap::Types/CoercedClassMap >>

=item L<< C<::ClassMap::Does>|Search::GIN::Extract::ClassMap::Does >>

C<HashRef>'s are automatically type-cast.

=back

=cut

has 'extract_does' => ( 'isa', DoesClassMap, 'is', 'rw', 'coerce', 1, default => sub { CMDoes->new() } );

=attr C<extract>

  my $object =  Search::GIN::Extract::ClassMap->new(
    extract => $like_thing
  );
  # or
  $object->extract( $like_thing );


Applied on all objects where $object->does( $classname ) OR $object->isa( $classname );

this doesn't make complete sense, but its handy for lazy people.

=head3 C<$like_thing>

=over 4

=item C<< HashRef[ L<Extractor|Search::GIN::Extract::ClassMap::Types/Extractor> ] >>

=item L<< C<CoercedClassMap>|Search::GIN::Extract::ClassMap::Types/CoercedClassMap >>

=item L<< C<::ClassMap::Like>|Search::GIN::Extract::ClassMap::Like >>

C<HashRef>'s are automatically type-cast.

=back

=cut

has 'extract' => ( 'isa', LikeClassMap, 'is', 'rw', 'coerce', 1, default => sub { CMLike->new() } );

no Moose;
__PACKAGE__->meta->make_immutable;

=method C<extract_values>

  my ( @values ) = $object->extract_values( $extractee );

B<for:> L<< C<Search::GIN::Extract>|Search::GIN::Extract >>

Iterates the contents of the C<< extract($|_\w+$) >> rules, and asks them to
extract their respective information, and returns the resulting results as a
list.

=cut

sub extract_values {
  my ( $self, $extractee ) = @_;
  my @found;
  for ( $self->extract_isa, $self->extract_does, $self->extract ) {
    push @found, $_->extract_values($extractee);
  }
  return @found;
}

1;

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
an C<ArrayRef>, or a C<CodeRef>, which internally are type-cast to
L<< C<Search::GIN::Extract::Attributes>|Search::GIN::Extract::Attributes >>
and L<< C<Search::GIN::Extract::Callback>|Search::GIN::Extract::Callback >>
automatically.

=head1 WARNING

This is an early release, C<API> is prone to change without much warning, but best attempts will be made to avoid the need.

=cut
