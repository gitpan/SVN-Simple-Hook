#
# This file is part of SVN-Simple-Hook
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package SVN::Simple::Hook;

BEGIN {
    $SVN::Simple::Hook::VERSION = '0.200';
}

# ABSTRACT: Simple Moose-based framework for Subversion hooks

use strict;
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

has repository => (
    ro, required, lazy,
    isa      => '_p_svn_repos_t',
    init_arg => undef,
    ## no critic (ProhibitCallsToUnexportedSubs)
    default => sub { SVN::Repos::open( shift->repos_path->stringify() ) },
);

has author => ( ro, required, lazy_build, isa => Str, init_arg => undef );

has root => ( ro, required, lazy_build,
    isa      => '_p_svn_fs_root_t',
    init_arg => undef,
);

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

SVN::Simple::Hook - Simple Moose-based framework for Subversion hooks

=head1 VERSION

version 0.200

=head1 SYNOPSIS

=head1 DESCRIPTION

This is a collection of L<Moose::Role|Moose::Role>s that help you implement
Subversion repository hooks by providing simple attribute access to relevant
parts of the Subversion API.  This is a work in progress and the interface
is extremely unstable at the moment.  You have been warned!

=head1 ATTRIBUTES

=head2 repos_path

L<Directory|Path::Class::Dir> containing the Subversion repository.

=head2 repository

Subversion L<repository object|SVN::Repos/_p_svn_repos_t>.  Opened on first
call to the accessor.

=head2 author

Author of the current revision or transaction.  Role consumers must provide a
C<_build_author> method to set a default value.

=head2 root

L<Subversion root object|SVN::Fs/_p_svn_fs_root_t> from the repository.  Role
consumers must provide a C<_build_root> method to set a default value.

=for test_synopsis 1;

=for test_synopsis __END__

=head1 SEE ALSO

See L<SVN::Simple::Hook::PreCommit|SVN::Simple::Hook::PreCommit/SYNOPSIS> for
an example.  This role exists solely to be composed into other roles.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://github.com/mjgardner/SVN-Simple-Hook/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
