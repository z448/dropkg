package Filesys::Tree;
use File::Basename;

use warnings;
use strict;

=head1 NAME

Filesys::Tree - Return contents of directories in a tree-like format

=cut

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
        'all' => [ qw(
                        tree
                ) ],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
);

our $VERSION = '0.02';

=head1 SYNOPSIS

  use Filesys::Tree qw/tree/;

  my $tree = tree('/path/to/directory');

$tree now holds something like:

  {
    a => {
           type     => 'd',
           contents => {
                         1 => {
                                type     => 'f',
                              },
         },
  }

In this example, there is one directory named "a", which has a file
named "1".

And you can also do:

  use Filesys::Tree qw/tree/;

  my $tree = tree( {'max-depth' => 2} , '/path/to/directory');

See OPTIONS for a full list of options.

=head1 FUNCTIONS

=head2 tree

This is currently the only function in the module. It returns a
tree-like representation of a directory (or a set of directories, if
you ask real hard).

=cut

sub tree {
  # options
  my %config = (
    'max-depth' => -1,
    full        => 0,
  );
  if (ref($_[0]) eq 'HASH') {%config = (%config, %{+shift})}

  # building the tree
  $config{'max-depth'} || return {};

  my $tree = {};

  for (@_) {
    (my $basename = $_) =~ s/\/$//;
    unless ($config{full}) {
      $basename = basename($basename);
    }

    if (-l) { # is a symbolic link
      if ($config{'follow-links'}) { # we want to follow it
        $tree->{$basename} = tree( { %config ,
                                     'max-depth' => $config{'max-depth'} - 1 } ,
                                   grep {$config{all} || /^[^.]/} readlink($_));
      }
      else {
        next;
      }
    }

    elsif (-f) { # is a file
      if (defined $config{'pattern'}) {
        next unless $basename =~ /$config{'pattern'}/;
      }
      if (defined $config{'exclude-pattern'}) {
        next if $basename =~ /$config{'exclude-pattern'}/;
      }
      next if $config{'directories-only'};
      s/.*\/([^\/])$/$1/;
      $tree->{$basename} = { type => 'f' };
    }

    elsif (-d) { # is a directory
      opendir(DIR,$_);
      (my $dir = $_) =~ s{/$}{};
      (my $sub = $dir);
      $sub = basename($sub) unless $config{full};
      $tree->{$sub} = { type => 'd' , contents => 
                                    tree( { %config , 'max-depth' => $config{'max-depth'} - 1 } ,
                                                     map {"$dir/$_"}
                                                     grep {$config{all} || /^[^.]/}
                                                     grep {! /^\.\.?$/} readdir DIR ) };
    }

  }

  # returning the tree
  return $tree;
}

=head1 OPTIONS

=head2 all

All files (by default, files beginning with a dot are not returned).
Default value is 0.

Get a tree including all files:

  my $tree = tree( { all => 1 } , 'path/to/directory/' );

=head2 max-depth

Sets the max-depth for recursion. A negative number means there is no
max-depth. Default value is -1.

Get a tree with a max depth of 2:

  my $tree = tree( { 'max-depth' => 2 , 'path/to/directory/' );

=head2 directories-only

Do not list files. Default value is 0.

  my $tree = tree( { 'directories-only' => 1 } , 'path/to/directory/' );

=head2 full

Full path for each entry. Default value is 0.

Get a tree with full paths and prefixes:

  my $tree = tree( { 'full' => 1 } , 'path/to/directory' );

=head2 follow-links

Follows links. Default value is 0.

Get a tree by following links:

  my $tree = tree( { 'follow-links' => 1 } , 'path/to/directory/' );

=head2 pattern

Only return filename matching pattern.

Get a tree where only files in all lowercase characters are included:

  my $tree = tree( { 'pattern' => qr/^[a-z]+$/ } , 'path/to/directory/');

=head2 exclude-pattern

Exclude files matching the pattern.

Get a tree excluding files with numeric names:

  my $tree = tree( { 'exclude-pattern' => qr/^\d+$/ } , 'path/to/directory/');

=cut

=head1 AUTHOR

Jose Castro, C<< <cog@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-filesys-tree@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 SEE ALSO

tree(1).

=head1 COPYRIGHT & LICENSE

Copyright 2005 Jose Castro, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Filesys::Tree
