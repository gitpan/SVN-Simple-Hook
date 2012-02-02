#!perl
#
# This file is part of SVN-Simple-Hook
#
# This software is copyright (c) 2012 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use utf8;
use strict;
use Modern::Perl;

package My::Cmd;
use Any::Moose;
extends any_moose('X::App::Cmd');

package My::Cmd::Command::post_commit;
use English '-no_match_vars';
use Any::Moose;
extends any_moose('X::App::Cmd::Command');
with 'SVN::Simple::Hook::PostCommit';

sub execute {
    my ( $self, $opt, $args ) = @ARG;

    warn $self->author(), ' changed ',
        scalar keys %{ $self->paths_changed }, " paths\n";

    return;
}

package main;
use Const::Fast;
use English '-no_match_vars';
use File::Temp;
use SVN::Core;
use SVN::Repos;
use Test::More tests => 2;
use App::Cmd::Tester;

const my $USERID => scalar getpwuid $EFFECTIVE_USER_ID;
my $tmp_dir = File::Temp->newdir();
my $repos   = SVN::Repos::create( "$tmp_dir", (undef) x 4 );
my $txn     = $repos->fs_begin_txn_for_update( 0, "$USERID" );
$txn->root->make_file('/foo');
my $rev = $repos->fs_commit_txn($txn);

my $result = test_app(
    'My::Cmd' => [
        'post_commit',
        '-r'    => "$tmp_dir",
        '--rev' => $rev,
    ],
);

is( $result->exit_code(), 0, 'successful run' );
isnt( $result->output, q{}, 'got output' );