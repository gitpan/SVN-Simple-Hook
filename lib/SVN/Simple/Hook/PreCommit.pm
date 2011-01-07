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

package SVN::Simple::Hook::PreCommit;

BEGIN {
    $SVN::Simple::Hook::PreCommit::VERSION = '0.110070';
}

# ABSTRACT: Role for Subversion pre-commit hooks

use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use SVN::Core;
use SVN::Repos;
use SVN::Fs;
use namespace::autoclean;
with 'SVN::Simple::Hook';

has txn_name => (
    ro,
    traits        => ['Getopt'],
    isa           => Str,
    cmd_aliases   => [qw(t txn tran trans transaction transaction_name)],
    documentation => 'commit transaction name',
);

has txn => (
    ro, required, lazy,
    isa      => '_p_svn_fs_txn_t',
    init_arg => undef,
    default  => sub { $ARG[0]->_repos->fs->open_txn( $ARG[0]->txn_name ) },
);

1;

=pod

=head1 NAME

SVN::Simple::Hook::PreCommit - Role for Subversion pre-commit hooks

=head1 VERSION

version 0.110070

=head1 SYNOPSIS

    package MyHook;
    
    use Moose;
    extends 'MooseX::App::Cmd::Command';
    with 'SVN::Simple::Hook::PreCommit';
    
    sub execute {
        my ( $self, $opt, $args ) = @_;
        my $txn = $self->txn();
        
        warn $txn->prop('svn:author'), ' changed ',
            scalar keys %{ $txn->root->paths_changed() }, " paths\n";
        
        return;
    }
    
    1;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 txn_name

Full name of the transaction to check in the repository.

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by GSI Commerce.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
