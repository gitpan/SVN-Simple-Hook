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

BEGIN {
    unless ( $ENV{RELEASE_TESTING} ) {
        require Test::More;
        Test::More::plan(
            skip_all => 'these tests are for release candidate testing' );
    }
}

use Test::More;

eval "use Test::Vars";
plan skip_all => "Test::Vars required for testing unused vars"
    if $@;
all_vars_ok();
