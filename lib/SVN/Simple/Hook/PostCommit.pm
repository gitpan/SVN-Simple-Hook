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

package SVN::Simple::Hook::PostCommit;

BEGIN {
    $SVN::Simple::Hook::PostCommit::VERSION = '0.300';
}

# ABSTRACT: Role for Subversion post-commit hooks

use English '-no_match_vars';
use Any::Moose '::Role';
use Any::Moose 'X::Types::Common::Numeric' => ['PositiveInt'];
use SVN::Core;
use SVN::Repos;
use SVN::Fs;
use namespace::autoclean;
with 'SVN::Simple::Hook';

has revision_number => (
    is            => 'ro',
    isa           => PositiveInt,
    required      => 1,
    traits        => ['Getopt'],
    cmd_aliases   => [qw(rev revnum rev_num revision_number)],
    documentation => 'commit revision number',
);

has _svn_filesystem => (
    is       => 'ro',
    isa      => '_p_svn_fs_t',
    required => 1,
    lazy     => 1,
    default  => sub { shift->repository->fs },
);

{
    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    sub _build_author {
        my $self = shift;
        return $self->_svn_filesystem->revision_prop( $self->revision_number,
            'svn:author' );
    }

    sub _build_root {
        my $self = shift;
        return $self->_svn_filesystem->revision_root(
            $self->revision_number );
    }
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

SVN::Simple::Hook::PostCommit - Role for Subversion post-commit hooks

=head1 VERSION

version 0.300

=head1 SYNOPSIS

    package MyHook::Cmd;
    use Moose;
    extends 'MooseX::App::Cmd';

    package MyHook::Cmd::Command::post_commit;
    use Moose;
    extends 'MooseX::App::Cmd::Command';
    with 'SVN::Simple::Hook::PostCommit';

    sub execute {
        my ( $self, $opt, $args ) = @_;

        warn $self->author, ' changed ',
            scalar keys %{ $self->root->paths_changed() }, " paths\n";

        return;
    }

=head1 DESCRIPTION

This L<Moose::Role|Moose::Role> gives you access to the Subversion revision
just committed for use in a post-commit hook.  It's designed for use with
L<MooseX::App::Cmd::Command|MooseX::App::Cmd::Command> classes, so consult
the main L<MooseX::App::Cmd documentation|MooseX::App::Cmd> for details
on how to extend it to create your scripts.

=head1 ATTRIBUTES

=head2 revision_number

Revision number created by the commit.

=head2 author

The author of the current transaction as required by all
L<SVN::Simple::Hook|SVN::Simple::Hook> consumers.

=head2 root

The L<Subversion root|SVN::Fs/_p_svn_fs_root_t> node as required by all
L<SVN::Simple::Hook|SVN::Simple::Hook> consumers.

=head1 Example F<hooks/post-commit> hook script

    #!/bin/sh

    REPOS="$1"
    REV="$2"

    perl -MMyHook::Cmd -e 'MyHook::Cmd->run()' post_commit -r "$REPOS" --rev "$REV" || exit 1
    exit 0

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
