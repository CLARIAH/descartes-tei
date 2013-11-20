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

my $metafile = "metadata.txt";
my $metaoutfile = "metadatadef.txt";
my $headfile = "head.txt";

my $respath = "$rootdir/$versiondir/$resdir";
my $datapath = "$rootdir/$versiondir/$datadir";
my $inputpath = "$rootdir/$versiondir/$inputdir";
my $reviewpath = "$respath/$reviewdir";

my $metapath = "$datapath/$metafile";
my $headpath = "$datapath/$headfile";
my $metaoutpath = "$reviewpath/$metaoutfile";

my %meta = ();
my %head = ();
my @metaorder = ();
my %metaindex = ();
my %metaprim = ();

my %rm = (
	I		=> 1,
	II		=> 2,
	III		=> 3,
	IV		=> 4,
	V		=> 5,
	VI		=> 6,
	VII		=> 7,
	VIII	=> 8,
	IX		=> 9,
	X		=> 10,
);

sub do_meta {
	my $metasrc = readfile($metapath);
	printf "%s=%d lines\n", $metafile, (scalar @$metasrc);

# store the metadata

	my $metatext = join '', @$metasrc;
	my @metaorderprim = $metatext =~ m/([^\n]+)\n.*?===\n/sg;
	%metaprim = $metatext =~ m/([^\n]+)\n(.*?)===\n/sg;
	for my $mpk (@metaorderprim) {
		my ($amvol, $ampre, $amn, $ampost) = $mpk =~ m/^([0-9])[0-9]{5}\s+<l\s+(f?)([0-9]+)([^\s>]*)>$/s;
		if (!defined $amvol) {
			printf STDERR "META: No valid AM id string : [%s]\n", $mpk;
			next;
		}
		my $amid = sprintf "%d-%s%03d%s", $amvol, $ampre, $amn, $ampost;
		if (exists $meta{$amid}) {
			printf STDERR "META: Multiple AM number: [%s]\n", $amid;
			next;
		}
		push @metaorder, $amid;
		$metaindex{$amid} = $mpk;
		my $data = $metaprim{$mpk};
		my %fields = $data =~ m/<meta type="([^"]*)" value="([^"]*)"\/>/sg;
		$meta{$amid} = [$fields{date}, $fields{sender}, $fields{senderloc}, $fields{recipient}, $fields{recipientloc}];
	}
}

