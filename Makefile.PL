
use strict;
use warnings;

BEGIN { require 5.010; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Simple Moose-based framework for Subversion hooks',
  'AUTHOR' => 'Mark Gardner <mjgardner@cpan.org>',
  'BUILD_REQUIRES' => {
    'App::Cmd::Tester' => '0',
    'Carp' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Moose' => '0',
    'MooseX::App::Cmd' => '0',
    'MooseX::App::Cmd::Command' => '0',
    'Readonly' => '0',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'Test::Most' => '0',
    'perl' => '5.004'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'SVN-Simple-Hook',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'SVN::Simple::Hook',
  'PREREQ_PM' => {
    'English' => '0',
    'Modern::Perl' => '0',
    'Moose::Role' => '0',
    'MooseX::Getopt' => '0',
    'MooseX::Has::Sugar' => '0',
    'MooseX::Types::Common::Numeric' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Path::Class' => '0',
    'SVN::Core' => '0',
    'SVN::Fs' => '0',
    'SVN::Repos' => '0',
    'namespace::autoclean' => '0',
    'utf8' => '0'
  },
  'VERSION' => '0.200',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



