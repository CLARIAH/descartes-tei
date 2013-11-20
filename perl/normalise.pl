#!/usr/bin/perl
use strict;
use warnings;
no warnings "uninitialized";
no strict "refs";

use utf8;

use XML::Simple;
use Data::Dump qw(dump);

my %hints = (
	persons => {
		Bannius					=> "Bannius:Johannes-Albertus:1598-1644",
		Brasset					=> "Brasset:Henri:fl-1591-1658",
		Beeckman				=> "Beeckman:Isaac:1588-1637",
		'Brandt, Gerrit'		=> "Brandt:Geraert:1626-1685",
		Brégy					=> "Flécelles:Nicolas:1615-1689",
		Bruno					=> "Bruno:Henrick:1617-1664",
		Christine				=> "Zweden:Christina:1626-1689",
		'Christine de Suède'	=> "Zweden:Christina:1626-1689",
		Colvius					=> "Colvius:Andreas:1594-1671",
		'Curators of the university of Leiden'	=> "Leiden:curators-university",
		'De Sainte-Croix'		=> "Jumeau:André:1588-1651",
		Descartes				=> "Descartes:Rene:1596-1650",
		'Descartes, Joachim'	=> "Descartes:Joachim:1563-1640",
		'Descartes, Joachim II'	=> "Descartes:Joachim:1602-1680",
		Elisabeth				=> "Pfalz:Elisabeth:1618-1680",
		Fermat					=> "Fermat:Pierre:1601-1665",
		Freinshemius			=> "Freinsheim:Johannes-Caspar:1608-1660",
		Frenicle				=> "Frénicle-de-Bessy:Bernard:1605-1675",
		Haestrecht				=> "Haestrecht:Godefridus:fl:1624-1643",
		Habert					=> "Habert-de-Cérisy:Germain:1615-1654",
		'Habert, Germain'		=> "Habert-de-Cérisy:Germain:1615-1654",
		Hogelande				=> "Hogelande:Cornelis:1590-1662",
		'Le Conte'				=> "Conte:Antoine:fl-1646",
		Huygens					=> "Huygens:Constantijn:1596-1687",
		'La Thuillerie'			=> "Thuillerie:Gaspard-Coignet:1594-1653",
		'Markies van Newcastle'	=> "Cavendish:William:1592-1676",
		Noël					=> "Noël:Étienne:1581-1659",
		Noel					=> "Noël:Étienne:1581-1659",
		Rivet					=> "Rivet:Andre:1572-1651",
		Schooten				=> "Schooten:Frans:1615-1660",
		Servien					=> "Servient:Abel:1593-1659",
		Sophie					=> "Pfalz:Sophie:1630-1714",
		'University of Groningen'	=> "Groningen:university",
		'Van Foreest'			=> "Foreest:Jan:1586-1651",
		Vorstius				=> "Vorstius:Adolphus:1597-1663",
		'Vroedschap Utrecht'	=> "Utrecht:vroedschap",
		Wevelichoven			=> "Wevelinchoven:Jan",
		Wicquefort				=> "Wicquefort:Joachim:1600-1670",
		Wilhem					=> "Leu-de-Wilhem:David:1588-1658",
	},
	places => {
		Bolberg					=> "Budberg, DE",
		Brussels				=> "Brussel, BE",
		Crossen					=> "Krossen, DE",
		Endegeest				=> "Oestgeest, NL",
		'Fort de Nassau'		=> "Heerewaarden (Fort Voorne), NL",
		Louvain					=> "Leuven, BE",
		Panderen				=> "Pannerden, NL",
		Santporte				=> "Santpoort, NL",
		"'s-Hertogenbosch"		=> "Den Bosch, NL",
		'The Hague'				=> "Den Haag, NL",
		Voorne					=> "Heerewaarden (Fort Voorne), NL",
	},
);

=head2 Notes

NB Jean Brasset in CKCC dbase moet ongetwijfeld zijn Henri Brasset

=cut

my $rootdir = '/Users/dirk/Data/DANS/projects/CKCC/descartes';
my $versiondir = '2012-01-17';
my $datadir = 'data';
my $logdir = 'messages';
my $resdir = 'result';
my $inputdir = 'input';
my $srcdir = 'input';
my $entdir = 'entities';
my $reviewdir = 'review';

