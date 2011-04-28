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

package SVN::Simple::Hook::PreCommit;

BEGIN {
    $SVN::Simple::Hook::PreCommit::VERSION = '0.215';
}

# ABSTRACT: Role for Subversion pre-commit hooks

use strict;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use SVN::Core;
use SVN::Repos;
use SVN::Fs;
use namespace::autoclean;
with 'SVN::Simple::Hook';

has txn_name => ( ro, required,
    traits        => ['Getopt'],
    isa           => Str,
    cmd_aliases   => [qw(t txn tran trans transaction transaction_name)],
    documentation => 'commit transaction name',
);

has transaction => ( ro, required, lazy,
    isa      => '_p_svn_fs_txn_t',
    init_arg => undef,
    default => sub { $ARG[0]->repository->fs->open_txn( $ARG[0]->txn_name ) },
);

{
    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    sub _build_author { return shift->transaction->prop('svn:author') }
    sub _build_root   { return shift->transaction->root() }
}

1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

SVN::Simple::Hook::PreCommit - Role for Subversion pre-commit hooks

=head1 VERSION

version 0.215

=head1 SYNOPSIS

    package MyHook::Cmd;
    use Moose;
    extends 'MooseX::App::Cmd';

    package MyHook::Cmd::Command::pre_commit;
    use Moose;
    extends 'MooseX::App::Cmd::Command';
    with 'SVN::Simple::Hook::PreCommit';

    sub execute {
        my ( $self, $opt, $args ) = @_;
        my $txn = $self->txn();

        warn $self->author, ' changed ',
            scalar keys %{ $self->root->paths_changed() }, " paths\n";

        return;
    }

=head1 DESCRIPTION

This L<Moose::Role|Moose::Role> gives you access to the current Subversion
transaction for use in a pre-commit hook.  It's designed for use with
L<MooseX::App::Cmd::Command|MooseX::App::Cmd::Command> classes, so consult
the main L<MooseX::App::Cmd documentation|MooseX::App::Cmd> for details
on how to extend it to create your scripts.

=head1 ATTRIBUTES

=head2 txn_name

Full name of the transaction to check in the repository.

=head2 transaction

The current L<Subversion transaction|SVN::Fs/_p_svn_fs_txn_t>, automatically
populated at object creation time when the L<txn_name|/txn_name> is set.

=head2 author

The author of the current transaction as required by all
L<SVN::Simple::Hook|SVN::Simple::Hook> consumers.

=head2 root

The L<Subversion root|SVN::Fs/_p_svn_fs_root_t> node as required by all
L<SVN::Simple::Hook|SVN::Simple::Hook> consumers.

=head1 Example F<hooks/pre-commit> hook script

    #!/bin/sh

    REPOS="$1"
    TXN="$2"

    perl -MMyHook::Cmd -e 'MyHook::Cmd->run()' pre_commit -r "$REPOS" -t "$TXN" || exit 1
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