sub do_heads {
	my $headsrc = readfile($headpath);
	shift @$headsrc;
	chomp @$headsrc;

# store the head data

	my $nlines = 1;
	for my $line (@$headsrc) {
		$nlines++;
		$line =~ s/\s*\@$//;
		$line =~ s/\s+/ /g;
		my (@fields) = split /\*/, $line;
		for my $fld (@fields) {
			$fld =~ s/%/*/g;
# NB: if a field starts with ! it will be ignored.
# I do this when EJB says something should be ignored and I do not want to erase that in the source document
			if (substr($fld, 0, 1) eq '!') {
				$fld = '';
			}
		}
#AMnum*ATnum*senderloc,date*altdate*AMvol,page*ATvol,page|Roth,page*sender-recipient* @
		my ($amnum, $amnumrep, $atnum, $senderlocdate, $y, $amidstr, $atidstr, $sendrec) = @fields;
		my ($amvol) = $amidstr =~ m/^([IVX]*)\s*,/;
		if (!defined $amvol) {
			printf STDERR "HEAD: No valid AM id string : [%s] at line %s\n", $amidstr, $nlines;
			next;
		}
		my ($ampre, $amn, $ampost) = $amnum =~ m/^(f?)([0-9]+)(\S*)$/;
		my $amid = sprintf "%d-%s%03d%s", $rm{$amvol}, $ampre, $amn, $ampost;
		if (exists $head{$amid}) {
			printf STDERR "HEAD: Multiple AM number: [%s] at line %s\n", $amid, $nlines;
			next;
		}
		my %fields = ();
		($fields{senderloc}, $fields{date}) = parsesenderloc($amid, $senderlocdate);
		($fields{sender}, $fields{intermediary}, $fields{recipient}) = parsesenderrec($amid, $sendrec);
		$head{$amid} = [$fields{date}, $fields{sender}, $fields{senderloc}, $fields{recipient}, $fields{intermediary}];
	}
}

sub unmuckdate {
	my $date = shift;
	my ($pre, $dcomps, $post) = $date =~ m/^(.*?)([0-9\/-]+)(.*)$/;
	if (defined $pre) {
		my $dcompsrep;
		my ($day, $month, $year);
		my ($bdate, $edate) = $dcomps =~ m/^(.*?[0-9]{4})-(.*?)$/;
		if (defined $bdate) {
			($day, $month, $year) = $bdate =~ m/^([0-9-]+)\/([0-9-]+)\/([0-9-]+)$/;  
			if (!defined $day) {
				($month, $year) = $bdate =~ m/^([0-9-]+)\/([0-9-]+)$/;  
			}
			if (!defined $month) {
				($year) = $bdate =~ m/^([0-9-]+)$/;  
			}
			if (defined $day) {
				$bdate = sprintf "%04d-%02d-%02d", $year, $month, $day;
			}
			elsif (defined $month) {
				$bdate = sprintf "%04d-%02d", $year, $month;
			}
			elsif (defined $year) {
				$bdate = sprintf "%04d", $year;
			}

			($day, $month, $year) = $edate =~ m/^([0-9-]+)\/([0-9-]+)\/([0-9-]+)$/;  
			if (!defined $day) {
				($month, $year) = $edate =~ m/^([0-9-]+)\/([0-9-]+)$/;  
			}
			if (!defined $month) {
				($year) = $edate =~ m/^([0-9-]+)$/;  
			}
			if (defined $day) {
				$edate = sprintf "%04d-%02d-%02d", $year, $month, $day;
			}
			elsif (defined $month) {
				$edate = sprintf "%04d-%02d", $year, $month;
			}
			elsif (defined $year) {
				$edate = sprintf "%04d", $year;
			}
			$dcompsrep = "$bdate ... $edate";
		}
		else {
			($day, $month, $year) = $dcomps =~ m/^([0-9-]+)\/([0-9-]+)\/([0-9-]+)$/;  
			if (!defined $day) {
				($month, $year) = $dcomps =~ m/^([0-9-]+)\/([0-9-]+)$/;  
			}
			if (!defined $month) {
				($year) = $dcomps =~ m/^([0-9-]+)$/;  
			}
			if (defined $day) {
				my ($bc, $ec) = $day =~ m/^([^-]+)-([^-]+)$/;
				if (!defined $bc) {
					$dcompsrep = sprintf "%04d-%02d-%02d", $year, $month, $day;
				}
				else {
					$dcompsrep = sprintf "%04d-%02d-%02d ... %04d-%02d-%02d", $year, $month, $bc, $year, $month, $ec;
				}
			}
			elsif (defined $month) {
				my ($bc, $ec) = $month =~ m/^([^-]+)-([^-]+)$/;
				if (!defined $bc) {
					$dcompsrep = sprintf "%04d-%02d", $year, $month;
				}
				else {
					$dcompsrep = sprintf "%04d-%02d ... %04d-%02d", $year, $bc, $year, $ec;
				}
			}
			elsif (defined $year) {
				my ($bc, $ec) = $year =~ m/^([^-]+)-([^-]+)$/;
				if (!defined $bc) {
					$dcompsrep = sprintf "%04d", $year;
				}
				else {
					$dcompsrep = sprintf "%04d ... %04d", $bc, $ec;
				}
			}
			else {
				$dcompsrep = $dcomps;
			}
		}
		$date = $pre . $dcompsrep . $post;
	}
	return $date;
}

sub parsesenderloc {
	my $amid = shift;
	my $text = shift;
	if ($text =~ m/^\s*$/) {
		return ('', '');
	}
	my ($place, $date) = $text =~ m/^([^,]*),(.*)$/;
	if (!defined $place) {
		($place, $date) = $text =~ m/^(.*?)([a-z()\[\]?0-9\/-]{4,})$/;
		if (!defined $date) {
			printf STDERR "HEAD %s: parse error in loc-date [%s]\n", $amid, $text;
			$place = $text;
			$date = '';
		}
	}
	$place =~ s/^\s+//;
	$place =~ s/\s+$//;
	$date =~ s/^\s+//;
	$date =~ s/\s+$//;
	$date = unmuckdate($date);
	return ($place, $date);
}

sub parsesenderrec {
	my $amid = shift;
	my $text = shift;
	if ($text =~ m/^\s*$/) {
		printf STDERR "HEAD %s: empty senderrecipient\n", $amid;
		return ('', undef, '');
	}
	my ($sender, $intermediary, $recipient);
	($sender, $intermediary, $recipient) = $text =~ /^(.*?)[ ,]+(?:à|aux|au)[ ,]+(.*?)[ ,]+pour[ ,]+(.*)$/;
	if (!defined $sender) {
		($sender, $recipient) = $text =~ /^(.*?)[ ,]+(?:à|aux|au|contre|pour)[ ,]+(.*)$/;
	}
	if (!defined $sender) {
		printf STDERR "HEAD %s: cannot split senderrecipient in sender and recipient [%s]\n", $amid, $text;
		return ('', '');
	}
	return ($sender, $intermediary, $recipient);
}

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

sub dummy {
	1;
}

sub main {

	do_heads();
	do_meta();

	if (!open(HLO, ">:encoding(UTF-8)", $metaoutpath)) {
		print STDERR "Can't write file [$metaoutpath]\n";
		return 0;
	}
	for my $amid (@metaorder) {
		my $metainfo = $meta{$amid};
		my $headinfo = $head{$amid};
		my $mpk = $metaindex{$amid};
		my $metadata = $metaprim{$metaindex{$amid}};
		my %fields = ();
		$fields{date} = $headinfo->[0];
		$fields{mdate} = $metainfo->[0];
		$fields{sender} = $headinfo->[1];
		$fields{msender} = $metainfo->[1];
		$fields{senderloc} = $headinfo->[2];
		$fields{msenderloc} = $metainfo->[2];
		$fields{recipient} = $headinfo->[3];
		$fields{mrecipient} = $metainfo->[3];
		$fields{recipientloc} = $metainfo->[4];
		$fields{intermediary} = $headinfo->[4];
		

		for my $f (sort keys %fields) {
			my $ismeta =( $f eq 'recipientloc' or ($f =~ m/^m/));
			if (!defined $fields{$f}) {
				next;
			}
			my $text = $fields{$f};
			my ($cert, $resp);
			my $n;
			$n = $text =~ s/\?//sg;
			if ($n) {
				$cert = "medium";
			}
			$n = $text =~ s/[\[\]()]//sg;
			if ($n) {
				$resp = $ismeta?"EJB":"AM";
			}
			$fields{$f} = [[$text, $cert, $resp]];
		}
		my @lines = split /\n/, $metadata;
		for my $line (@lines) {
			my ($type) = $line =~ m/type="([^"]+)"/;
			if ($type eq 'id' or $type eq 'alt_id' or $type eq 'language') {
				push @{$fields{$type}}, $line . "\n";
				next;
			}
		}
		print HLO $mpk."\n";
		my @outputfields = ('id', 'alt_id', 'date', 'language', 'recipient', 'recipientloc', 'sender', 'senderloc', 'intermediary');
		for my $cf ('date', 'recipient', 'sender', 'senderloc') {
			my $htext = $fields{$cf}->[0]->[0];
			my $mtext = $fields{"m$cf"}->[0]->[0];
			my ($metaprevails, $newtext) = metaprevails($htext, $mtext);
			if ($metaprevails) {
				$fields{$cf}->[0] = [$newtext, $fields{"m$cf"}->[0]->[1], $fields{"m$cf"}->[0]->[2]];
			}
		}
		for my $f (@outputfields) {
			if (!defined $fields{$f} and $f eq 'intermediary') {
				next;
			}
			for my $item (@{$fields{$f}}) {
				if (ref $item) {
					my ($text, $cert, $resp) = @$item;
					my $extraatts = '';
					if (defined $cert) {
						$extraatts .= " cert=\"$cert\"";
					}
					if (defined $resp) {
						$extraatts .= " resp=\"$resp\"";
					}
					print HLO "<meta type=\"$f\" value=\"$text\"$extraatts/>\n";
				}
				else {
					print HLO $item;
				}
			}
		}
		print HLO "===\n";
	}
	close HLO;
}

sub metaprevails {
	my ($ht, $mt) = @_;
	if ((!defined $ht or $ht eq '') and (defined $mt and $mt ne '')) {
		return (1, "EJB: $mt");
	}
	if ((defined $ht and $ht eq lc($ht)) and (defined $mt and $mt ne lc($mt))) {
		return (1, "$ht EJB: $mt");
	}
	return (0, $ht);
}

exit !main();