my $metafile = "metadatadef.txt";
my $metaoutfile = "metadatacanon.txt";
#my $personsifile = "person-concordance.txt";
my $personsifile = "persons.xml";
my $personsiifile = "personsnew.EJB.xml";
my $placesifile = "places.txt";
my $placesiifile = "placesnew.EJB.txt";
my $personsnfile = "personsnorm.txt";
my $placesnfile = "placesnorm.txt";
my $personswfile = "personsnew.txt";
my $placeswfile = "placesnew.txt";
my $errfile = "normalise.txt";

my $datapath = "$rootdir/$versiondir/$datadir";
my $respath = "$rootdir/$versiondir/$resdir";
my $inputpath = "$rootdir/$versiondir/$inputdir";

my $reviewpath = "$respath/$reviewdir";
my $entpath = "$inputpath/$entdir";
my $logpath = "$respath/$logdir";

my $metapath = "$datapath/$metafile";
my $metaoutpath = "$reviewpath/$metaoutfile";
my $personsipath = "$entpath/$personsifile";
my $personsiipath = "$entpath/$personsiifile";
my $placesipath = "$entpath/$placesifile";
my $placesiipath = "$entpath/$placesiifile";
my $personsnpath = "$reviewpath/$personsnfile";
my $placesnpath = "$reviewpath/$placesnfile";
my $personswpath = "$reviewpath/$personswfile";
my $placeswpath = "$reviewpath/$placeswfile";

my $errpath = "$logpath/$errfile";

my %personsi = ();
my %placesi = ();
my %personso = ();
my %placeso = ();
my %personsn = ();
my %placesn = ();
my %sresults = ();

my %workhints = ();

my %errors = ();

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
	my $metasrc = readfile($metapath);
	printf "%s=%d lines\n", $metafile, (scalar @$metasrc);

	#my $personsixml = {};
	my $personsixml = XMLin($personsipath);
	my $personsiixml = XMLin($personsiipath);

	my $placesisrc = readfile($placesipath);
	my $placesisrc2 = readfile($placesiipath);
	push @$placesisrc, @$placesisrc2;
	chomp @$placesisrc;
	printf "%s=%d places\n", $placesifile, (scalar @$placesisrc);

	for my $hint (keys %{$hints{persons}}) {
		$workhints{persons}->{trimperson($hint)} = $hints{persons}->{$hint};
	}
	for my $hint (keys %{$hints{places}}) {
		$workhints{places}->{trimplace($hint)} = $hints{places}->{$hint};
	}

	if (!open(PRLO, ">:encoding(UTF-8)", $personsnpath)) {
		print STDERR "Can't write file [$personsnpath]\n";
		return 0;
	}
	if (!open(PLLO, ">:encoding(UTF-8)", $placesnpath)) {
		print STDERR "Can't write file [$placesnpath]\n";
		return 0;
	}
	if (!open(WRLO, ">:encoding(UTF-8)", $personswpath)) {
		print STDERR "Can't write file [$personswpath]\n";
		return 0;
	}
	if (!open(WLLO, ">:encoding(UTF-8)", $placeswpath)) {
		print STDERR "Can't write file [$placeswpath]\n";
		return 0;
	}
	if (!open(ER, ">:encoding(UTF-8)", $errpath)) {
		print STDERR "Can't write file [$errpath]\n";
		return 0;
	}

# build index of used persons and places from metadata

	my $metatext = join "", @$metasrc;
	my (@people) = $metatext =~ m/type="(?:recipient|sender)"\s*value="([^"]*)"/sg;
	my (@places) = $metatext =~ m/type="(?:recipient|sender)loc"\s*value="([^"]*)"/sg;
	for my $item (@people) {
		$personso{$item}++;
	}
	for my $item (@places) {
		$placeso{$item}++;
	}

# build index of normalised persons

	my $np = 0;
	for my $p (@{$personsixml->{person}},@{$personsiixml->{person}}) {
		$np++;
		my $code = $p->{'xml:id'};
		printf STDERR "\r%4d\t%s\t\t\t", $np, $code;
		my $names;
		my $nameinfo = $p->{persName};
		if (ref($nameinfo) eq 'HASH') {
			$names = [$nameinfo];
		}
		elsif (ref($nameinfo) eq 'ARRAY') {
			$names = $nameinfo;
		}
		for my $name (@$names) {
			my $surname = $name->{surname}; 
			my $middle = $name->{nameLink}; 
			my $fname = $name->{forename}; 
			my $lname = $middle.($middle?' ':'').$surname;
			my $tsname = trimperson($surname);
			my $tlname = trimperson($lname);
			my $tfname = trimperson($fname);
			if ($tsname ne '') {
				$personsi{$tsname}->{$code}++;
			}
			if ($tlname ne '') {
				$personsi{$tlname}->{$code}++;
			}
			if ("$tlname$tfname" ne '') {
				$personsi{$tlname.','.$tfname}->{$code}++;
			}
		}
	}
	print STDERR "\n";

