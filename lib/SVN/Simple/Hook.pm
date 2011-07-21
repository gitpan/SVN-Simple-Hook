#
# This file is part of SVN-Simple-Hook
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use strict;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

package SVN::Simple::Hook;

BEGIN {
    $SVN::Simple::Hook::VERSION = '0.300';
}

# ABSTRACT: Simple Moose-based framework for Subversion hooks

use English '-no_match_vars';
use Any::Moose '::Role';
use Any::Moose 'X::Types::' . any_moose() => ['Str'];
use Any::Moose 'X::Types::Path::Class'    => ['Dir'];
use Path::Class;
use SVN::Core;
use SVN::Repos;
use SVN::Fs;
use SVN::Simple::Path_Change;
use namespace::autoclean;
with any_moose('X::Getopt');

has repos_path => (
    is            => 'ro',
    isa           => Dir,
    documentation => 'repository path',
    traits        => ['Getopt'],
    cmd_aliases   => [qw(r repo repos repository repository_dir)],
    required      => 1,
    coerce        => 1,
);

has repository => (
    is       => 'ro',
    isa      => '_p_svn_repos_t',
    init_arg => undef,
    required => 1,
    lazy     => 1,
    ## no critic (ProhibitCallsToUnexportedSubs)
    default => sub { SVN::Repos::open( shift->repos_path->stringify() ) },
);

has author => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_author',
    required => 1,
);

has root => (
    is       => 'ro',
    isa      => '_p_svn_fs_root_t',
    init_arg => undef,
    required => 1,
    lazy     => 1,
    builder  => '_build_root',
);

has paths_changed => (
    is       => 'ro',
    isa      => 'HashRef[SVN::Simple::Path_Change]',
    init_arg => undef,
    required => 1,
    lazy     => 1,
    builder  => '_build_paths_changed',
);

sub _build_paths_changed {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;
    my $root = $self->root;
    my $fs   = $root->fs;

    my $rev_root    = $fs->revision_root( $fs->youngest_rev );
    my $changed_ref = $root->paths_changed;

    my %paths_changed;
    while ( my ( $path, $info_ref ) = each %{$changed_ref} ) {
        my $path_obj;
        if ( $root->is_dir($path) or $rev_root->is_dir($path) ) {
            $path_obj = dir($path);
        }
        if ( $root->is_file($path) or $rev_root->is_file($path) ) {
            $path_obj = file($path);
        }

        $paths_changed{$path} = SVN::Simple::Path_Change->new(
            svn_change => $info_ref,
            path       => $path_obj,
        );
    }
    return \%paths_changed;
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

SVN::Simple::Hook - Simple Moose-based framework for Subversion hooks

=head1 VERSION

version 0.300

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

Subversion L<repository object|SVN::Repos>.  Opened on first
call to the accessor.

=head2 author

Author of the current revision or transaction.  Role consumers must provide a
C<_build_author> method to set a default value.

=head2 root

L<Subversion root object|SVN::Fs/_p_svn_fs_root_t> from the repository.  Role
consumers must provide a C<_build_root> method to set a default value.

=head2 paths_changed

A hash reference where the keys are paths in the L</root> and values are
L<SVN::Simple::Path_Change|SVN::Simple::Path_Change> objects.  Enables hooks
to access the changes that triggered them.

=for test_synopsis 1;

=for test_synopsis __END__

=head1 SEE ALSO

See L<SVN::Simple::Hook::PreCommit|SVN::Simple::Hook::PreCommit/SYNOPSIS> for
an example.  This role exists solely to be composed into other roles.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/mjgardner/svn-simple-hook/issues

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
