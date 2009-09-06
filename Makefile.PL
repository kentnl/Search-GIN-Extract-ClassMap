
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Search-GIN-Extract-ClassMap',
  NAME      => 'Search::GIN::Extract::ClassMap',
  AUTHOR    => 'Kent\ Fredric\ \<kentnl\@cpan\.org\>',
  ABSTRACT  => 'Delegate\ Extraction\ based\ on\ class\.',
  VERSION   => '0.01001206',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "MooseX::Types::Moose" => '0.19',
    "namespace::autoclean" => '0.08',
    "aliased" => '0.30',
    "Search::GIN" => '0.03',
    "Test::More" => '0.92',
    "MooseX::AttributeHelpers" => '0.21',
    "MooseX::Types" => '0.19',
    "Moose" => '0.89',
  },
);