# build index of normalised places

	my $nnewc = 0;
	for my $line (@$placesisrc) {
		if ($line =~ m/^--/) {
			next;
		}
		my @fields = split /;/, $line;
		for my $f (@fields) {
			$f =~ s/^"//;
			$f =~ s/"$//;
		}
		my ($nname, $dname, $place, $region, $country, $lat, $long) = @fields;
		my ($pname, $lname) = $nname =~ m/^([^,]+),\s*(.*)$/s;
		my $tpname = trimplace($pname);
		if ($tpname ne '') {
			$placesi{$tpname}->{$nname}++;
		}
	}
	printf STDERR "Constructed %d new codes\n", $nnewc;

	my %stats;

	my %results;
	my %nresults;

# match used persons with normalised persons

	%results = ();
	%nresults = ();
	for my $uname (sort keys %personso) {
		my $result = lookupperson($uname);
		my ($nnameset, $nname, $tname, $kind) = @$result;
		$results{$kind}->{$uname}->{$nname}->{$tname}++;
		$nresults{$uname}->{$tname}->{$nname}->{$kind}++;
		for my $nn (@$nnameset) {
			$sresults{persons}->{$uname}->{$nn} = 1;
		}
	}

	%stats = ();

# write the results to file

	printf PRLO "%-4s%-40s %20s = [%s]\n", 'OK?', 'used name', '<match-name>', 'normalised names';
	print PRLO ("=" x 80), "\n";

	for my $uname (sort keys %nresults) {
		my $tnames = $nresults{$uname};
		for my $tname (sort keys %$tnames) {
			my $nnames = $tnames->{$tname};
			for my $nname (sort keys %$nnames) {
				my $kinds = $nnames->{$nname};
				for my $kind (sort keys %$kinds) {
					printf PRLO "%-4s%-40s %20s = [%s]\n", $kind, $uname, "<$tname>", $nname;
					$stats{$kind}++;
				}
			}
		}
	}

	printf "PERSONS:\n";
	print PRLO ("=" x 80), "\n";
	for my $kind (sort keys %stats) {
		printf "%s : %d\n", $kind, $stats{$kind};
		printf PRLO "%s : %d\n", $kind, $stats{$kind};
	}

# write the unmatched persons separately to file

	my %newpersons = ();
	for my $uname (sort keys %nresults) {
		my $tnames = $nresults{$uname};
		for my $tname (sort keys %$tnames) {
			my $nnames = $tnames->{$tname};
			for my $nname (sort keys %$nnames) {
				my $kinds = $nnames->{$nname};
				for my $kind (sort keys %$kinds) {
					if ($kind eq 'XXX') {
						$newpersons{$uname}->{$uname} = 1;
					}
				}
			}
		}
	}
	for my $code (sort keys %newpersons) {
		my $names = $newpersons{$code};
		my $namexml = '';
		for my $name (sort keys %$names) {
			my $att = '';
			if ($name =~ m/ /) {
				$att = " type=\"complex\"";
			}
			$namexml .= " <persName>
  	<forename></forename>
    <nameLink></nameLink>
    <surname$att>$name</surname>
  </persName>";
		}
		print WRLO "<person xml:id=\"$code::16??-16??\">
<person>
  $namexml
  <death when=\"16??-??-??\"/>
  <sex value=\"1\">male</sex>
  <occupation></occupation>
  <xref>CEN::</xref>
</person>
";
	}

# match used places with normalised places

	%results = ();
	%nresults = ();

	for my $uname (sort keys %placeso) {
		my $result = lookupplace($uname);
		my ($nnameset, $nname, $tname, $kind) = @$result;
		$results{$kind}->{$uname}->{$nname}->{$tname}++;
		$nresults{$uname}->{$tname}->{$nname}->{$kind}++;
		for my $nn (@$nnameset) {
			$sresults{places}->{$uname}->{$nn} = 1;
		}
	}

	%stats= ();

