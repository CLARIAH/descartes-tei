#!/usr/bin/perl

=head1

Rename images from c-... to AT-...

=cut

use utf8;
use strict;
use warnings;
no warnings "uninitialized";
no strict "refs";

use File::Copy;

my $rootdir = '/Users/dirk/Data/DANS/projects/CKCC/descartes';
my $versiondir = '2012-01-17';
my $datadir = 'data';

my $datapath = "$rootdir/$versiondir/$datadir";

my $imagesdir = "Connaught Pics";
my $imagespath = "$datapath/$imagesdir";

my @imfiles = ();
my $globpat;

$globpat = $imagespath.'/*.*';
$globpat =~ s/ /\\ /g;
push @imfiles, glob($globpat);

my $good = 1;
for my $source (@imfiles) {
	my $target = $source;
	$target =~ s/\/c([^\/]*)$/\/AT$1/;
	if ($source ne $target) {
#		print STDERR "$source => $target\n";
		if (!move($source, $target)) {
			print STDERR "Could not move [$source] to [$target]\n";
			$good = 0;
		}
	}
}

exit !$good;
