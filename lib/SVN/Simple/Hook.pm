#
# This file is part of SVN-Simple-Hook
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict;          ## no critic (UselessNoCritic RequireExplicitPackage)
use warnings;        ## no critic (UselessNoCritic RequireExplicitPackage)
use Modern::Perl;    ## no critic (UselessNoCritic RequireExplicitPackage)

package SVN::Simple::Hook;

BEGIN {
    $SVN::Simple::Hook::VERSION = '0.110070';
}

# ABSTRACT: Simple Moose-based framework for Subversion hooks

use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use MooseX::Types::Path::Class 'Dir';
use SVN::Core;
use SVN::Repos;
use SVN::Fs;
use namespace::autoclean;
with 'MooseX::Getopt';

has repos_path => (
    ro, required, coerce,
    traits        => ['Getopt'],
    isa           => Dir,
    cmd_aliases   => [qw(r repo repos repository repository_dir)],
    documentation => 'repository path',
);

has _repos => (
    ro, required, lazy,
    isa      => '_p_svn_repos_t',
    init_arg => undef,
    ## no critic (ProhibitCallsToUnexportedSubs)
    default => sub { SVN::Repos::open( shift->repos_path->stringify() ) },
);

1;

=pod

=head1 NAME

SVN::Simple::Hook - Simple Moose-based framework for Subversion hooks

=head1 VERSION

version 0.110070

=head1 SYNOPSIS

    package MyHook;
    
    use Moose;
    extends 'MooseX::App::Cmd::Command';
    with 'SVN::Simple::Hook';
    
    1;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 repos_path

L<Directory|Path::Class::Dir> containing the Subversion repository.

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