# write the results to file

	printf PLLO "%-4s%-40s %20s = [%s]\n", 'OK?', 'used name', '<match-name>', 'normalised names';
	print PLLO ("=" x 80), "\n";

	for my $uname (sort keys %nresults) {
		my $tnames = $nresults{$uname};
		for my $tname (sort keys %$tnames) {
			my $nnames = $tnames->{$tname};
			for my $nname (sort keys %$nnames) {
				my $kinds = $nnames->{$nname};
				for my $kind (sort keys %$kinds) {
					printf PLLO "%-4s%-40s %20s = [%s]\n", $kind, $uname, "<$tname>", $nname;
					$stats{$kind}++;
				}
			}
		}
	}

	printf "PLACES:\n";
	print PLLO ("=" x 80), "\n";
	for my $kind (sort keys %stats) {
		printf "%s : %d\n", $kind, $stats{$kind};
		printf PLLO "%s : %d\n", $kind, $stats{$kind};
	}

# write the unmatched places separately to file

	my %newplaces = ();
	for my $uname (sort keys %nresults) {
		my $tnames = $nresults{$uname};
		for my $tname (sort keys %$tnames) {
			my $nnames = $tnames->{$tname};
			for my $nname (sort keys %$nnames) {
				my $kinds = $nnames->{$nname};
				for my $kind (sort keys %$kinds) {
					if ($kind eq 'XXX') {
						$newplaces{$uname}->{$uname} = 1;
					}
				}
			}
		}
	}
	for my $code (sort keys %newplaces) {
		my $names = $newplaces{$code};
		for my $name (sort keys %$names) {
			printf WLLO "%s;\"%s, NL\"\n", $code, $name;
		}
	}

	close PRLO;
	close PLLO;
	close WRLO;
	close WLLO;
	
# create a new version of the metadatadef file (metadatacanon) where the names of persons and places are replaced by their codes
# if the person or place is new, write a pseudo code (containing ??)
# if there are multiple matches, include them, separated by ??

	my %replacekeys = (
		sender => 1,
		senderloc => 2,
		recipient => 1,
		recipientloc => 2,
		intermediary => 1,
	);
	%stats = ();

	if (!open(C, ">:encoding(UTF-8)", $metaoutpath)) {
		print STDERR "Can't write file [$metaoutpath]\n";
		return 0;
	}
		for my $line (@$metasrc) {
			my ($key, $value) = $line =~ m/<meta type="([^"]*)" value="([^"]*)"/;
			if (defined $key and $replacekeys{$key}) {
				$stats{'5-metavalues'}++;
				if ($replacekeys{$key} == 1) {
					$stats{'4-personsvalues'}++;
					my $nvalues = $sresults{persons}->{$value};
					my $nvaluerep;
					if (!defined $nvalues) {
						$nvalues = {};
					}
					my @nvalues = sort keys %$nvalues;
					$nvaluerep = join ' ?? ', @nvalues;
					if (scalar(@nvalues) == 0) {
						if ($value eq '') {
							$nvaluerep = '';
							$stats{'0-personsvalue-empty'}++;
						}
						else {
							$nvaluerep = '??';
							$stats{'3-personsvalue-notfound'}++;
						}
					}
					elsif (scalar(@nvalues) > 1) {
						$stats{'2-personsvalue-multiple'}++;
					}
					else {
						$stats{'1-personsvalue-resolved'}++;
					}
					$line =~ s/<meta type="([^"]*)" value="([^"]*)"/<meta type="$1" value="$nvaluerep" origvalue="$2"/;
				}
				elsif ($replacekeys{$key} == 2) {
					$stats{'4-placesvalues'}++;
					my $nvalues = $sresults{places}->{$value};
					my $nvaluerep;
					if (!defined $nvalues) {
						$nvalues = {};
					}
					my @nvalues = sort keys %$nvalues;
					$nvaluerep = join ' ?? ', @nvalues;
					if (scalar(@nvalues) == 0) {
						if ($value eq '') {
							$nvaluerep = '';
							$stats{'0-placesvalue-empty'}++;
						}
						else {
							$nvaluerep = '??';
							$stats{'3-placesvalue-notfound'}++;
						}
					}
					elsif (scalar(@nvalues) > 1) {
						$stats{'2-placesvalue-multiple'}++;
					}
					else {
						$stats{'1-placesvalue-resolved'}++;
					}
					$line =~ s/<meta type="([^"]*)" value="([^"]*)"/<meta type="$1" value="$nvaluerep" origvalue="$2"/;
				}
			}
			print C $line;
		}
	close C;

	for my $kind (sort keys %stats) {
		printf "%s : %d\n", $kind, $stats{$kind};
	}

	for my $errkind (sort keys %errors) {
		my $messages = $errors{$errkind};
		my $nkind = scalar @$messages;
		printf ER "%-40s: %5d\n", $errkind, $nkind;
		printf STDERR "%-40s: %5d\n", $errkind, $nkind;
	}

	for my $errkind (sort keys %errors) {
		my $messages = $errors{$errkind};
		my $nkind = scalar @$messages;
		printf ER "%-40s: %5d\n", $errkind, $nkind;
		print ER @$messages;
		print ER "\n";
	}
	close ER;
}

