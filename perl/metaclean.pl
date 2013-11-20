#!/usr/bin/perl

use utf8;
use strict;
use warnings;
no warnings "uninitialized";
no strict "refs";

use File::Copy;
use File::Path qw(mkpath rmtree);

my $rootdir = '/Users/dirk/Data/DANS/projects/CKCC/descartes';
my $versiondir = '2012-01-17';
my $datadir = 'data';
my $inputdir = 'input';
my $resdir = 'result';
my $reviewdir = 'review';

my $metafile = "metadatadef.txt";
my $metaoutfile = "metadataclean.txt";
my $headfile = "head.txt";

my $respath = "$rootdir/$versiondir/$resdir";
my $datapath = "$rootdir/$versiondir/$datadir";
my $inputpath = "$rootdir/$versiondir/$inputdir";
my $reviewpath = "$respath/$reviewdir";

my $metapath = "$datapath/$metafile";
my $headpath = "$datapath/$headfile";
my $metaoutpath = "$reviewpath/$metaoutfile";

sub readfile {
	my $file = shift;
	if (!open(F, "<:encoding(UTF-8)", $file)) {
		print STDERR "Can't read file [$file]\n";
		return 0;
	}
	my @lines = <F>;
	close F;
	return \@lines;
}

my $metasrc = readfile($metapath);
printf "%s=%d lines\n", $metafile, (scalar @$metasrc);
my $metatext = join '', @$metasrc;

if (!open(HLO, ">:encoding(UTF-8)", $metaoutpath)) {
	print STDERR "Can't write file [$metaoutpath]\n";
	exit;
}
print HLO $metatext;
close HLO;
