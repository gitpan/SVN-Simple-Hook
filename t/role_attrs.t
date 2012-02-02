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

use English '-no_match_vars';
use Test::Most;
use Const::Fast;

const my %ATTR => read_attr_hash(<<'END_DATA');
    SVN::Simple::Hook             repos_path author root paths_changed
    SVN::Simple::Hook::PreCommit  author root txn_name transaction
    SVN::Simple::Hook::PostCommit author root revision_number
END_DATA
const my %ATTR_TODO => read_attr_hash(<<'END_DATA');
    SVN::Simple::Hook::PostLock          repos_path user
    SVN::Simple::Hook::PostRevpropChange repos_path rev user propname action
    SVN::Simple::Hook::PostUnlock        repos_path user
    SVN::Simple::Hook::PreLock           repos_path path user
    SVN::Simple::Hook::PreRevpropChange  repos_path rev user propname action
    SVN::Simple::Hook::PreUnlock         repos_path path user
    SVN::Simple::Hook::PreUnlock         repos_path user capabilities
END_DATA

while ( my ( $role, $attr_ref ) = each %ATTR ) {
    role_has_attrs_ok( $role, @{$attr_ref} );
}
while ( my ( $role, $attr_ref ) = each %ATTR_TODO ) {
TODO: { role_has_attrs_ok( $role, @{$attr_ref} ) }
}

done_testing( keys(%ATTR) + keys(%ATTR_TODO) );

sub read_attr_hash {
    return map { $ARG->[0] => [ @{$ARG}[ 1 .. $#{$ARG} ] ] }
        map { [split] } split "\n", shift;
}

sub role_has_attrs_ok {
    my ( $role, @attrs ) = @ARG;

    eval "require $role; $role->import();";
    todo_skip "$role not implemented for attributes: @attrs", 1
        if $EVAL_ERROR;
    return cmp_deeply(
        [ $role->meta->get_attribute_list() ],
        supersetof(@attrs), "$role has attributes: @attrs",
    );
}