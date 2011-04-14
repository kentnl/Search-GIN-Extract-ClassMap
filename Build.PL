
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.96'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Delegate Extraction based on class.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'Search-GIN-Extract-ClassMap',
  'dist_version' => '0.01060815',
  'license' => 'perl',
  'module_name' => 'Search::GIN::Extract::ClassMap',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Moose' => '0.90',
    'Moose::Role' => '0.90',
    'MooseX::Types' => '0',
    'MooseX::Types::Moose' => '0',
    'Search::GIN::Extract' => '0',
    'Search::GIN::Extract::Attributes' => '0',
    'Search::GIN::Extract::Callback' => '0',
    'aliased' => '0',
    'namespace::autoclean' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
