
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.4004"
  },
  "configure_requires" => {
    "Module::Build" => "0.4004"
  },
  "dist_abstract" => "Delegate Extraction based on class.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Search-GIN-Extract-ClassMap",
  "dist_version" => "0.01060816",
  "license" => "perl",
  "module_name" => "Search::GIN::Extract::ClassMap",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Moose" => "0.90",
    "Moose::Role" => "0.90",
    "MooseX::Types" => 0,
    "MooseX::Types::Moose" => 0,
    "Search::GIN::Extract" => 0,
    "Search::GIN::Extract::Attributes" => 0,
    "Search::GIN::Extract::Callback" => 0,
    "aliased" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "test_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => "0.98"
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