sub lookupperson {
	my $name = shift;
	my $uname = trimperson($name);
	my $nnrep;
	my $kind;
	my $comments;
	my $nnames;

	if (exists $workhints{persons}->{$uname}) {
		my $hint = $workhints{persons}->{$uname};
		if (defined $hint) {
			return [[$hint], $hint, $uname, 'HIN'];
		}
		else {
			return [[], '', $uname, 'XXH'];
		}
	}

	$nnames = $personsi{$uname};
	my @nnameset = ();

	if ($uname eq '') {
		$nnrep = '';
		$kind = '---';
	}
	elsif (defined $nnames) {
		@nnameset = sort keys %$nnames;
		$nnrep = join "][", (@nnameset);
		my $choices = scalar keys %$nnames;
		$kind = sprintf "%3d", $choices;
	}
	else {
		$nnrep = '';
		$kind = 'XXX';
	}
	return [\@nnameset, $nnrep, $uname, $kind];
}

sub lookupplace {
	my $name = shift;
	my $uname = trimplace($name);
	my $nnrep;
	my $kind;
	my $comments;
	my $nnames;

	if (exists $workhints{places}->{$uname}) {
		my $hint = $workhints{places}->{$uname};
		if (defined $hint) {
			return [[$hint], $hint, $uname, 'HIN'];
		}
		else {
			return [[], '', $uname, 'XXH'];
		}
	}

	$nnames = $placesi{$uname};
	my @nnameset = ();

	if ($uname eq '') {
		$nnrep = '';
		$kind = '---';
	}
	elsif (defined $nnames) {
		@nnameset = sort keys %$nnames;
		$nnrep = join "][", (@nnameset);
		my $choices = scalar keys %$nnames;
		$kind = sprintf "%3d", $choices;
	}
	else {
		$nnrep = '';
		$kind = 'XXX';
	}
	return [\@nnameset, $nnrep, $uname, $kind];
}

sub trimperson {
	my $str = shift;

	$str = lc $str;

	$str =~ s/[^a-z,]//sgi;

	$str =~ s/c[gh]/g/g;

	$str =~ s/[dt]+/d/g;
	$str =~ s/[ckxq]+/k/g;
	$str =~ s/[ijy]+/i/g;

	return $str;
}

sub trimplace {
	my $str = shift;

	$str = lc $str;

	$str =~ s/[^a-z,]//sgi;

	$str =~ s/c[gh]/g/g;

	$str =~ s/[dt]+/d/g;
	$str =~ s/[ckxq]+/k/g;
	$str =~ s/[ijy]+/i/g;

	return $str;
}

sub roughtrimplace {
	my $str = shift;

	$str =~ s/\([^)]*\)//g;
	$str =~ s/[A-Z]\.//g;

	$str = lc $str;

	$str =~ s/unknown//g;

	$str =~ s/^\s+//;
	$str =~ s/\s+$//;

	$str =~ s/\s*\xe0\s+/\|/g; # à
	$str =~ s/\s*\/\s*/\|/g; # à
	$str =~ s/\s*near\s+by\s+/\|/g; # à
	$str =~ s/\s*near\s+/\|/g; # à
	$str =~ s/\s*or\s+/\|/g; # à

	$str =~ s/,//g;

	$str =~ s/en\s+/ /g;
	$str =~ s/\s+de\s+/ /g;

	$str =~ s/[^a-z|]//sgi;

	$str =~ s/ae/a/g;
	$str =~ s/gh/g/g;
	$str =~ s/c[gh]/g/g;
	$str =~ s/u/o/g;

	$str =~ s/[dt]+/d/g;
	$str =~ s/[ckxq]+/k/g;
	$str =~ s/[ijy]+/i/g;

	return $str;
}

exit !main();
