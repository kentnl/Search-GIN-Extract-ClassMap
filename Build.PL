
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'Search::GIN::Extract::ClassMap',
  license       => 'perl',
  dist_abstract => "Delegate\ Extraction\ based\ on\ class\.",
  dist_name     => "Search\-GIN\-Extract\-ClassMap",
  dist_author   => [
"Kent\ Fredric\ \<kentnl\@cpan\.org\>",
  ],
  requires      => {
    "Test::More" => '0.92',
    "MooseX::Types::Moose" => '0.19',
    "MooseX::AttributeHelpers" => '0.21',
    "namespace::autoclean" => '0.08',
    "MooseX::Types" => '0.19',
    "Moose" => '0.89',
    "Search::GIN" => '0.03',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
