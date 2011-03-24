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

package SVN::Simple::Path_Change;

BEGIN {
    $SVN::Simple::Path_Change::VERSION = '0.211';
}

# ABSTRACT: A class for easier manipulation of Subversion path changes

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Path::Class qw(Dir File);
use SVN::Fs;
use namespace::autoclean;

## no critic (RequireDotMatchAnything, RequireExtendedFormatting)
## no critic (RequireLineBoundaryMatching)
has svn_change =>
    ( ro, required, isa => '_p_svn_fs_path_change_t', handles => qr// );

has path => ( ro, required, coerce, isa => Dir | File );

__PACKAGE__->meta->make_immutable();
1;

=pod

=for :stopwords Mark Gardner GSI Commerce

=encoding utf8

=head1 NAME

SVN::Simple::Path_Change - A class for easier manipulation of Subversion path changes

=head1 VERSION

version 0.211

=head1 SYNOPSIS

    use SVN::Simple::Path_Change;
    use SVN::Core;
    use SVN::Fs;
    use SVN::Repos;

    my $repos = SVN::Repos::open('/path/to/svn/repos');
    my $fs = $repos->fs;
    my %paths_changed = %{$fs->revision_root($fs->youngest_rev)->paths_changed};

    my @path_changes  = map {
        SVN::Simple::Path_Change->new(
            path       => $_,
            svn_change => $paths_changed{$_},
    ) } keys %paths_changed;

=head1 DESCRIPTION

This is a simple class that wraps a
L<Subversion path change object|SVN::Fs/_p_svn_fs_path_change_t> along with the
path it describes.

=head1 ATTRIBUTES

=head2 svn_change

The L<_p_svn_fs_path_change_t|SVN::Fs/_p_svn_fs_path_change_t> object as
returned from the C<< $root->paths_changed() >> method.

=head2 path

Either a L<Path::Class::Dir|Path::Class::Dir> or
L<Path::Class::File|Path::Class::File> representing the changed entity.

=head1 METHODS

All the methods supported by
L<_p_svn_fs_path_change_t|SVN::Fs/_p_svn_fs_path_change_t> are delegated by and
act on the L</svn_change> attribute.

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
