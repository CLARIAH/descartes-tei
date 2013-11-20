#!/usr/bin/perl

=head1 Colofon

Conversion development environment for converting the Descartes Corpus.
Source format: the JapAM edition: plain unicode text with line numbers plus illustrations in gif.
Target format: (pseudo) TEI, plus TeX-typeset formulas in gif, plus extra symbols in gif/png, plus same illustrations in gif.

Authors: 

Erik-Jan Bos <Erik-Jan.Bos@phil.uu.nl> (specialist on Descartes, supplier of extra metadata)
Dirk Roorda <dirk.roorda@dans.knaw.nl> (specialist on conversions, author of this program)

Project:
CKCC (Circulation of Knowledge ... Collaboratory of Correspondences) <http://www.huygens.knaw.nl/en/ckcc-%E2%80%9Cgeleerdenbrieven%E2%80%9D/>

Timeframe of this conversion:
2011, October-December
Current date: 2012-01-17
 
=head1 Installation Instructions

This is a nearly self contained Perl Script, it does not call other user-developed Perl modules. It does call TeX and related programs, though.
It requires, however, some modules that might have to been added to the perl installation.
These are Time, Time::HiRes, File::Path, File::Copy.

The script calls programs from the TeXLive distribution. Make sure the following commands can be run from the command-line:
	tex
	xetex
	dvipng
If that is the case, this script will run without telling where TeXLive is located.

=head1 Environment

This script presupposes an environment with a number of directories, filled with all kinds of material.
After unzipping the package of which this script is part, adjust the sections marked with BEGIN CUSTOMISE ... END CUSTOMISE
to the local situation. (This is only a path leading to where this package has been unpacked, and possibly a different version).

=head1 Running the conversion

The script can be run from the commandline, positioned in the directory of this script.
If given no arguments, the complete conversion process will be executed.
It is also possible to execute selected steps only. See the section commandlines below.

=head1 About the sources and results

The script takes as input most of the material in the data directory (and subdirectories) and nothing else.
The script produces as results (directory results):
* subdirectory texts: converted texts (end result and all intermediate stages)
* subdirectory messages: per conversion step:  information of what has been encountered, warnings, errors 
* subdirectory review: selected information extracted from inut and result, to be checked. Corrected version must be manually copied to the data directory in order to be included in a next conversion run
* subdirectory formulas: gif or svg representation of all formulas that have been typeset with TeX during the conversion run
* subdirectory formulatex: contains a pdf with all formulas, on pages corresponding to the AM edition. For proofreading.

The directory input contains a loosely organised quantity of source materials. Some of it has been prepared as source for the conversion process, and moved to the data directory. Nothing in the input directory is required by the conversion in order to run and produce results.

=head1 Commandlines

=head2 perl convert.pl

Do all tasks

=head2 ./convert.pl taskname1-taskname2

Do all tasks from taskname1 til (including) taskname2
If taskname1 is omitted, start with the first task.
If taskname2 is omitted, continue till the last task
If the - is omitted and also one of taskname1 or taskname2, execute the specified task only

=head1 Source observations

=head2 codes with #...#

#astérisque3#		=> do_trans			Three daggers								=> unicode string
#cit ... #end		=> do_trans			No visible meaning, occurs only once		=> source adaption made
#gre ... #end		=> do_greek			Greek character runs						=> characters translated to Unicode
#cos1#				=> do_formulas		cossic symbol 1	(outside TeX)				=> graphic cossic1.png
#cos2#				=> do_formulas		cossic symbol 2	(outside TeX)				=> graphic cossic2.png
#musique1#			=> do_trans			Music: G-clef with bars						=> graphic musique.png inline
#point#				=> do_trans			A dot										=> .
#point25#			=> do_trans			Linefill with dots							=>   [...] (paragraph with 3 dots
#infinitum#			=> do_formulas 		variant on equals sign						=> graphic propto.png = hor.flipped \propto, ∝
										occurs in TeX, cannot deal with that: split formula in three parts, so that #infinitum# outside TeX
. (escaped as ¡)	=> do_formulas		.											=> .
NB: #infinitum# and = !!! I see that
	where JapAM has =, the facsimile has the reversed \propto symbol (AM4L233F047)
	where JapAM has #infinitum#, the facsimile has the || symbol 
NB: squares are coded as @x@x. I typeset them as x^{2}, controlled by the switch: detect_squares

a#¢t£#9il
#chanut
#dordrecht
#fermat
#mersenne
#Pag.
#sle>#

##cit
##pag

<nt ...> <nt1 ...>	Marginal indicators. Some have been recoded as <mt A-Z> 
					others have been transformed into normal text.
<mt A-Z>			In fact a marginal note, coming from <nt(1)> by Erik-Jan and Dirk: <add place="margin">A-Z</margin>
<g>					gauche (left align, left column)
<c>					centre (mid align, mid column); 
<d>					droite (right align, right column);
<d end>				has been removed
N.B. near <c> and <d> page numbers <m xxx> are repeated, I have removed it.

=head1 formulas

" ... "				grouping
‚" ... ‚"			nested grouping
\'d9 .... \'c4		squareroot
\'d9 .... \'e4		also a squareroot, I think
\'f9 .... \'e4		also a squareroot, I think
\Ÿ .... \ƒ			sqareroot (genest)
\" .... "			sqareroot (genest)
\					also a squareroot, but simple, only over next symbol(group)
\C					cubic root, only once!
÷					in TeX: \over (much ado with braces), outside TeX: simply /
/					in TEI /, in TeX: \slash (a fraction of the form x / y without stacking)
≥ .... ¥			superscript
º .... ¿			subscript
+-					plus of min ±
|					single bar in TeX: \vert
||					double bar in TeX: \Vert
~					hard space (tweaked into JapAM by Dirk and Erik-Jan
@					variable symbol: the next character is a letter to be interpreted as a variable in a formula
&					same as @, but the symbol should stay roman (added by Dirk, occurrences where it has been added automatically:
						in every sequence of 2 or more capital roman vaiables, @ has been replaced by &
						Erik-Jan has indicated more occurrences where @ should be replaced by &
€					same as @, but the symbol is explicitly italic (added by Dirk, occurrences where it has been added automatically:

♠					displayed equation marker. If it occurs anywhere in a formula, it signals that the whole formula should be typeset
						as a displayed equation (in the TeX sense). The symbol has no other function


=head2 italics

I remove all italic scopes out of formulas, because what is italic and not is governed by rules.
Formulas outside TeX: no italic.
Formulas inside TeX: follow the TeX rules.

=head2 verbeteringen

See the lines with ! in the JapAM source

=head2 headings

space space starts a paragraph, in JapAM. Sometimes we need to start a heading:

space space §h4§ space	will start a heading. 

It will be translated to a normal <p> element, but with the text in a <hi rend="h4"> subelement
Any other text than h4 will translate into the value of the rend attribute.

<div type="para">
Sometimes a paragraph should be surrounded by a <div type="para"> .. </div>
That effect can be achieved by letting the paragraph start with

space space ±

=head2

Metadata values: 

tussen [ en ] : cert="high"
tussen ( en ): cert ="high"
met ? : cert="low"
combinatie van []/() en ?: cert="low"

resp attribuut: alleen resp="EJB" en dat komt alleen voor als we metadata van EJB gebruiken, en dat komt alleen voor in senderloc en recipientloc, maar niet overal.

=cut

use utf8;
use strict;
use warnings;
no warnings "uninitialized";
no strict "refs";

use File::Copy;
use File::Path qw(mkpath rmtree);

use Time::HiRes qw (gettimeofday time tv_interval);
use Time::localtime;

# o-o-o BEGIN CUSTOMISE o-o-o #

my $rootdir = '/Users/dirk/Data/DANS/projects/CKCC/descartes';
my $versiondir = '2012-01-17';

#my $formulaformat = 'svg';
my $formulaformat = 'gif';

# o-o-o END   CUSTOMISE o-o-o #

my $datadir = 'data';
my $resdir = 'result';
my $logdir = 'messages';
my $outputdir = 'texts';
my $reviewdir = 'review';
my $formulasdir = "formulas-$formulaformat";
my $texdir = 'formulatex';

my $editionfile = "JapAM.txt";
my $metafile = "metadatacanon.txt";
my $imagefile = "imagemap.txt";
my $headfile = "head.txt";

my $errfile = "convert.txt";
my $convertfile = "JapAM-EJB-DR.txt";
my $convertxmlfile = "JapAM-EJB-DR.xml";
my $converttexfile = "JapAM-EJB-DR.tex";
my $imagesdir = "illustrations";
my $symbolsdir = "symbols";
my $formulafile = "formulas.txt";
my $formulaoutfile = "formulasout.txt";
my $formulapagfile = "formulapages.txt";
my $formulasizefile = "_formulasizes.txt";
my $formulatexifile = "formulas.tex";
my $formuladviifile = "formulas.dvi";
my $greekfile = "greek.txt";
my $headoutfile = "headsout.csv";
my $openeroutfile = "openerout.txt";
my $closeroutfile = "closerout.txt";
my $closerxoutfile = "closerxout.txt";
my $closerinfile = "closerin.txt";
my $closerxinfile = "closerxin.txt";

my $respath = "$rootdir/$versiondir/$resdir";
my $datapath = "$rootdir/$versiondir/$datadir";

my $logpath = "$respath/$logdir";
my $outputpath = "$respath/$outputdir";
my $reviewpath = "$respath/$reviewdir";
my $texpath = "$respath/$texdir";
my $formulaspath = "$respath/$formulasdir";
my $formulasizepath = "$respath/$formulasdir/$formulasizefile";

my $editionpath = "$datapath/$editionfile";
my $metapath = "$datapath/$metafile";
my $imagepath = "$datapath/$imagefile";
my $headpath = "$datapath/$headfile";
my $closerinpath = "$datapath/$closerinfile";
my $closerxinpath = "$datapath/$closerxinfile";
my $imagespath = "$datapath/$imagesdir";
my $symbolspath = "$datapath/$symbolsdir";

my $errpath = "$logpath/$errfile";
my $convertpath = "$outputpath/$convertfile";
my $convertxmlpath = "$outputpath/$convertxmlfile";

my $formulaoutpath = "$reviewpath/$formulaoutfile";
my $formulapagpath = "$texpath/$formulapagfile";
my $formulatexipath = "$texpath/$formulatexifile";
my $formuladviipath = "$texpath/$formuladviifile";

my $formulapath = "$reviewpath/$formulafile";
my $greekpath = "$reviewpath/$greekfile";
my $headoutpath = "$reviewpath/$headoutfile";
my $openeroutpath = "$reviewpath/$openeroutfile";
my $closeroutpath = "$reviewpath/$closeroutfile";
my $closerxoutpath = "$reviewpath/$closerxoutfile";

my @tasks = (
	'escape',				# escape the italic markings and backslashes, because they will interfere with formulas
	'greek',				# greek character translation
	'trans',				# character codes translated to symbols
	'hyphen9',				# replace weird usage of 9 as hyphen by real hyphen
	'meta',					# insert metadata per letter on the basis of EJB export
	'heads',				# insert headings per letter on the basis of EJB material
	'images',				# insert image links, based on EJB export
	'lines',				# remove line numbers, end-of-line hyphens, make paragraph structure
	'formit',				# formula symbols in italic scope
	'enmarge',				# handle marginal notes
	'openers',				# mark-up opening sections, based on heuristics
	'closers',				# mark-up closing sections, based on even more heuristics
	'pagenumbers',			# mark-up page breaks, special attention to in-word ones
	'ququ',					# remove ?? markers
	'brackets',				# replace #( ... )# by ( ... )
	'abbrev',				# replace marked abbreviations ##xxx(.) by xxx.
	'formulas',				# translate formulas in the source into TEI/TeX
	'formset',				# translate tex formulas to individual gif or svg files
	'italic',				# translate remaining italic markers into TEI <hi rend="i">
	'atat',					# remove @@ markers
	'superscript',			# translate remaining superscript markers into TEI <hi rend="sup">
	'marginals',			# translate marginal indicators into TEI <add place="margin>
	'headings',				# translate paragraphs starting with §xx§ to <hi rend="xxx">, also treat ±
	'tidyup',				# remove XML comments <!-- ... -->; other tidyings
	'checkxml',				# check the well-formedness of the individual letters
);

my @mois = (
	'Janvier',
	'Février',
	'Mars',
	'Avril',
	'Mai',
	'Juin',
	'Juillet',
	'Août',
	'Septembre',
	'Octobre',
	'Novembre',
	'Décembre',
);

my %greekmath = (
	α => '\alpha ',
	Α => '\Alpha ',
	β => '\beta ',
	Β => '\Beta ',
	γ => '\gamma ',
	Γ => '\Gamma ',
	δ => '\delta ',
	Δ => '\Delta ',
	ε => '\epsilon ',
	Ε => '\Epsilon ',
	ζ => '\zeta ',
	Ζ => '\Zeta ',
	η => '\eta ',
	Η => '\Eta ',
	θ => '\theta ',
	Θ => '\Theta ',
	ι => '\iota ',
	Ι => '\Iota ',
	κ => '\kappa ',
	Κ => '\Kappa ',
	λ => '\lambda ',
	Λ => '\Lambda ',
	μ => '\mu ',
	Μ => '\Mu ',
	ν => '\nu ',
	Ν => '\Nu ',
	ξ => '\xi ',
	Ξ => '\Xi ',
	ο => 'o',
	Ο => 'O',
	π => '\pi ',
	Π => '\Pi ',
	ρ => '\rho ',
	Ρ => '\Rho ',
	σ => '\sigma ',
	Σ => '\Sigma ',
	τ => '\tau ',
	Τ => '\Tau ',
	υ => '\upsilon ',
	Υ => '\Upsilon ',
	φ => '\phi ',
	Φ => '\Phi ',
	χ => '\chi ',
	Χ => '\Chi ',
	ψ => '\psi ',
	Ψ => '\Psi ',
	ω => '\omega ',
	Ω => '\Omega ',
);

my %greek = (
	a => 'α',
	b => 'β',
	g => 'γ',
	d => 'δ',
	e => 'ε',
	z => 'ζ',
	h => 'η',
	q => 'θ',
	i => 'ι',
	k => 'κ',
	l => 'λ',
	m => 'μ',
	n => 'ν',
	c => 'ξ',
	o => 'ο',
	'0' => 'ο',
	r => 'π',
	p => 'ρ',
	s => 'σ',
	t => 'τ',
	y => 'υ',
	u => 'υ',
	f => 'φ',
	x => 'χ',
	j => 'ψ',
	w => 'ω',
	'@' => 'ς',
	'4a' => 'ά',
	'4e' => 'έ',
	'é' => 'έ',
	'4h' => 'ή',
	'4i' => 'ί',
	'4o' => 'ό',
	'40' => 'ό',
	'4y' => 'ύ',
	'4u' => 'ύ',
	'4w' => 'ώ',
	'5a' => 'ᾶ',
	'5h' => 'ῆ',
	'5i' => 'ῖ',
	'î' => 'ῖ',
	'5y' => 'ῦ',
	'5u' => 'ῦ',
	'û' => 'ῦ',
	'5w' => 'ῶ',
	'2a' => 'ἀ',
	'2e' => 'ἐ',
	'2h' => 'ἠ',
	'2i' => 'ἰ',
	'2o' => 'ὀ',
	'2y' => 'ὐ',
	'2u' => 'ὐ',
	'2w' => 'ὠ',
	'6i' => 'ὶ',
	'6o' => 'ὸ',
	'ò' => 'ὸ',
	'24a' => 'ἄ',
	'24e' => 'ἔ',
	'2é' => 'ἔ',
	'25u' => 'ὖ',
	'2û' => 'ὖ',
	'34o' => 'ὃ',
);
 
my @trans = (
	['¢', '['],
	['£', ']'],
	['<<', '«'],
	['>>', '»'],
	['#<', '⊂'], # at the end to be translated to &lt;
	['>#', '⊃'], # at the end to be translated to &gt;
	['#end', ''], # Only occurs combined with #gre or #cit. Can be removed after #gre ... # end are processed (do_greek).
	['#point#', '.'], 
	['#point25#', '  [...]'],
	['#musique1#', '<figure rend="inline"><graphic url="musique.png"/></figure>'],
	['#astérisque3#', '†††'],
);

# the following images: do not warn if they are multiply used

my %nowarnmultimage = (
	'musique.png' => 1,
	'propto.png'  => 1,
	'cossic1.png' => 1,
	'cossic2.png' => 1,
	'cossic3.png' => 1,
);

# the following images: do not warn if they are not used

my %nowarnexistimage = (
	'musique.gif' => 1,
	'cossic3.png' => 1,
);

my $corpus_id = ''; # was desc004

my $detect_squares = 0;		  # whether we replace @a@a by aa or by a^2 etc.
my $division_mode = 'subtle'; # values: 'default', 'display', 'subtle'
my $longformula_limit = 1000;    # formulas with source length below this limit count as simple. If in TeX: no display.
my $dvipng_opts = ' -T tight -D 600 ';
my $dvisvg_opts = ' -e -n ';

my $rmessfmt = "R\t%-40s: %6d %s\n";
my $imessfmt = "I\t%-40s: %6d\n";
my $imessfmts = "I\t%-40s: %s\n";
my $imessfmtr = "I\t%-40s: %6s lines\n";
my $imessfmtx = "I\t%-40s\n";
my $emessfmt = "E\t%-40s: %6d\n";
my $emessfmtx = "E\t%-40s\n";

my %task = ();
my %todo = ();

my %meta = ();
my %image = ();
my %head = ();

my $picmerged;
my $picnotmerged;
my $metamerged;
my $metanotmerged;
my $prev_jid;
my $nhyph;
my $nformulas;
my $formulaid;
my %nmath = ();
my $nformitalic;
my $nformroman;

my %openerindex = ();
my %closerindex = ();
my %closerhint = ();
my %formulaindex = ();
my %formulasize = ();
my %formulawords = ();
my %greekindex = ();
my %greekmathused = ();
my %errors = ();

my $editiontext;

my %times = ();
my $timestamp;

sub greek {
	my $text = shift;
	my $newtext = '';
	my ($gch, $rest, $newrest, $lookupch, $transch);
	$rest = $text;
	while ($rest ne '') {
		$transch = undef;
		$lookupch = undef;
		for my $x (1) {
# line numbers
			($gch, $newrest) = $rest =~ m/^(\n[0-9]{6} )(.*)$/s;
			if (defined $gch) {$transch = $gch; next;}

# 0 instead of o
			($gch, $newrest) = $rest =~ m/^(4?0)(\z|(?:[0-9a-zA-Z].*))$/s;
			if (defined $gch) {$lookupch = $gch; next;}

# numbers indicating diacritics
			($gch, $newrest) = $rest =~ m/^([0-9]{1,2}[a-zA-Zéîòû])(.*)$/s;
			if (defined $gch) {$lookupch = $gch; next;}

# ending sigmas
			($gch, $newrest) = $rest =~ m/^(@|z)(\z|(?:[^a-zA-Z].*))$/s;
			if (defined $gch) {$lookupch = '@'; next;}

# normal greek letters plus some diacritics
			($gch, $newrest) = $rest =~ m/^([a-zA-Zéîòû])(.*)$/s;
			if (defined $gch) {$lookupch = $gch; next;}

# embedded non-greek
			($gch, $newrest) = $rest =~ m/^([0-9.,:;!?\s@=\$⌈⌉])(.*)$/s;
			if (defined $gch) {$transch = $gch; next;}

# everything that we did not think of will be fed to the translation table
			($gch, $newrest) = $rest =~ m/^(.)(.*)$/s;
			$lookupch = $gch;
		}
		$rest = $newrest;
		if (defined $transch) {
			$newtext .= $transch;
		}
		elsif (exists $greek{$lookupch}) {
			$newtext .= $greek{$lookupch};
		}
		else {
			push @{$errors{'GREEK'}}, sprintf("Greek [%s] not in Greek translation table.\n", $lookupch);
			$newtext .= $lookupch;
		}
	}
	$greekindex{$text} = $newtext;
	return $newtext;
}

sub do_trans {

# perform the character transformations

	my $n = 0;
	for my $ch (@trans) {
		my ($och, $rch) = @$ch;
		my $pat = quotemeta($och);
		$n += $editiontext =~ s/$och/$rch/sg;
	}
	printf STDERR $imessfmt, "Character replacements", $n;
}

sub do_hyphen9 {
	$nhyph = 0;
	my $n = 0;
	$n += $editiontext =~ s/(.)9(.)/hyphen($1,$2)/sge;
	$n += $editiontext =~ s/(.)9(.)/hyphen($1,$2)/sge;
	printf STDERR $imessfmt, "Hyphen-9 candidates", $n;
	printf STDERR $imessfmt, "Hyphen-9 replacements", $nhyph;
}

sub do_lines {
# textregels zijn regels die beginnen met een regelnummer van 6 cijfers, gevolgd door een spatie, en dan geen < teken
	my @lines = split "\n", $editiontext;
	my @newlines = ();
	my $nparas = 0;
	my $nletters = 0;
	my $inpara = 0;
	for my $line (@lines) {
		if ($line =~ m/\*{6}/) {
			next;
		}
		if ($line =~ m/<l /) {
			$nletters++;
		}
		if ($line !~ m/^[0-9]{6}\s/) {
			if ($inpara) {
				push @newlines, "</p>\n";
				$inpara = 0;
			}
			push @newlines, $line;
			next;
		}
		my ($volume) = $line =~ m/^([0-9])/;
		$line =~ s/^[0-9]{6} //;
		if ($line =~ m/^  /) {
			$nparas++;
			if (!$inpara) {
				$line =~ s/^  /<p>/;
				$inpara = 1;
			}
			else {
				$line =~ s/^  /<\/p>\n<p>/;
			}
		}
		$line =~ s/<m\s+([0-9]+)\s*>/<m $volume-$1>/sg;
		$line =~ s/<l\s+([0-9]+)\s*>/<l $volume-$1>/sg;
		push @newlines, $line;
	}
	if ($inpara) {
		push @newlines, "</p>\n";
	}
	$editiontext = join "\n", @newlines;
	$editiontext =~ s/((?:<m [0-9-]+>\s*?)+)\s*<\/p>/<\/p>\n$1/sg;
	$editiontext =~ s/\s+<\/p>/<\/p>/sg;

# concatenate lines in some cases:

# lines ending with hyphenated words
	my $nhyphen = $editiontext =~ s/-\n//sg;

# lines ending with @ followed by an alphabetic character at the start of the new line
	my $nsymbol = $editiontext =~ s/([@€&])\n(\p{Alpha})/$1$2/sg;
	printf STDERR $rmessfmt, "Replaced", $nhyphen, "end-of-line hyphens";
	printf STDERR $rmessfmt, "Connected", $nsymbol, "end-of-line \@s";
	printf STDERR $rmessfmt, "Did", $nletters, "letters";
	printf STDERR $rmessfmt, "Did", $nparas, "paragraphs";
}

#gre ... #end		greek

sub do_greek {
	my $n = $editiontext =~ s/#gre(.*?)#end/greek($1)/sge;
	printf STDERR $imessfmt, "Greek character fragments", $n;

	if (!open(GLO, ">:encoding(UTF-8)", $greekpath)) {
		printf STDERR $emessfmtx, "Can't write file [$greekpath]";
		return 0;
	}
	for my $t (sort lengthfirst keys %greekindex) {
		printf GLO "%s => %s\n", $t, $greekindex{$t};
	}
	close GLO;
}

sub do_escape {
	my $n;

# double @
	$n = $editiontext =~ s/\@\@/○○/sg;
	printf STDERR $imessfmt, "\@\@ escaped", $n;

# italics
	$n = $editiontext =~ s/=([^ ].*?)\$/⌈$1⌉/sg;
	printf STDERR $imessfmt, "Italics escaped", $n;

# roots
	$n = $editiontext =~ s/\\/□/sg;
	printf STDERR $imessfmt, "Backslashes escaped", $n;
}

sub do_formit {
	$nformitalic = 0;
	$nformroman = 0;
	my $n;

# make the symbols in italic contexts explicitly italic: replace @ by €
# also count how many & have been put in italic scope

	$n = $editiontext =~ s/(⌈[^⌉]*⌉)/formit($1)/sge;
	printf STDERR $imessfmt, "italic ranges", $n;
	printf STDERR $imessfmt, "& in italic => roman", $nformroman;
	printf STDERR $imessfmt, "@ in italic => italic", $nformitalic;

# now apply additional rules:

# single capitals are roman

	$n = $editiontext =~ s/(?<!\@)\@([A-Z])(?!\s*[@€&])/\&$1/sg;
	printf STDERR $imessfmt, "\@C => roman", $n;

# pairs of capital-noncapital: the capital is roman
	$n = $editiontext =~ s/(?<!\@)\@([A-Z])(\s*[@€&][a-z])(?!\s*[@€&])/\&$1$2/sg;
	printf STDERR $imessfmt, "\@C \@c => roman C c", $n;

# transform the unresolved @'s to & (roman)

	$n = $editiontext =~ s/(?<!\@)\@/\&/sg;
	printf STDERR $imessfmt, "@ (all else) => roman", $n;
}

sub formit {
	my ($text) = @_;
	$nformroman += $text =~ s/\&/\&/sg;
	$nformitalic += $text =~ s/(?<!\@)\@(\p{Alpha})/€$1/sg;
	return $text;
}

sub do_checkxml {

# make the individual letters into a unit XML document
	my $onexml = $editiontext;
	$onexml =~ s/###.*?\n//sg;
	$onexml = '<?xml version="1.0" encoding="utf-8"?>
<TEISET>
' . $onexml . '
</TEISET>
';

# write the XML to file

	if (!open(XLO, ">:encoding(UTF-8)", $convertxmlpath)) {
		printf STDERR $emessfmtx, "Can't write file [$convertxmlpath]";
		return 0;
	}
	print XLO $onexml;
	close XLO;

# check the file with xmllint for well-formedness

	my $lpath = $convertxmlpath;
	$lpath =~ s/ /\\ /g;

	my $cmd = "xmllint --noout $lpath 2>&1";
	if (!open(CMD, '-|', $cmd)) {
		push @{$errors{'XMLLINT-RUN'}}, sprintf("xmllint command could not be started [%s]\n", $cmd);
	}
	else {
		my @lines = <CMD>;
		my $ok = close CMD;
		if (!$ok or scalar(@lines)) {
			push @{$errors{'XMLLINT'}}, sprintf("xmllint returned errors[%s]\n", $convertxmlfile);
			for my $line (@lines) {
				$line =~ s/^.*?$convertxmlfile[:]/line /;
				push @{$errors{'XMLLINT'}}, $line;
			}
		}
		printf STDERR $imessfmt, "XML error lines", scalar(@lines);
	}
# check for the existence and uniqueness of id's

# 	existence
	my (@noid) = $onexml =~ m/<teiHeader>\s*<\/teiHeader>/sg;
	printf STDERR $imessfmt, "Missing identifiers", scalar(@noid);

# 	uniqueness
	my (@ids) = $onexml =~ m/<meta type=['"]id['"] value=['"]([^"']*)['"]\/>/sg;
	my %idindex = ();
	for my $id (@ids) {
		$idindex{$id}++;
	}
	my $nd = 0;
	for my $id (sort keys %idindex) {
		my $n = $idindex{$id};
		if ($n > 1) {
			$nd += $n;
			push @{$errors{'IDENTIFIERS'}}, sprintf("Multiple occurrences of identifier [%s] (%d x)\n", $id, $n);
		}
	}
	printf STDERR $imessfmt, "Multiple identifiers", $nd;

# check the image references

	my %existing = ();
	my %references = ();
	my %stats = ();

#	make a catalog of the existing image files

	my @imfiles = ();
	my $globpat;

	$globpat = $imagespath.'/*.*';
	$globpat =~ s/ /\\ /g;
	push @imfiles, glob($globpat);

	$globpat = $symbolspath.'/*.*';
	$globpat =~ s/ /\\ /g;
	push @imfiles, glob($globpat);

	$globpat = $formulaspath.'/*.*';
	$globpat =~ s/ /\\ /g;
	push @imfiles, glob($globpat);

	for my $im (@imfiles) {
		($im) = $im =~ m/([^\/]*)$/;
		if ($im !~ m/\.txt$/) {
			$existing{$im} = 1;
		}
	}

#	make a catalog of the document image references

	my (@graphics) = $onexml =~ m/(<graphic[^>]*?>)/sg;
	for my $ref (@graphics) {
		my ($url) = $ref =~ m/url="([^"]*)"/;
		if ($url =~ m/\//) {
			($url) = $url =~ m/([^\/]*)$/;
			push @{$errors{'IMAGES'}}, sprintf("Image reference with a path: [%s]. Using [%s]\n", $ref, $url);
			$stats{'path-in-url'}++;
		}
		$references{$url}++;
	}

# compare the catalogs

	for my $ref (sort keys %references) {
		my $n = $references{$ref};
		if ($n > 1) {
			if (!exists $nowarnmultimage{$ref}) {
				push @{$errors{'IMAGES'}}, sprintf("Warning: multiple references to the same image: [%s] (%d x)\n", $ref, $n);
				$stats{'multiple-refs'}++;
			}
		}
		if (!exists $existing{$ref}) {
			push @{$errors{'IMAGES'}}, sprintf("Reference to non-existing image: [%s])\n", $ref);
			$stats{'image-not-found'}++;
		}
	}

	for my $im (sort keys %existing) {
		if (!exists $references{$im}) {
			if (!exists $nowarnexistimage{$im}) {
				push @{$errors{'IMAGES'}}, sprintf("Warning: image not used: [%s])\n", $im);
				$stats{'image-not-used'}++;
			}
		}
	}

# check for remaining escape characters

	my @n;
	my $n;
# 	double @
	(@n) = $onexml =~ m/(○○)/sg;
	$n = scalar @n;
	if ($n) {
		push @{$errors{'ESCAPES'}}, sprintf("Remaining escape character: [%s] (%d x)\n", '○○', $n);
		$stats{'escape @@'}++;
	}

# 	italics and escapes
	(@n) = $onexml =~ m/([⌈⌉])/sg;
	$n = scalar @n;
	if ($n) {
		push @{$errors{'ESCAPES'}}, sprintf("Remaining escape character: [%s] (%d x)\n", '⌈ or ⌉', $n);
		$stats{'escape italic'}++;
	}
	(@n) = $onexml =~ m/(=[àáäâèéëêìíïîòóöôùúüûça-z0-9])/isg;
	$n = scalar @n;
	if ($n) {
		push @{$errors{'ITALICS'}}, sprintf("Remaining italic character: [%s] (%d x)\n", '=', $n);
		$stats{'escape italic'}++;
	}

# 	roots
	(@n) = $onexml =~ m/(□)/sg;
	$n = scalar @n;
	if ($n) {
		push @{$errors{'ESCAPES'}}, sprintf("Remaining escape character: [%s] (%d x)\n", '□', $n);
		$stats{'escape roots'}++;
	}

# statistics
	my $ims = scalar @imfiles;
	my $refs = scalar @graphics;
	my $uniqrefs = scalar keys %references;
	for my $stat (sort keys %stats) {
		printf STDERR $imessfmt, $stat, $stats{$stat};
	}
	printf STDERR $imessfmt, "images", $ims;
	printf STDERR $imessfmt, "referenced images", $uniqrefs;
	printf STDERR $imessfmt, "references", $refs;
}

sub do_tidyup {
	my (@letters) = $editiontext =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = '';
	my %stats = ();
	for my $letter (@letters) {
		my $n;

# xml comments
		$n = $letter =~ s/<!--.*?-->//sg;
		$stats{"XML comments removed"} += $n;

# xml characters
		$n = $letter =~ s/⊂/\&lt;/sg;
		$stats{"< => &lt;"} += $n;
		$n = $letter =~ s/⊃/\&gt;/sg;
		$stats{"> => &gt;"} += $n;

# unrecognized < > codes
		$n = $letter =~ s/<([gcd])>/\&lt;$1\&gt;/sg;
		$stats{"<g|c|d>"} += $n;
		$n = $letter =~ s/<(d end)>/\&lt;$1\&gt;/sg;
		$stats{"<d end>"} += $n;
		$n = $letter =~ s/<(nt[^>]*)>/\&lt;$1\&gt;/sg;
		$stats{"<nt(1) ...>"} += $n;

# initializers
		$n = $letter =~ s/^### \[([^\]]*)\]/### $1/sg;
		$stats{"### initializers tweaked"} += $n;

# finalizers
		$n = $letter =~ s/<\/TEI>\s*###[^\n]*\n?/<\/TEI>\n/sg;
		$stats{"### terminators removed"} += $n;

# spurious newlines
		$n = $letter =~ s/\n\n+/\n/sg;
		$n += $letter =~ s/^\n+//sg;
		$stats{"spurious newlines removed"} += $n;

# identifiers
		$n = $letter =~ s/<meta type="id" value="(AM([0-9])-([^-]*)-([^"]*))"\/>/<meta type="id" value="$corpus_id$2$4"\/>\n<meta type="alt_id" value="$1"\/>/sg;
		$stats{"identifiers AM => CKCC"} += $n;

		$editiontext .= $letter;
	}

# file terminator
	$editiontext .= "\n### EOF\n";

# statistics
	for my $stat (sort keys %stats) {
		printf STDERR $imessfmt, $stat, $stats{$stat};
	}
}

sub do_italic {

# we need to take care of paragraph transitions inside italic
	my $nx = $editiontext =~ s/⌈([^⌉]*)⌉/insertitalic($1)/sge;
	printf STDERR $imessfmt, "Italic scopes", $nx;
	my (@n) = $editiontext =~ m/([⌈⌉])/g;
	my $n = scalar(@n);
	if ($n) {
		push @{$errors{'ITALIC'}}, sprintf("Unbalanced italic scopes %d\n", $n);
	}
}

sub insertitalic {
	my $text = shift;
	$text =~ s/(<\/p>(?:\s|<pb[^\/>]*\/>)*<p>)/<\/hi>$1<hi rend="i">/sg;
	return '<hi rend="i">' . $text . '</hi>';
}

sub do_superscript {
	my $nb = $editiontext =~ s/≥/<hi rend="sup">/sg;
	my $ne = $editiontext =~ s/¥/<\/hi>/sg;
	printf STDERR $imessfmt, "Superscript open", $nb;
	printf STDERR $imessfmt, "Superscript close", $ne;
	if ($nb != $ne) {
		push @{$errors{'SUPERSCRIPT'}}, sprintf("Unbalanced superscript scopes; open: %d; close %d\n", $nb, $ne);
	}
}

sub do_atat {
	my $n = $editiontext =~ s/○○//sg;
	printf STDERR $imessfmt, "\@\@ removed", $n;
}

sub do_ququ {
	my $n = $editiontext =~ s/\?\?//sg;
	printf STDERR $imessfmt, "\?\? removed", $n;
}

sub do_brackets {
	my $n = $editiontext =~ s/#\((.*?)\)#/\($1\)/sg;
	printf STDERR $imessfmt, "#(...)# replaced by (...)", $n;
}

sub do_abbrev {
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	my %stats = ();
	for my $letter (@letters) {
		my $n;
		$n = $letter =~ s/##(\p{Alnum}+)\./$1./sg;
		$stats{"##x. replaced by x."} += $n;

		$n = $letter =~ s/##(\p{Alnum}+)</$1</sg;
		$stats{"##x< replaced by x<"} += $n;

		$n = $letter =~ s/##(\p{Alnum}+)/$1./sg;
		$stats{"##x replaced by x."} += $n;

		$editiontext .= $letter;
	}
	my @remaining;
	my $n = 0;
	(@remaining) = $editiontext =~ m/^##$/sg;
	$n += scalar(@remaining);

	(@remaining) = $editiontext =~ m/^##[^#]/sg;
	$n += scalar(@remaining);

	(@remaining) = $editiontext =~ m/[^#]##$/sg;
	$n += scalar(@remaining);

	(@remaining) = $editiontext =~ m/[^#]##[^#]/sg;
	$n += scalar(@remaining);

	for my $stat (sort keys %stats) {
		printf STDERR $imessfmt, $stat, $stats{$stat};
	}
	if ($n) {
		printf STDERR $emessfmt, "## remaining", $n;
	}
}

sub do_headings {
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	my %stats = ();
	my $n = 0;
	my $d = 0;
	for my $letter (@letters) {
		my (@headings) = $letter =~ m/§([^§]*)§/sg;
		for my $h (@headings) {
			$stats{"\t[$h]"}++;
		}

		$n += $letter =~ s/<p>§([^§]*)§\s*(.*?)<\/p>/<p><hi rend="$1">$2<\/hi><\/p>/sg;

		my (@divs) = $letter =~ m/±/sg;
		$stats{"\t<div-para>"} += scalar @divs;

		$d += $letter =~ s/<p>±(.*?)<\/p>/<div type="para"><p>$1<\/p><\/div>/sg;

		$editiontext .= $letter;
	}

	my $m = 0;
	my $hstr = '';
	printf STDERR $rmessfmt, "Applied", $n + $d, "headings and divs";
	for my $h (sort keys %stats) {
		my $hm = $stats{$h};
		$m += $hm;
		$hstr .= sprintf "%s: %d; ", $h, $hm;
	}
	printf STDERR $imessfmtx, "\t$hstr";
	if ($m < $n + $d) {
		printf STDERR $emessfmt, "Missing headings and divs", $n + $d - $m;
	}
	elsif ($m > $n + $d) {
		printf STDERR $emessfmt, "Did too many headings and divs", $m - $n - $d;
	}
	printf STDERR $rmessfmt, "Did", scalar(@letters), "letters";
}

sub do_marginals {
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	my $n = 0;
	for my $letter (@letters) {
		$n += $letter =~ s/<mt ([^>]*)>/<add place="margin">$1<\/add>/sg;
		$editiontext .= $letter;
	}

	printf STDERR $rmessfmt, "Applied", $n, "marginals";
	printf STDERR $rmessfmt, "Did", scalar(@letters), "letters";
}

sub do_pagenumbers {
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	my $n = 0;
	my $m = 0;
	my $ngood = 0;
	my $nfout = 0;
# the prelim should go inside the body of the first letter
	$editiontext = "";
	my $first = 1;
	for my $letter (@letters) {
		my ($pre, $amid, $body, $post) = $letter =~ m/^(### \[(.*?)\.xml\].*?<\/teiHeader>\n<text>\n*)(.*?)(<\/text>\n<\/TEI>.*)$/s;
		if (!defined $amid) {
			$nfout++;
			print STDERR "$letter\n";
			next;
		}
		if ($first) {
			$body = $prelim . $body;
			$first = 0;
		}
		$ngood++;
		$m += $body =~ s/([^\n])<m ([^>]*)>\s*/$1<pb ed="AM" n="$2" type="in-word"\/>/sg;
		$n += $body =~ s/<m ([^>]*)>/<pb ed="AM" n="$1"\/>/sg;
		$body =~ s/<p>(<pb[^>]*>)<\/p>/$1/sg;
		$editiontext .= $pre . $body . $post;
	}
	if ($nfout) {
		printf STDERR $emessfmt, "wrong letters", $nfout;
	}
	printf STDERR $rmessfmt, "inserted", $n, "pagebreaks";
	printf STDERR $rmessfmt, "of which", $m, "in-word";
	printf STDERR $rmessfmt, "Did", $ngood, "letters";
}

sub do_enmarge {
	my $nendone = 0;
	my (@nenfound) = $editiontext =~ m/(.EN MARGE.)/sg;
	my $nenfound = scalar @nenfound;
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	for my $letter (@letters) {
		my ($pre, $bpara, $enmarge, $epara, $rest) = $letter =~ m/^(.*?)((?:<p>)?)(\(\/EN MARGE:\/.*?\))((?:<\/p>)?)(.*)$/s;
		if (defined $pre) {
			$nendone++;
			$editiontext .= $pre;
			$editiontext .= sprintf
'<div type="para">
<p>%s</p>
</div>', $enmarge;
			$editiontext .= $rest;
		}
		else {
			$editiontext .= $letter;
		}
	}
	printf STDERR $rmessfmt, "Found", $nenfound, "en-marges";
	printf STDERR $rmessfmt, "Treated", $nendone, "en-marges";
	printf STDERR $rmessfmt, "Did", scalar(@letters), "letters";
}

sub do_openers {
	my %altopeners = (
		'AM2-329-164' => 1,
		'AM3-275-218' => 1,
#		'AM4-332-295' => 1,
		'AM4-361-303' => 1,
		'AM7-146-547' => 1,
		'AM7-388-298---2' => 1,
		'AM8-295-693' => 1,
	);
	my $nopen = 0;
	my $nalt = 0;
	my $ntotal = 0;
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	for my $letter (@letters) {
		my ($amid) = $letter =~ m/### \[(AM.*?)\.xml\]/;
		$ntotal++;

		my $isaltopener = $altopeners{$amid};

		my ($pre, $opener, $post) = $letter =~ m/^(.*?<body>\n)(.*?)(<.*)$/s;
		if (defined $pre and $opener !~ m/^\s*$/s) {
			if ($isaltopener) {
				$nalt++;
			}
			else {
				$nopen++;
			}
			$editiontext .= $pre;
			my @lines = split /\n/, $opener;
			if ($lines[0] =~ m/^\s*$/) {
				shift @lines;
			}
			my $openerrep = join " | ", @lines;
			$openerindex{($isaltopener?"alt":"yes")}->{$openerrep}->{$amid}++;
			my $openertext = '<p>'.join("</p>\n<p>", @lines).'</p>';
			$openertext =~ s/^<p><p>/<p>/s;
			$openertext =~ s/<\/p><\/p>$/<\/p>/s;
			$editiontext .= sprintf
'
<div type="%s">
%s
</div>', ($isaltopener?"para":"opener"), $openertext;
			$editiontext .= $post;
		}
		else {
			my ($noopener) = $letter =~ m/^.*?<\/head>(.*?<\/[^>]*>)/s;
			$noopener =~ s/\n/ | /sg;
			$openerindex{no}->{substr($noopener, 0, 80)}->{$amid}++;
			$editiontext .= $letter;
		}
	}
	printf STDERR $rmessfmt, "Detected", $nopen, "openers (real)";
	printf STDERR $rmessfmt, "and", $nalt, "openers (pseudo)";
	printf STDERR $rmessfmt, "Did", $ntotal, "letters";

	if (!open(OLO, ">:encoding(UTF-8)", $openeroutpath)) {
		printf STDERR $emessfmtx, "Can't write file [$openeroutpath]";
		return 0;
	}

	printf OLO "\n%s\n%s\n%s\n\n", ("+" x 80), "Special Initial Paragraphs => <div type=\"para\"> ...<p> ... </p> ... </div>\n", ("+" x 80);
	for my $f (sort lengthfirst keys %{$openerindex{alt}}) {
		my $amids = $openerindex{alt}->{$f};
		my $occurrences = "";
		for my $amid (sort keys %$amids) {
			$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
		}
		printf OLO "%s\n%s\n%s\n", $occurrences, $f, ('=' x 80);
	}
	printf OLO "\n%s\n%s\n%s\n\n", ("+" x 80), "Real Opener Paragraphs => <div type=\"opener\"> ...<p> ... </p> ... </div>\n", ("+" x 80);
	for my $f (sort lengthfirst keys %{$openerindex{yes}}) {
		my $amids = $openerindex{yes}->{$f};
		my $occurrences = "";
		for my $amid (sort keys %$amids) {
			$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
		}
		printf OLO "%s\n%s\n%s\n", $occurrences, $f, ('=' x 80);
	}
	printf OLO "\n%s\n%s\n%s\n\n", ("+" x 80), "Straight Into The Body => <p> ...\n", ("+" x 80);
	for my $f (sort lengthfirst keys %{$openerindex{no}}) {
		my $amids = $openerindex{no}->{$f};
		my $occurrences = "";
		for my $amid (sort keys %$amids) {
			$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
		}
		printf OLO "%s\n%s\n%s\n", $occurrences, $f, ('=' x 80);
	}

	close OLO;
}

sub do_closers {

# read the file with long closers

	my $closerxsrc = readfile($closerxinpath);
	my $closerxtext = join "", @$closerxsrc;

# split into the individual closerspecs

	my @closersxgiven = split /====[^\n]*\n/, $closerxtext;
	if ($closersxgiven[0] =~ m/^\s*$/) {
		shift @closersxgiven;
	}

# split a closer into the list of AMids and the body

	my %closerx = ();
	my $nlonggiven = 0;
	for my $closer (@closersxgiven) {
		my ($amidstxt, $body) = $closer =~ m/^([^\n]*)\n(.*)$/s;
		my (@amids) = $amidstxt =~ m/(AM[^ ]+)/g;
		for my $amid (@amids) {
			$closerx{$amid} = $body;
			$nlonggiven++;
		}
	}
	printf STDERR $imessfmt, "long closers", $nlonggiven;

# read the file with hints for closers and filter out the comment lines

	my $closersrc = readfile($closerinpath);
	my @newclosersgiven = ();
	for my $line (@$closersrc) {
		if ($line =~ m/^\+{3}/) {
			next;
		}
		push @newclosersgiven, $line;
	}
	my $closertext = join "", @newclosersgiven;

# split into the individual closerspecs

	my @closersgiven = split /====[^\n]*\n/, $closertext;
	if ($closersgiven[0] =~ m/^\s*$/) {
		shift @closersgiven;
	}
	my ($nohints, $hints, $nwrong) = (0, 0, 0);

# split a closer into the list of AMids and the body, and detect the | symbol
# and count the length of the string after | and store this for each AMid
# this number is the hint.

	for my $closer (@closersgiven) {
		my ($amidstxt, $body) = $closer =~ m/^([^\n]*)\n(.*)$/s;
		my (@amids) = $amidstxt =~ m/(AM[^ ]+)/g;
# check for wrong hints, i.e. multiple | symbols
		my $npipe = $closer =~ s/\|/|/sg;
		if ($npipe > 1) {
			push @{$errors{CLOSERHINTS}}, sprintf("Multiple | symbols in closer hint for %s\n", join(", ", @amids));
			$nwrong += scalar(@amids);
		}
		my ($hintcloser) = $closer =~ m/\|\s*(.*)$/s;
		if (defined $hintcloser) {
			chomp $hintcloser;
			$hints++;
			for my $amid (@amids) {
				$closerhint{$amid} = length $hintcloser;
			}
		}
		else {
			$nohints++;
			push @{$errors{CLOSERHINTS}}, sprintf("No | symbols in closer hint for %s\n", join(", ", @amids));
		}
	}
	printf STDERR $imessfmt, "closers: hints", $hints;
	printf STDERR $imessfmt, "closers: no-hints", $nohints;
	printf STDERR $imessfmt, "closers: wrong", $nwrong;

# Detect closers according to heuristics, unless there are hints. Follow the hints.

	my %stats = ();
	my $ntotal = 0;

# Dissect the edition into letters (and the piece before all letters)

	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;

# Compose a new edition based on the changed letters
	$editiontext = $prelim;

# Inspect the last so many characters of each letter

	my $tailsize = 1000;
	for my $letter (@letters) {
		my ($amid) = $letter =~ m/### \[(AM.*?)\.xml\]/;
		$ntotal++;

# We will need the opener for our heuristics

		my ($opener) = $letter =~ m/div type="opener">\n<p>(.*?)<\/p>/s;
		$opener =~ s/,.*$//s;
		if (defined $opener) {
			$opener =~ s/s$//;
			$opener = quotemeta($opener);
		}

# Get to the paragraph text of the letter, and take the tail of so many characters from the paragraph text

		my ($pre, $paras, $post) = $letter =~ m/^(.*?)(<p>.*<\/p>)(.*?<\/TEI>.*)$/s;
		if (defined $pre) {
			$editiontext .= $pre;
			my ($head, $tail);
			if (length($paras) < $tailsize) {
				$head = '';
				$tail = $paras;
			}
			else {
				$head = substr $paras, 0, length($paras) - $tailsize;
				$tail = substr $paras, -$tailsize;
			}
			$editiontext .= $head;

# start detetecting the closer
# we use trigger texts that indicate the presence of a closer
# sometimes the trigger belongs to the closer, sometimes not

			my ($front, $trigger, $closer, $kind, $includetrigger);
			for my $x (1) {

# if there is a hint, we follow it and are done

				if (exists $closerhint{$amid}) {
					my $breakpos = $closerhint{$amid};
					$front = substr $tail, 0, length($tail) - $breakpos;
					$trigger = '';
					if ($breakpos == 0) {
						$closer = '';
					}
					else {
						$closer = substr $tail, - $breakpos;
					}
					if ($closer =~ m/^\s*(?:<\/p>)?\s*$/s) {
						$kind = 'H-1: HINT NO CLOSER';
					}
					else {
						$kind = 'H-0: HINT';
					}
					$includetrigger = 0;
					next;
				}

# opener text as trigger
				if (defined $opener) {
					($front, $trigger, $closer) = $tail =~ m/^(.*?\n)($opener[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
					if (defined $front) {$kind = 'YES: OPENER'; $includetrigger = 1; next}
					($front, $trigger, $closer) = $tail =~ m/^(.*?\n)($opener[^\n]*[^.!?])((?:\n.*)?<\/p>.*)$/s;
					if (defined $front) {$kind = 'YES: OPENER'; $includetrigger = 1; next}
					($front, $trigger, $closer) = $tail =~ m/^(.*?\n)($opener[.,]*)((?:\n.*)?<\/p>.*)$/s;
					if (defined $front) {$kind = 'YES: OPENER'; $includetrigger = 1; next}
				}

# greetings as trigger
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Vale(?:te)?[.,]+[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: VALE'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Vale(?:te)?[.,]+[^\n]*)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: VALE'; $includetrigger = 1; next}

# name parts as trigger
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(renat[uv][ms][^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/si;
				if (defined $front) {$kind = 'YES: RENAT'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(renat[uv][ms][^\n]*)((?:\n.*)?<\/p>.*)$/si;
				if (defined $front) {$kind = 'YES: RENAT'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(renat[uv][ms][^\n]*)(<\/p>.*)$/si;
				if (defined $front) {$kind = 'YES: RENAT'; $includetrigger = 1; next}

# "I am" triggers
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Jj]e\s+suis[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Je suis'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Jj]e\s+suis[^\n]*\.\.\..?)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Je suis'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Jj]e\s+suis[^\n]*[^.!?])(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Je suis'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Jj]e\s+suis[.,]*)(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Je suis'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Jj]e\s+suis[.,\s]*)(<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Je suis'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Ii]ck\s+ben[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Ick ben'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Ii]ck\s+ben[^\n]*[^.!?])(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Ick ben'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Ii]ck\s+ben[.,]*)(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Ick ben'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)([Ii]ck\s+ben[.,\s]*)(<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Ick ben'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Sum[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Sum'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Sum[^\n]*[^.!?])(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Sum'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Sum[.,]*)(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Sum'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Sum[.,\s]*)(<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Sum'; $includetrigger = 1; next}

# "Yours" triggers
				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(V.tre[^\n]*##etc\.)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Votre'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(V.tre[^\n]*[^.!?])(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Votre'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(V.tre[^\n]*[^.!?])(\néLISABETH.*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Votre'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(V.tre[.,]*)(\n[#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: Votre'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?)(Tu[iî] [^\n]*)(\n#A-Z].*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: TUI'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(Tibi [^\n]*)(.*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: TIBI'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?\n)(Tuus [^\n]*)(.*<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: TUUS'; $includetrigger = 1; next}

				($front, $trigger, $closer) = $tail =~ m/^(.*?)((?:Mon|##M) (?:##R\S*|R.v\S*) (?:P.re|##P).[^\n]*)((?:\n.*)?<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: ##M##R##P'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)((?:Mon|##M) (?:##R|R.v\S*) (?:P.re|##P).[^\n]*)(<\/p>.*)$/s;
				if (defined $front) {$kind = 'YES: ##M##R##P'; $includetrigger = 1; next}

# "etcetera" triggers
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(##etc[.,]+)((?:\n.*)?<\/p>)$/s;
				if (defined $front) {$kind = 'YES: ETC'; $includetrigger = 1; next}
				($front, $trigger, $closer) = $tail =~ m/^(.*?)(##etc[.,\s]+)(<\/p>)$/s;
				if (defined $front) {$kind = 'YES: ETC'; $includetrigger = 1; next}
			}

# now compose the closer on the basis of the split found by the heuristics above
# also store the closer in an index and store long closers separately

			my $minlines = 5;

			if (defined $front) {
				if ($includetrigger) {
					$closer = $trigger . $closer;
					$trigger = '';
				}
				if ($closer !~ m/^\s*(?:<\/p>)?\s*$/s) {
					$stats{closers}++;
					my $test = "$front$trigger" =~ m/<\/p>\s*$/s;
					my $extrap = $test?'':"<\/p>\n";
					$editiontext .= $front.$trigger.$extrap;
					my @lines = split /\n/, $closer;
					if ($lines[0] =~ m/^\s*$/) {
						shift @lines;
					}
					for my $line (@lines) {
						$line =~ s/^\s*<p>//s;
						$line =~ s/<\/p>\s*$//s;
					}

# compose the new closer
# if it has been given in the long closers input file, use that instead
# otherwise the newcloser is formed on the basis of the process above (hints, triggers, etc)

					my $newcloser;
					if (exists $closerx{$amid}) {
						$newcloser = $closerx{$amid};
						$newcloser = processlongcloser($newcloser, \%stats);
						$stats{longused}++;
					}
					else {
						$newcloser = sprintf
'<div type="closer">
<p>%s</p>
</div>', join("</p>\n<p>", @lines);
						my $n = $newcloser =~ s/(<p>\W*Adresse:.*?<\/p>\n)/<\/div>\n<div type="para">\n$1<\/div>\n<div type="address">\n/sg;
						$stats{addresses} += $n;
					}
					$editiontext .= $newcloser;
					if (scalar(@lines) >= $minlines) {
						$closerindex{NEW}->{$newcloser}->{$amid}++;
					}
				}
				else {
					$editiontext .= $tail;
					$stats{noclosers}++;
				}
				$closerindex{$kind}->{$front.$trigger.'|'.$closer}->{$amid}++;
			}
			else {
				$editiontext .= $tail;
				$kind = undef;
				for my $x (1) {
					if ($tail =~ m/[.]{2,}<\/p>$/i) {$kind = 'NO: COMMA'; next}
				}
				if (defined $kind) {
					$stats{noclosers}++;
				}
				else {
					$kind = '000: NO CLOSER??';
				}
				$closerindex{$kind}->{$tail}->{$amid}++;
			}
			$editiontext .= $post;
		}
		else {
			$editiontext .= $letter;
		}
	}

# write info about closers to file an overview of all closers
# an extract of closers with a certain minimum number of lines

	my $minlines = 5;

	if (!open(PLO, ">:encoding(UTF-8)", $closeroutpath)) {
		printf STDERR $emessfmtx, "Can't write file [$closeroutpath]";
		return 0;
	}
	for my $kind (sort keys %closerindex) {
		if ($kind eq 'NEW') {
			next;
		}
		my $n = 0;
		for my $f (sort lengthfirst keys %{$closerindex{$kind}}) {
			my $amids = $closerindex{$kind}->{$f};
			for my $amid (sort keys %$amids) {
				$n += $amids->{$amid};
			}
		}
		printf STDERR $imessfmt, $kind, $n;  
		printf PLO "%s\n+++%s (%d X)\n%s\n", ("+" x 80), $kind, $n, ("+" x 80);
		for my $f (sort keys %{$closerindex{$kind}}) {
			my $amids = $closerindex{$kind}->{$f};
			my $occurrences = "";
			for my $amid (sort keys %$amids) {
				$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
			}
			printf PLO "%s%s%s\n%s\n%s\n", ('=' x 10), $kind, ('=' x 60), $occurrences, $f;
		}
	}
	close PLO;

	if (!open(PXLO, ">:encoding(UTF-8)", $closerxoutpath)) {
		printf STDERR $emessfmtx, "Can't write file [$closerxoutpath]";
		return 0;
	}
	my $nlong = 0;
	my $kind = 'NEW';
	for my $f (sort keys %{$closerindex{$kind}}) {
		my $amids = $closerindex{$kind}->{$f};
		my $occurrences = "";
		for my $amid (sort keys %$amids) {
			$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
			$nlong += $amids->{$amid};
		}
		printf PXLO "%s\n%s\n%s\n", ('=' x 80), $occurrences, $f;
	}
	close PXLO;

	for my $key (sort keys %stats) {
		printf STDERR $rmessfmt, $key, $stats{$key}, "";
	}
	printf STDERR $rmessfmt, "Did", $ntotal, "letters";
}

sub processlongcloser {
	my $text = shift;
	my $stats = shift;

	my @parts = split /\n=+/, $text;
	if (scalar(@parts) == 1) {
		$stats->{noextraparts}++;
		return $text;
	}
	$stats->{extraparts}++;
	my $newtext = '';
	my $prevkind;
	for my $part (@parts) {
		my ($kind, $body) = $part =~ m/^([acpv])\n(.*)$/s;
		if (!defined $kind) {
# this is the first part, starting with a <div ...
			$body = $part;
		}
		else {
			if ($kind ne 'v') {
				$body =~ s/\n?<\/div>\s*$//s;
			}
			if ($kind eq 'a') {
				$kind = 'address';
				$stats->{newaddresses}++;
			}
			elsif ($kind eq 'c') {
				$kind = 'closer';
				$stats->{extraclosers}++;
			}
			elsif ($kind eq 'v') {
				$kind = 'verbatim';
				$stats->{verbatim}++;
			}
			elsif ($kind eq 'p') {
				$kind = 'postscriptum';
				$stats->{postscripta}++;
				$body =~ s/<p>//g;
				$body =~ s/<\/p>//g;
				$body =~ s/\n  /<\/p>\n<p>/sg;
				$body = '<p>' . $body . '</p>';
				$body =~ s/\n(<\/p>)/$1/sg;
			}
			my $closeprevious;
			if ($prevkind eq 'verbatim') {
				$closeprevious = "\n";
			}
			else {
				$closeprevious = "\n<\/div>\n";
			}
			if ($kind ne 'verbatim') {
				$body = "<div type=\"$kind\">\n" . $body;
			}
			$body = $closeprevious . $body;
			$prevkind = $kind;
		}
		$newtext .= $body;
	}
	if ($prevkind ne 'verbatim') {
		$newtext =~ s/\s*<\/div>\s*$//s;
		$newtext .= "\n</div>";
	}
	return "\n<!--start tweaked closer-->\n" . $newtext . "\n<!--end tweaked closer-->\n";
}

sub do_meta {
	my $metasrc = readfile($metapath);


# remove the origvals

	for my $line (@$metasrc) {
		$line =~ s/ origvalue="[^"]*"//;
	}

# adjust the date format (and check them)

	my $metaline = 0;
	for my $line (@$metasrc) {
		$metaline++;
		if ($line =~ m/type="date"/) {
			my ($value) = $line =~ m/value="([^"]*)"/;
			my $changed = $value =~ s/\s*\.\.\.\s*/\//;
			if ($changed) {
				my $valuerep = $value;
				#$value =~ s/\//\\\//g;
				$line =~ s/value="[^"]*"/value="$value"/;
			}
			my ($part1, $part2, $year1, $month1, $day1, $year2, $month2, $day2);
			if ($value eq '') {
				next;
			}
			if ($value =~ m/\//) {
				($part1, $part2) = $value =~ m/^([^\/]*)\/(.*)$/s;
			}
			else {
				$part1 = $value;
			}
			my @checkeddates = ();
			for my $part ($part1, $part2) {
				if (!defined $part) {
					next;
				}
				my @comps = split /-/, $part;
				if ($#comps > 2) {
					push @{$errors{'DATES'}}, sprintf("Too many date components: %s at line %s\n", "[$part] in [$value]", $metaline);
					push @checkeddates, undef;
				}
				elsif ($comps[0] !~ m/^1[56][0-9]{2}$/) {
					push @{$errors{'DATES'}}, sprintf("Wrong year: %s at line %s\n", "[$part] in [$value]", $metaline);
					push @checkeddates, undef;
				}
				elsif ($#comps > 1 and (($comps[1] !~ m/^[01][0-9]$/) or $comps[1] > 12)) {
					push @{$errors{'DATES'}}, sprintf("Wrong month: %s at line %s\n", "[$part] in [$value]", $metaline);
					push @checkeddates, undef;
				}
				elsif ($#comps > 2 and (($comps[2] !~ m/^[0-3][0-9]$/) or $comps[1] > 31)) {
					push @{$errors{'DATES'}}, sprintf("Wrong day: %s at line %s\n", "[$part] in [$value]", $metaline);
					push @checkeddates, undef;
				}
				else {
					push @checkeddates, \@comps;
				}
			}
			if (defined $part2) {
				if (defined $checkeddates[0] and defined $checkeddates[1]) {
					if ($#{$checkeddates[0]} != $#{$checkeddates[1]}) {
						push @{$errors{'DATES'}}, sprintf("Unequal precision in range: %s at line %s\n", "[$part1] and [$part2]", $metaline);
					}
				}
			}
		}
	}

# store the metadata

	my $metatext = join '', @$metasrc;
	%meta = $metatext =~ m/([^\n]+)\n(.*?)===\n/sg;

# merge the metadata into the result

	$metamerged = 0;
	$metanotmerged = 0;
	$prev_jid = undef;

	my ($prelim, $letters) = $editiontext =~ m/^(.*?)([0-9]{6} <l .*)/s;
	my (@letters) = $letters =~ m/([0-9]{6} <l .*?(?=\z|(?:[0-9]{6} <l )))/sg;
	$editiontext = $prelim;
	for my $letter (@letters) {
		$letter =~ s/^([0-9]{6}) <l ([^> ]+)>[ \t]*\n/linkmeta($1,$2)/me;
		$editiontext .= $letter;
	}
	$editiontext .= "\n</text>\n</TEI>\n### [AM$prev_jid.xml]\n";
	printf STDERR $rmessfmt, "Added", $metamerged, "metaheaders";
	printf STDERR $rmessfmt, "Missed", $metanotmerged, "metaheaders";
	printf STDERR $rmessfmt, "Together", $metamerged + $metanotmerged, "metaheaders";
	printf STDERR $rmessfmt, "Did", scalar(@letters), "letters";
}

sub do_images {
	my $imagesrc = readfile($imagepath);
	chomp @$imagesrc;

# store the image data

	for my $line (@$imagesrc) {
		my ($amid, $pic, $inline) = split /\t/, $line;
		if (!defined $amid) {
			next;
		}
		$image{$amid} = [$pic, $inline];
	}

# we may suppose that there is at most 1 <fig> on a line
	$picmerged = 0;
	$picnotmerged = 0;

	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	my $ngood = 0;
	my $nfout = 0;
	$editiontext = $prelim;
	for my $letter (@letters) {
		my ($pre, $amid, $body, $post) = $letter =~ m/^(### \[(.*?)\.xml\].*?<\/teiHeader>\n<text>\n*)(.*?)(<\/text>\n<\/TEI>.*)$/s;
		if (!defined $amid) {
			$nfout++;
			print STDERR "$letter\n";
			next;
		}
		$ngood++;
		$body =~ s/^([0-9]{6}) (.*?)<fig>/linkimages($1,$2)/gme;
		$editiontext .= $pre . $body . $post;
	}
	if ($nfout) {
		printf STDERR $emessfmt, "wrong letters", $nfout;
	}

	printf STDERR $rmessfmt, "Added", $picmerged, "graphic references";
	printf STDERR $rmessfmt, "Missed", $picnotmerged, "graphic references";
	printf STDERR $rmessfmt, "Together", $picmerged + $picnotmerged, "graphic references";
	printf STDERR $rmessfmt, "Did", $ngood, "letters";
}

sub do_heads {
	my $headsrc = readfile($headpath);
	shift @$headsrc;
	chomp @$headsrc;

# store the head data

	my $nlines = 0;
	my $ndbl = 0;
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
		if (exists $head{$amnum}) {
			$ndbl++;
			push @{$errors{'HEADS'}}, sprintf("Multiple AM number: %s at line %s\n", $amnum, $nlines);
		}
		else {
			$head{$amnum} = [$amnumrep, $atnum, $senderlocdate, $amidstr, $atidstr, $sendrec];
		}
	}
	printf STDERR $imessfmt, "headings (good)", $nlines - $ndbl;
	printf STDERR $imessfmt, "multiples", $ndbl;
	printf STDERR $imessfmt, "total", $nlines;

	if (!open(HLO, ">:encoding(UTF-8)", $headoutpath)) {
		printf STDERR $emessfmtx, "Can't write file [$headoutpath]";
		return 0;
	}

	my $nok = 0;
	my $nmin = 0;
	my $nnoat = 0;

	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	my $ngood = 0;
	my $nfout = 0;
	$editiontext = $prelim;
	for my $letter (@letters) {
		my ($pre, $amid, $body, $post) = $letter =~ m/^(### \[(.*?)\.xml\].*?<\/teiHeader>\n<text>\n*)(.*?)(<\/text>\n<\/TEI>.*)$/s;
		if (!defined $amid) {
			$nfout++;
			print STDERR "$letter\n";
			next;
		}
		$ngood++;
		my $headtext = '';
#	$head{$amnum} = [$amnumrep, $atnum, $senderlocdate, $amidstr, $atidstr, $sendrec];
		my $headinfo;
		my ($amnum) = $amid =~ m/^[^-]+-[^-]+-([^.]+)/;
		if (defined $amnum) {
			$amnum =~ s/^([^0-9]*)0+(.*)$/$1$2/;
			$headinfo = $head{$amnum};
		}
		if (!defined $headinfo) {
			$nmin++;
			$headtext = "<!-- NO HEAD INFO -->\n";
			push @{$errors{'NO HEAD INFO'}}, sprintf("AM num %s (from <%s>):  no info in %s\n", $amnum, $amid, $headfile);
		}
		else {
			$nok++;
			my ($amnumrep, $atnum, $senderlocdate, $amidstr, $atidstr, $sendrec) = @$headinfo;
			my ($loc, $date) = $senderlocdate =~ m/^([^,]*),\s*(.*)$/;
			if (!defined $loc) {
				$loc = '';
				$date = $senderlocdate;
			}
			$date =~ s/(\s*\/?\s*)([0-9]{1,2})\s*[\/]\s*([0-9]{4})/frenchmonth($amidstr,$1,$2,$3)/ge;
			$date =~ s/\s+/ /g;

			$amidstr =~ s/,(?!\s)/, /g;
			
			my ($atat, $atr);
			my @atids = split /\s*;\s*/, $atidstr;
			if (scalar(@atids) > 2) {
				push @{$errors{'HEAD AT/R: TOO MUCH'}}, sprintf("Head of letter %s: more than 2 fields AT(R) info in [%s]\n", $amid, $atidstr);
			}
			for my $atd (@atids) {
				if ($atd =~ m/R/) {
					$atd =~ s/R\.?\s*,?\s*//g;
					$atr = $atd;
				}
				else {
					$atd =~ s/A\s*\.?\s*T\.?,?\s*//g;
					$atat = $atd;
				}
			}
			my $atrep = '';
			if (defined $atr) {
				$atrep .= "R, $atr; ";
			}
			if (defined $atat) {
				$atrep .= "AT $atat";
			}
			if (!defined $atat) {
				#push @{$errors{'HEAD AT/R: TOO LITTLE'}}, sprintf("Head of letter %s: no AT info in [%s]\n", $amid, $atidstr);
				$nnoat++;
			}
			$atrep =~ s/,(?!\s)/, /g;

			my $locrep;
			if ($loc eq '' or $date eq '') {
				$locrep = $loc;
			}
			else {
				$locrep = $loc . ', ';
			}
			$headtext = sprintf '
<head rend="h3">
%s<lb/>
%s<lb/>
%s%s<lb/>
(%s; %s)<lb/>
</head>
', $amnumrep, $sendrec, $locrep, $date, $amidstr, $atrep;
			printf HLO "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $amid, $amnumrep, $sendrec, $loc, $date, $amidstr, $atrep;
		}
		$editiontext .= $pre . $headtext . "<body>\n" . $body . "\n</body>\n" . $post;
	}
	if ($nfout) {
		printf STDERR $emessfmt, "wrong letters", $nfout;
	}

	printf STDERR $rmessfmt, "Found", $nok, "headers";
	printf STDERR $rmessfmt, "Missed", $nmin, "headers";
	printf STDERR $rmessfmt, "Together", $nok + $nmin, "headers";
	printf STDERR $rmessfmt, "Without AT info", $nnoat, "headers";
	printf STDERR $rmessfmt, "Did", $ngood, "letters";
	close HLO;
}

sub do_formulas {
	my ($prelim, $letters) = $editiontext =~ m/^(.*?)(###.*)/s;
	my (@letters) = $letters =~ m/(### \[AM.*?<\/TEI>\n### \[AM[^\]]*\]\n*)/sg;
	$editiontext = $prelim;
	my %formulasrem = ();
	$nformulas = 0;

	my $n = 0;
	my $ngood = 0;
	my $nfout = 0;
	for my $letter (@letters) {
		my ($pre, $amid, $body, $post) = $letter =~ m/^(### \[(.*?)\.xml\].*?<\/teiHeader>\n<text>\n*)(.*?)(<\/text>\n<\/TEI>.*)$/s;
		if (!defined $amid) {
			$nfout++;
			print STDERR "$letter\n";
			next;
		}
		$formulaid = 0;
		$ngood++;

# detect formula candidates

		$n += $body =~ s/
		(
			(?:\A | [.,:;!?<>⊂⊃'\s]+)
			(?:
				(?: \b
						(?: bis |
						    in  |
							aequat
						)
					(?!\p{Alpha})
											) | # multiletter symbols
				(?: \#
						(?: point |
							infinitum |
							cos1 |
							cos2
						)
					\#						) | # multiletter codes
				(?: \#gre
						.*?
					\#end
											) | # greek
				(?: □'[a-z][0-9]			) | # special operators, such as sqrt
				(?: □[Ÿƒ]					) | # other special operators
				(?: □C?						) | # cubic-simple root symbol
				(?: [º¿]					) | # other special operators
				(?: [&€]\p{Alpha} 			) | # variables
				(?: [0-9]+      			) | # digits
				(?: [~\s]+					) | # white space
				(?: [⌈⌉]					) | # italic markers
				(?: [^<>○⊂⊃\p{Alnum}]		)   # operators, brackets, relations, and whatever,
												#	NB ○○ (coming from @@) is not part of a formula
												#	NB ⊂ and ⊃ (coming from #< and >#) is not part of a formula
			) {1,}
			(?: \z|[.,:;!?<>⊂⊃'\s+])
		)
		/analyseformulas($amid, $1)/sgex;

# count remaining formulas by counting €- and &- symbols and root symbols that are still left untreated
		my $nrem = 0;
		my @remaining = ();

# 	€& symbols plus following alphabetical character
		(@remaining) = $body =~ m/[€&□÷~]/sg;
		$nrem += scalar(@remaining);

		if ($nrem) {
			$formulasrem{$amid} = $nrem;
		}

		$editiontext .= $pre . $body . $post;
	}

	if ($nfout) {
		printf STDERR $emessfmt, "wrong letters", $nfout;
	}

# all kinds of outputs: 

# a list of multiletter words in formulas

	if (!open(FLO, ">:encoding(UTF-8)", $formulapath)) {
		printf STDERR $emessfmtx, "Can't write file [$formulapath]";
		return 0;
	}

	printf FLO "===FORMULA WORD INDEX====%s\n", ("=" x 40);
	for my $f (sort lengthfirst keys %formulawords) {
		my $amids = $formulawords{$f};
		my $occurrences = "";
		for my $amid (sort keys %$amids) {
			$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
		}
		printf FLO "%-6s %s\n", '['.$f.']', $occurrences;
	}

	my %formstat = ();
	my $fnum = 0;

# a table of formulas, sorted by category, then length first, then lexicographically
# one file with the originals, one file with the converted ones

	if (!open(FOLO, ">:encoding(UTF-8)", $formulaoutpath)) {
		printf STDERR $emessfmtx, "Can't write file [$formulaoutpath]";
		return 0;
	}

	printf FLO "\n===FORMULA TABLE====%s\n", ("=" x 40);
	printf FOLO "\n%s===FORMULA TABLE====%s\n", '%', ("=" x 40);
	for my $t (sort invert keys %{$formulaindex{input}}) {
		printf FLO "\n===TYPE %s====%s\n", $t, ("=" x 40);
		printf FOLO "\n%s===TYPE %s====%s\n", '%', $t, ("=" x 40);
		my $formulas = $formulaindex{input}->{$t};
		for my $f (sort lengthfirst keys %$formulas) {
			my $amids = $formulas->{$f};;
			my $occurrences = "";
			for my $amid (sort keys %$amids) {
				$occurrences .= sprintf "%s (%d x); ", $amid, $amids->{$amid};
				$formstat{$t} += $amids->{$amid};
			}
			my $tf = $formulaindex{table}->{$f};
			$fnum++;
			printf FLO "f%04d: %s\n%s\n%s\n", $fnum, $occurrences, $f, ('=' x 40);
			printf FOLO "%s f%04d: %s\n%s\n%s\n", '%', $fnum, $occurrences, $tf, ('=' x 40);
		}
	}

	close FLO;
	close FOLO;

# Record the pagenumbers of formulas, in order to identify the output from dvipng later on

	if (!open(TXLO, ">:encoding(UTF-8)", $formulapagpath)) {
		printf STDERR $emessfmtx, "Can't write file [$formulapagpath]";
		return 0;
	}

	my $pageno = 0;
	for my $fid (sort keys %{$formulaindex{tex}}) {
		my $pagestr = sprintf "%03d", ++$pageno;
		$formulaindex{pic}->{$pagestr} = $fid;
		printf TXLO "%s\t%s\n", $pagestr, $fid; 
	}
	close TXLO;

# TeX output for the individual formulas in document order, ready for feeding to the TeX typesetting engine

	if (!open(TILO, ">:encoding(UTF-8)", $formulatexipath)) {
		printf STDERR $emessfmtx, "Can't write file [$formulatexipath]";
		return 0;
	}

	print TILO '\\nopagenumbers
';
	for my $fid (sort keys %{$formulaindex{tex}}) {
		my $tform = $formulaindex{tex}->{$fid};
		$tform =~ s/⊂/>/g;
		$tform =~ s/⊃/</g;
		printf TILO "%s\\par\\vfill\\eject\n", $tform;
	}
	print TILO "\\bye\n";

	close TILO;

# provide statistics

	for my $t (sort keys %formstat) {
		printf STDERR $imessfmt, $t, $formstat{$t};
	}

	my $tngm = 0;
	my $gmstr = '';
	for my $gm (sort keys %greekmathused) {
		my $ngm = $greekmathused{$gm};
		$tngm += $ngm;
		$gmstr .= sprintf "%s: %d; ", $gm, $ngm;
	}
	printf STDERR $imessfmt, "Greekmath", $tngm;
	printf STDERR $imessfmtx, "\t$gmstr";
	for my $kind (sort keys %nmath) {
		printf STDERR $imessfmt, $kind, $nmath{$kind};
	}

	my $nremaining = 0;
	for my $amid (sort keys %formulasrem) {
		push @{$errors{'FORMULAS'}}, sprintf("Remaining formulas in [%s] (%d x)\n", $amid, $formulasrem{$amid});
		$nremaining += $formulasrem{$amid};
	}
	printf STDERR $rmessfmt, "Looked at", $n, "candidates";
	printf STDERR $rmessfmt, "Found", $nformulas, "formulas";
	printf STDERR $rmessfmt, "Did", $ngood, "letters";
	if ($nremaining) {
		printf STDERR $emessfmt, "Remaining formulas", $nremaining;
	}
}

sub analyseformulas {
	my $amid = shift;
	my $form = shift;

# take care of leaders and trailers
	my ($lead, $xform, $trail) = $form =~ m/^([.,:;!?'<>⊂⊃\s]*)(.*?)([.,:;!?'<>⊂⊃\s]*)$/s;
	if ($xform =~ m/^[0-9,.:;!?()⌈⌉\s]*$/) {
		return $form;
	}

# check whether "in" is really binary: it should not initiate or terminate the formula

	my ($ipre, $in, $ipost);
	($in, $ipost) = $xform =~ m/^([\s⌈⌉]*in[\s⌈⌉]+)(.*)$/s;
	if (defined $in) {
		$lead .= $in;
		$xform = $ipost;
		$in = undef;
	}
	($ipre, $in) = $xform =~ m/^(.*?)([\s⌈⌉]+in[\s⌈⌉]*)$/s;
	if (defined $in) {
		$trail = $in . $trail;
		$xform = $ipre;
		$in = undef;
	}

# remove italic scopes
# first the balanced ones
	$xform =~ s/⌈(.*?)⌉/$1/sg;

# now the unbalanced ones: move initial and final italic markers out of the formula

	my ($xpre, $xpost, $xproper);
	($xpre, $xproper) = $xform =~ m/^(.*?)⌉(.*)$/s;
	if (defined $xproper) {
		$lead .= '⌉';
		$xform = $xpre . $xproper;
		$xproper = undef;
	}
	($xproper, $xpost) = $xform =~ m/^(.*?)⌈(.*)$/s;
	if (defined $xproper) {
		$trail = '⌈'. $trail;
		$xform = $xproper . $xpost;
		$xproper = undef;
	}

# check the resulting balance
	my $nb = $xform =~ s/⌈//sg;
	my $ne = $xform =~ s/⌉//sg;
	if ($nb != $ne) {
		push @{$errors{'FORMULAS'}}, sprintf("Unbalanced italic scope removed from [%s] in [%s]; open: %d; close %d\n", $form, $amid, $nb, $ne);
	}
	
# then split the formulas according to punctuation
# N.B. "." did occur as operator, sometimes repeated, but it has been escaped in the source by ¡
# #infinitum# is treated as a special punctuation symbol: it splits formulas, but it is also treated as a formula on its own.
# the reason is that the symbol has to be included as an image 

	my $result = $lead;
	my ($rest, $pre, $thispunc, $newrest);
	$rest = $xform;
	while ($rest ne '') {
		($pre, $thispunc, $newrest) = $rest =~ m/^([^.,:;!?]*?)((?:\#infinitum\#)|(?:[.,:;!?]+))(.*)$/s;
		if (!defined $pre) {
			$pre = $rest;
			$thispunc = '';
			$newrest = '';
		}
		if ($thispunc eq '#infinitum#') {
			$thispunc = analyseformula($amid, $thispunc);
		}
		$result .= analyseformula($amid, $pre) . $thispunc;
		$rest = $newrest;
	}
	$result .= $trail;
	return $result;
}

sub analyseformula {
	my $amid = shift;
	my $form = shift;

# do we have a real formula?
# Criterion: it should contain a variable or an operator
	my $isform = 0;
	for my $x (1) {
		if ($form =~ m/♠/) {$isform = 1; next;}
		if ($form =~ m/
				(?: \#
						(?: 
							infinitum |
							cos[12]
						)
					\#						) | # multiletter codes
				(?: □'[a-z][0-9]			) | # special operators, such as sqrt
				(?: □[Ÿƒ]					) | # other special operators
				(?: □						) | # cubic-simple sqrt
				(?: [º¿\/÷|~]				) | # other special operators
				(?: [€&]\p{Alpha}  			)   # variables
			/sx) {$isform = 1; next;}
	}
# weed out textual use of /

	if ($isform) {
# no real operands
		if ($form =~ m/^[^\/\p{Alnum}]*\/\P{Alnum}*$/s) {
			$isform = 0;
		}
# part of a date
		elsif ($form =~ m/^[0-9?\/\[\]]*\/[\[\]]?16[0-9][0-9][\[\]]?$/s) {
			$isform = 0;
		}
# remaining case
		elsif ($form eq '/9') {
			$isform = 0;
		}
	}

	if (!$isform) {
		return $form;
	}

	$nformulas++;

# fix the identification of this formula
	my ($vol, $lnum) = $amid =~ m/^AM([0-9]+)-[0-9]+-(.*)$/;
	my $thisformulaid = sprintf 'AM%dL%sF%03d', $vol, $lnum, ++$formulaid;

# strip the initial and trailing whitespace (punctuation has already been stripped)
	my ($pre, $newform, $post) = $form =~ m/^(\s*)(.*?)(\s*)$/s;

# correction: if the formula contains ) but no ( then the ( belongs to text, not to a formula
	if ($newform =~ m/\)\s*$/s and $newform !~ m/\(/) {
		$newform =~ s/(\)\s*)$//s;
		$post = $1 . $post;
	}

# determine the type of formula, since we use different formatting for different types
	my $type = classifyformula($newform);
	$newform =~ s/♠//sg; # remove the symbol that forces displayed equations
	my $notation = "";

# make a catalog of the formulas in their input form, by category
	$formulaindex{input}->{$type}->{$form}->{$amid}++;

# make a catalog of multiletter symbols in the formula
	my (@words) = $newform =~ m/(\p{Alpha}{2}\p{Alnum}{1,})/sg;
	for my $w (@words) {
		$formulawords{$w}->{$amid}++;
	}

	my ($thisn, $n);

# groupings  " ... " and ‚" ... ‚" (the latter is inner grouping)

	$thisn = 0;
	$thisn += $newform =~ s/‚"([^"]*)‚"/〔$1〕/sg;
	$thisn += $newform =~ s/"([^"]*)"/【$1】/sg;
	if ($thisn and $type !~ m/^C/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s outside mathmode in %s\n", '{...}', $thisformulaid);
	}
	$nmath{braces} += $thisn;

# pre-treatment of roots: replace root-constructs by ⌊ ... ⌋ where ... is the stuff that is in the scope of the root

# roots □'d9 ... □'c4, □'d9 ... □'e4, □'f9 ... □'e4 (not nested in each other)

	$thisn = 0;
	$thisn += $newform =~ s/□'d9(.*?)□'c4/⌊$1⌋/sg;
	$thisn += $newform =~ s/□'d9(.*?)□'e4/⌊$1⌋/sg;
	$thisn += $newform =~ s/□'f9(.*?)□'e4/⌊$1⌋/sg;
	if ($thisn and $type !~ m/^C/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s outside mathmode in %s\n", '\\sqrt{...}', $thisformulaid);
	}
	$nmath{roots} += $thisn;

# roots □Ÿ ... □ƒ

	$n = $newform =~ s/□Ÿ(.*?)□ƒ/◁$1▷/sg;
	if ($n and $type !~ m/^C/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s outside mathmode in %s\n", '\\sqrt{...}', $thisformulaid);
	}
	$nmath{roots} += $n;

# roots \"..."

	$n = $newform =~ s/□【([^】]*)】/◀$1▶/sg;
	if ($n and $type !~ m/^C/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s outside mathmode in %s\n", '\\sqrt{...}', $thisformulaid);
	}
	$nmath{roots} += $n;

# roots \8765

	$n = $newform =~ s/□([0-9]+)/◐$1◑/sg;
	$nmath{roots} += $n;

# roots \[€&]A

	$n = $newform =~ s/□([€&].)/◐$1◑/sg;
	$nmath{roots} += $n;

# roots (cubic) \C escaped as □C

	if ($type =~ m/^A/) {
		$n = $newform =~ s/□C/√C/sg;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/□C/{\\sqrt{}C}}/sg;
	}
	$nmath{roots} += $n;

# roots (simple) \ escaped as □

	if ($type =~ m/^A/) {
		$n = $newform =~ s/□/√/sg;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/□/{\\sqrt{}}/sg;
	}
	$nmath{roots} += $n;

# extra braces to constrain the scope of TeX's \over:  A + B/C + D => A + { B/C } + D
# we use the characters 〈 and 〉for these braces. 
# take also the braces from the roots and " etc into account
# We only do this if the formula will be typeset in math mode
# there is no deep nesting of ÷, nowhere

	if ($type =~ m/^C/) {
		$n = $newform =~ s/
			(
				(?:									# the piece before the division
					(?:								#	either a subexpression enclosed in braces
						【
							[^÷【】]+				#		that does not contain other braces and divisions and extra braces
						】
					) |
					(?:								#	either a subexpression enclosed in subbraces
						〔
							[^÷〔〕]+				#		that does not contain other braces and divisions and extra subbraces
						〕
					) |
					(?:								#	either a subexpression enclosed in parentheses
						\(
							[^÷()]+					#		that does not contain other braces and divisions and extra parentheses
						\)
					) |
					(?:								#	either a subexpression enclosed in root braces
						⌊
							[^÷⌊⌋]+					#		that does not contain other braces and divisions and extra braces
						⌋
					) |
					(?:								#	either a subexpression enclosed in root braces
						◐
							[^÷◐◑]+					#		that does not contain other braces and divisions and extra braces
						◑
					) |
					(?:								#	either a subexpression enclosed in root braces
						◀
							[^÷◀▶]+					#		that does not contain other braces and divisions and extra braces
						▶
					) |
					(?:								#	either a subexpression enclosed in root braces
						◁
							[^÷◁▷]+					#		that does not contain other braces and divisions and extra braces
						▷
					) |
					(?:								#	either a subexpression enclosed in root braces
						〈
							[^÷〈〉]+				#		that does not contain other braces and divisions and extra braces
						〉
					) |
					(?:								#	or an "atomic" subexpression (no braces, brackets, spaces, divisions
						[^÷()【】〔〕⌊⌋◐◑◀▶◁▷〈〉\s~]+
					)
				)
			) 
			(\s*÷\s*)								# the division itself
			(
				(?:									# the piece after the division
					(?:								#	either a subexpression enclosed in braces
						【
							[^÷【】]+				#		that does not contain other braces and divisions and extra braces
						】
					) |
					(?:								#	either a subexpression enclosed in subbraces
						〔
							[^÷〔〕]+				#		that does not contain other braces and divisions and extra subbraces
						〕
					) |
					(?:								#	either a subexpression enclosed in parentheses
						\(
							[^÷()]+					#		that does not contain other braces and divisions and extra parentheses
						\)
					) |
					(?:								#	either a subexpression enclosed in root braces
						⌊
							[^÷⌊⌋]+					#		that does not contain other braces and divisions and extra braces
						⌋
					) |
					(?:								#	either a subexpression enclosed in root braces
						◐
							[^÷◐◑]+					#		that does not contain other braces and divisions and extra braces
						◑
					) |
					(?:								#	either a subexpression enclosed in root braces
						◀
							[^÷◀▶]+					#		that does not contain other braces and divisions and extra braces
						▶
					) |
					(?:								#	either a subexpression enclosed in root braces
						◁
							[^÷◁▷]+					#		that does not contain other braces and divisions and extra braces
						▷
					) |
					(?:								#	either a subexpression enclosed in root braces
						〈
							[^÷〈〉]+				#		that does not contain other braces and divisions and extra braces
						〉
					) |
					(?:								#	or an "atomic" subexpression (no braces, brackets, spaces, divisions
						[^÷()【】〔〕⌊⌋◐◑◀▶◁▷〈〉\s~]+
					)
				) 
			)
		/addbraces($1,$2,$3)/sxge;
		$nmath{'braces-extra'} += $n;
	}

# single letter symbols (italic, roman, etc)

	$newform =~ s/((?:[€&]\p{Alpha})+)/mathvars($1, $type)/sge; 

# multi letter symbols (italic, roman, etc)

	if ($type =~ m/^A/) {
		$newform =~ s/\b(in|bis|aequat)\b/<hi rend="i">$1<\/hi>/sg;
	}
	elsif ($type =~ m/^C/) {
		$newform =~ s/\b(in|bis|aequat)\b/\\ {\\it $1}\\ /sg;
	}

# powers (superscripts)
	if ($type =~ m/^A/) {
		$n = $newform =~ s/≥(.*?)¥/<hi rend="sup">$1<\/hi>/sg;
		$nmath{power} += $n;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/≥(.*?)¥/^{$1}/sg;
		$nmath{power} += $n;
	}

# subscripts
	if ($type =~ m/^A/) {
		$n = $newform =~ s/º(.*?)¿/<hi rend="sub">$1<\/hi>/sg;
		$nmath{subscr} += $n;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/º(.*?)¿/_{$1}/sg;
		$nmath{subscr} += $n;
	}

# division

	if ($type =~ m/^A/) {
		$n = $newform =~ s/÷/÷/sg;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/÷/\\over /sg;
# translate the extra braces into normal braces
		my $nb = $newform =~ s/〈/\{/sg;
		my $ne = $newform =~ s/〉/\}/sg;
		if ($nb != $n or $ne != $n) {
			push @{$errors{'FORMULAS'}}, sprintf("In [%s]: [%s] =>\n[%s]:\n extra braces not equal to divisions; divisions: %d, open: %d, close: %d.\n", $thisformulaid, $form, $newform, $n, $nb, $ne);
		}
	}
	$nmath{divs} += $n;

# braces: finalize
	$newform =~ s/【(.*?)】/{$1}/sg;
	$newform =~ s/〔(.*?)〕/{$1}/sg;

# roots: finalize

	$newform =~ s/⌊(.*?)⌋/\\sqrt{$1}/sg;
	$newform =~ s/◀(.*?)▶/\\sqrt{$1}/sg;
	$newform =~ s/◁(.*?)▷/\\sqrt{$1}/sg;
	if ($type =~ m/^A/) {
		$newform =~ s/◐(.*?)◑/√$1/sg;
	}
	elsif ($type =~ m/^C/) {
		$newform =~ s/◐(.*?)◑/\\sqrt{$1}/sg;
	}

# dots

	$n = $newform =~ s/¡/./sg;
	$nmath{dots} += $n;

# vertical bars

	my $nd;
	if ($type =~ m/^A/) {
		$nd = $newform =~ s/\|\|/||/sg;
		$n = $newform =~ s/\|/|/sg;
	}
	elsif ($type =~ m/^C/) {
		$nd = $newform =~ s/\|\|/\\Vert /sg;
		$n = $newform =~ s/\|/\\vert /sg;
	}
	$nmath{'vertbar(single)'} += $n;
	$nmath{'vertbar(double)'} += $nd;

# plusminus

	if ($type =~ m/^A/) {
		$n = $newform =~ s/\+-/±/sg;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/\+-/\\pm /sg;
	}
	$nmath{plusminus} += $n;

# fraction - horizontal

	if ($type =~ m/^A/) {
		$n = $newform =~ s/\//\//sg;
	}
	$nmath{'frac/'} += $n;

# minus sign (in TeX ok as it is, in TEI: change to unicode 2212 −)
	if ($type =~ m/^A/) {
		$n = $newform =~ s/-/−/sg;
	}
	$nmath{'minus-unicode'} += $n;

# cossic symbols

	$n = $newform =~ s/#cos([12])#/<figure rend="inline"><graphic url="cossic$1.png"\/><\/figure>/sg;
	if ($n and $type !~ m/^A/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s inside mathmode in %s\n", 'cossic', $thisformulaid);
	}
	$nmath{cossic} += $n;

# infinity and equals

	$n = $newform =~ s/#infinitum#/<figure rend="inline"><graphic url="propto.png"\/><\/figure>/sg;
	if ($n and $type !~ m/^A/) {
		push @{$errors{'FORMULAS'}}, sprintf("%s inside mathmode in %s\n", 'propto', $thisformulaid);
	}
	$nmath{'infinitum'} += $n;

	$n = $newform =~ s/=/=/sg;
	$nmath{equals} += $n;

# squares
	if ($detect_squares) {
		if ($type =~ m/^A/) {
			$n = $newform =~ s/(\p{Alpha})\1/$1<hi rend="sup">2<\/hi>/sg;
		}
		else {
			$n = $newform =~ s/(\p{Alpha})\1/{$1^2}/sg;
		}
		$nmath{squares} += $n;
	}

# spaces
	if ($type =~ m/^A/) {
		$n = $newform =~ s/\~/ /sg;
	}
	elsif ($type =~ m/^C/) {
		$n = $newform =~ s/\~/\\ /sg;
	}
	$nmath{hardspaces} += $n;

# TeX mathmode and dispayed equations ($ versus $$)
	if ($type eq 'C1') {
		$newform =~ s/\n/ /sg;
		$newform = '$'.$newform.'$';
		$notation = ' notation="TeX"';
	}
	elsif ($type eq 'Cn') {
		$newform =~ s/\n/\\cr\n/sg;
		$newform = '$$\\displaylines{'.$newform.'}$$';
		$notation = ' notation="TeX"';
	}

# check whether all temporary symbols have been removed now
	for my $symbol ([
			'【',
			'】',
			'〔',
			'〕',
			'⊂', 
			'⊃',
			'⌊',
			'⌋',
			'◀',
			'▶',
			'◁',
			'▷',
			'◐',
			'◑',
			'□',
			'º',
			'¿',
			['\\', 1],
			['/', 1],
			'÷',
			'|',
			'~',
			'#',
			'€',
			'&',
		]) {
		my ($opat, $flag);
		if (ref $symbol) {
			($opat, $flag) = @$symbol;
		}
		else {
			($opat, $flag) = ($symbol, 0);
		}
		my $pat = quotemeta($opat);
		if ($flag) {
			$n = $newform =~ s/$pat(\P{Alnum})/$pat$1/sg;
		}
		else {
			$n = $newform =~ s/$pat/$pat/sg;
		}
		if ($n) {
			push @{$errors{'FORMULAS'}}, sprintf("In [%s]: [%s] =>\n[%s]:\n Remaining temporary symbol [%s] (%d x).\n", $thisformulaid, $form, $newform, $opat, $n);
		}
		$nmath{'temporary symbols'} += $n;
	}

# compose the output form of the formula
	my $graphic = '';

# make a catalog of how the input formulas are translated to output formulas
	$formulaindex{table}->{$form} = $newform;

# make a catalog of the TeX formulas in document order
	if ($type =~ m/^C/) {
		$formulaindex{tex}->{$thisformulaid} = $newform;
		$graphic = "<figure rend=\"inline\"><graphic url=\"$thisformulaid.$formulaformat\"/></figure>";
	}
	my $identification = " id=\"$thisformulaid\"";

	#my $result = "$pre<formula$identification$notation>$graphic$newform</formula>$post";
	my $result = "$pre$graphic<formula$identification$notation>$newform</formula>$post";
	return $result;
}

sub addbraces {
	my ($left, $op, $rght) = @_;
	my ($leftnum, $rghtnum, $leftd, $rghtd, $leftroot, $rghtroot);

# default mode: follow tex rules

	if ($division_mode eq 'default') {
		return "〈$left$op$rght〉";
	}

# display mode: do not shrink anything

	$leftd = "\\displaystyle\\strut ";
	$rghtd = "\\displaystyle\\strut ";
	if ($division_mode eq 'display') {
		return "〈$leftd$left$op$rghtd$rght〉";
	}


# subtle mode: gather information

	if ($division_mode eq 'subtle') {
		$leftnum = $left =~ m/^((?:□'[a-z][0-9])|□Ÿ|□ƒ|□|[0-9\s])+$/s;
		$rghtnum = $rght =~ m/^((?:□'[a-z][0-9])|□Ÿ|□ƒ|□|[0-9\s])+$/s;
		$leftroot = $left =~ m/□/;
		$rghtroot = $rght =~ m/□/;

#
		if ($leftnum and $rghtnum) {
			$leftd = '';
			$rghtd = '';
		}
		else {
			$leftd = "\\displaystyle\\strut ";
			$rghtd = "\\displaystyle\\strut ";
		}
		return "〈$leftd$left$op$rghtd$rght〉";
	}
}

sub mathvars {
	my ($vars, $type) = @_;

# &-vars roman, € vars italic, no italics for greek vars
# strip the symbol markers
# in TEI mode
	if ($type =~ m/^A/) {
		$vars =~ s/((?:€[A-Za-z])+)/<hi rend="i">$1<\/hi>/sg;
	}
	elsif ($type =~ m/^C/) {
# replace Greek letters by corresponding TeX control sequences
		$vars =~ s/((?:&[A-Za-z])+)/{\\rm $1}/sg;
		$vars =~ s/(\p{Alpha})/greekmath($1)/sge; 
	}
	$vars =~ s/[€&]//g;
	return $vars;
}

sub greekmath {
	my $symbol = shift;

	my $gm = $greekmath{$symbol};
	if (!defined $gm) {
		return $symbol;
	}
	else {
		$greekmathused{$gm}++;
		return $gm;
	}
}

sub classifyformula {
	my $form = shift;
	my $type;
	my (@nls) = $form =~ m/(\n)/sg;
	my $nnl = scalar(@nls);
	my $nch = length $form;

# leading and trailing whitespace has been stripped already
# strip the italic codes temporarily
# promote formulas to C types if they contain squares

	$form =~ s/[⌈⌉]//sg;
	for my $x (1) {
		if ($nch <= $longformula_limit) {
			if ($form =~ m/^
				(?:
					(?: \#cos[12]\#   	) |
					(?: \#infinitum\#  	) |
					(?: [0-9]+  	    ) |
					(?: [€&]\p{Alpha} 	) 
				) + 
			$/sx ) {
				$type = 'A'; # ATOMIC formulas
				next;
			}
			if ($form =~ m/^
				(?:
					(?: in | bis | aequat	) |
					(?: \#cos[12]\#   		) |
					(?: [0-9]+      		) |
					(?: [€&]\p{Alpha}  		) |
					(?: □C			  		) |
					(?: [~\s]+ 				) |
					(?: [≥¥º¿()=□\/|+-]+ 		) 
				) + 
			$/sx ) {
				$type = 'A+'; # short chain of ATOMIC formulas and simple operators
				next;
			}
		}
		if ($form =~ m/♠/) {
			$type = 'Cn'; # displayed formula forced by input
		}
		elsif ($nch <= $longformula_limit) {
			$type = 'C1'; # complex formulas, not long, involved math typesetting needed
		}
		else {
			$type = 'Cn'; # complex formulas, long (displayed equation), or involved math typesetting needed
		}
	}
	return $type;
}

sub do_formset {

	my $good = 1;

# read the pagina index file if needed

	if (!exists $formulaindex{pic}) {
		my $pagsrc = readfile($formulapagpath);
		chomp @$pagsrc;
		for my $line (@$pagsrc) {
			my ($pagstr, $fid) = split /\t/, $line;
			$formulaindex{pic}->{$pagstr} = $fid;
		}
	}

# typeset the plain formulas with TeX

	if ($good) {
		my $ftexpath = $formulatexipath;
		$ftexpath =~ s/ /\\ /g;
		my $tpath = $texpath;
		$tpath =~ s/ /\\ /g;

		my $cmd = "tex -interaction=nonstopmode -output-directory=$tpath $ftexpath 2>&1";

		if (!open(CMD, '-|', $cmd)) {
			push @{$errors{'TEX-RUN'}}, sprintf("tex command could not be started [%s]\n", $cmd);
		}
		else {
			my @lines = <CMD>;
			my $output = join "", @lines;
			my $ok = close CMD;
			if (!$ok) {
				push @{$errors{'TEX-RUN'}}, sprintf("tex command failed[%s]\n%s", $cmd, $output);
				$good = 0;
			}
			else {
				my ($info) = $output =~ m/\(([0-9]+ pages, [0-9]+ bytes)\)/s;
				printf STDERR $imessfmtx, "TeX run for formulas: $info";
			}
		}
	}

# run dvipng or dvisvgm and create individual, tight pics for each formula

# 	first delete the previous formula results and create a fresh formulas directory
	if ($good) { 
		eval {rmtree($formulaspath)};
		my $msg = $@;
		if ($msg ne '') {
			printf STDERR $emessfmtx, "Cannot remove dir [$formulaspath]\n\t$msg";
			$good = 0;
		}
	}
	if ($good) {
		eval {mkpath($formulaspath)};
		my $msg = $@;
		if ($msg ne '') {
			printf STDERR $emessfmtx, "Cannot create dir [$formulaspath]\n\t$msg";
			$good = 0;
		}
	}

# 	run the dvi-processing command

	my $formpath;
	my $cmd;

	$formpath = $formulaspath;
	$formpath =~ s/ /\\ /g;
	my $fdvipath = $formuladviipath;
	$fdvipath =~ s/ /\\ /g;

	if ($formulaformat eq 'gif') {
		$cmd = "dvipng --gif $dvipng_opts --height --depth --width -o $formpath/%03d.$formulaformat $fdvipath";
	}
	else {
		$cmd= "dvisvgm $dvisvg_opts --page=1- --output=$formpath/%p.$formulaformat $fdvipath 2>&1";
	}

	if ($good) {
		if (!open(CMD, '-|', $cmd)) {
			push @{$errors{'TEX-RUN'}}, sprintf("dvipng command could not be started [%s]\n", $cmd);
		}
		else {
			my @lines = <CMD>;
			my $output = join ("", @lines);
			my $info;
			if ($formulaformat eq 'gif') {
				($info) = $output =~ m/\[([0-9]+)[^\]]*\]\s*$/s;
				# record the image dimensions
				my (@sizes) = $output =~ m/\[([^\]]*)\]/sg;
				for my $size (@sizes) {
					my ($pg) = $size =~ m/^([0-9]+)/;
					my ($wd) = $size =~ m/width=[+-]?([0-9]+)/;
					my ($ht) = $size =~ m/depth=([+-]?[0-9]+)/; # bug in dvipng: height and depth exchanged in reporting
					my ($dp) = $size =~ m/height=([+-]?[0-9]+)/;
					$pg = sprintf "%03d", $pg;
					my $id = $formulaindex{pic}->{$pg};
					$formulasize{$id} = [$wd, $ht + $dp, -$dp]; # bug in dvipng documentation: real height is height as reported plus signed depth 
																# depth is usually negative so 
																# if reported [w,h,d] = [100, -20, 80] 
																# then real [w,h,d] = [100, 80-20, --20] = [100, 60, 20]
				}
			}
			else {
				($info) = $output =~ m/^([0-9]+) of [0-9]+ pages converted in [0-9.]+ seconds/m;
			}
			my $ok = close CMD;
			if (!$ok) {
				push @{$errors{'TEX-RUN'}}, sprintf("dvipng command failed[%s]\n%s", $output);
				$good = 0;
			}
			else {
				printf STDERR $imessfmt, "Generated images for formulas", $info;
			}
		}
	}

# 	rename the pics according to the formula-ids

	my @pics;
	my $npic;

	if ($good) {
		@pics = glob("$formpath/*.$formulaformat");
		$npic = 0;
		if ($good) {
			for my $pic (@pics) {
				my ($basename) = $pic =~ m/([^\/]+)\.[a-z]*$/; 
				my $id = $formulaindex{pic}->{$basename};
				my $idpic = "$formulaspath/$id.$formulaformat";
				if (!move($pic, $idpic)) {
					push @{$errors{'MOVE-GIF'}}, sprintf("Cannot move [%s] to [%s]\n", $pic, $idpic);
					$good = 0;
				}
				else {
					$npic++;
				}
			}
		}
	}

# write out the picture sizes
	if ($formulaformat eq 'gif') {
		if (!open(SILO, ">:encoding(UTF-8)", $formulasizepath)) {
			printf STDERR $emessfmtx, "Can't write file [$formulasizepath]";
			return 0;
		}
		printf SILO "%s.%s\t%s\t%s\t%s\n", 'pictureid', $formulaformat, 'wd', 'ht', 'dp';
		for my $pic (sort keys %formulasize) {
			my ($wd, $ht, $dp) = @{$formulasize{$pic}};
			printf SILO "%s.%s\t%d\t%d\t%d\n", $pic, $formulaformat, $wd, $ht, $dp;
		}
		close SILO;
	}

	printf STDERR $imessfmt, "images created", scalar(@pics);
	printf STDERR $imessfmt, "formula images inplace", $npic;

# generate a proof of all typeset formulas on pages corresponding to the AM edition

	my (@elements) = $editiontext =~ m/
		(
			(?:<pb [^>]*>)	|
			(?:<formula[^>]*>.*?<\/formula>)
		)
		/sgx;
	my $formtexpath = "$texpath/$converttexfile";
	printf STDERR $imessfmt, "Number of formula and pagebreak elements", scalar(@elements);

	if (!open(F, ">:encoding(UTF-8)", $formtexpath)) {
		printf STDERR $emessfmtx, "Can't write to [$formtexpath]";
		return 0;
	}
	print F '
\\font\\sixrm="Lucida Sans Unicode" at 6pt
\\font\\eightrm="Lucida Sans Unicode" at 8pt
\\font\\tenrm="Lucida Sans Unicode" at 10pt
\\font\\sixit="Lucida Sans Unicode/I:slant=0.2" at 6pt
\\font\\eightit="Lucida Sans Unicode/I:slant=0.2" at 8pt
\\font\\tenit="Lucida Sans Unicode/I:slant=0.2" at 10pt
\\tenrm
';
	my $thispage = 0;
	my $thiscontent = '';
	my %symbols = ();
	for my $el (@elements) {
		if ($el =~ m/^<pb/) {
			if ($thispage) {
				print F $thiscontent;
				$thispage = 0;
			}
			my ($vol, $pnum) = $el =~ m/n="([0-9]+)-([0-9]+)/;
			$thiscontent = sprintf "\n\\par\\vfill\\eject\n{\\bf\\hfill AM$vol p%03d\\hfill\\hbox{}}\\par\\bigskip\n", $pnum;
			next;
		}
		my ($id, $ftext) = $el =~ m/^<formula id="([^"]*)"[^>]*>(.*?)<\/formula>/s;
		$ftext =~ s/⊂/</sg;
		$ftext =~ s/⊃/>/sg;
		my $istex = $el =~ m/notation=\"TeX\"/;
		if ($istex) {
			$ftext =~ s/^<graphic[^>]*>//;
		}
		else {
# the <hi>s are not nested
			$ftext =~ s/<hi rend="i">(.*?)<\/hi>/{\\tenit $1}/sg;
			$ftext =~ s/<hi rend="sup">(.*?)<\/hi>/\\raise1ex\\hbox{\\eightrm $1}/sg;
			$ftext =~ s/<hi rend="sub">(.*?)<\/hi>/\\lower.5ex\\hbox{\\eightrm $1}/sg;

			#$ftext =~ s/<graphic[^>]*?url="([^"]*)"[^>]*>/\$\\lbrack\$$1\$\\rbrack\$/sg;  
			my (@urls) = $ftext =~ m/<graphic[^>]*?url="([^"]*)"/sg;
			$ftext =~ s/<graphic[^>]*?url="([^"]*)"[^>]*>/\\XeTeXpicfile $1 height 2ex /sg;  
			for my $url (@urls) {
				$symbols{$url}++;
			}
		}
		my $knd = $istex?"tex":"tei";
		$thiscontent .= "{\\sixrm $id\\ {\\sixit $knd}\\ }\$\\Rightarrow\$\\ $ftext\\par\\smallskip\n";
		$thispage++;
	}
	if ($thispage) {
		print F $thiscontent;
	}
	print F "\\bye\n";
	close F;

	for my $url (sort keys %symbols) {
		if (!copy("$symbolspath/$url", "$texpath/$url")) {
			printf STDERR $emessfmtx, "Can't copy [$url] from [$symbolspath] to [$texpath]";
			return 0;
		}
	}
	my $ftpath = $formtexpath;
	$ftpath =~ s/ /\\ /g;
	my $tpath = $texpath;
	$tpath =~ s/ /\\ /g;

	chdir $texpath;
	#$cmd = "xetex -output-directory=$tpath $ftpath";
	$cmd = "xetex -interaction=nonstopmode -output-directory=$tpath $ftpath 2>&1";
	if (!open(CMD, '-|', $cmd)) {
		push @{$errors{'XETEX-RUN'}}, sprintf("xetex command could not be started [%s]\n", $cmd);
	}
	else {
		my @lines = <CMD>;
		my $output = join "", @lines;
		my $ok = close CMD;
		if (!$ok) {
			push @{$errors{'TEX-RUN'}}, sprintf("xetex command failed[%s]\n%s", $cmd, $output);
		}
		else {
			my ($info) = $output =~ m/\(([0-9]+ pages, [0-9]+ bytes)\)/s;
			printf STDERR $imessfmts, "Generated PDF for formulas", $info;
		}
	}
}

sub frenchmonth {
	my ($amid, $pre, $month, $year) = @_;
	my $monthrep = sprintf "%d", $month;
	if ($month == 0 or $month > 12) {
		push @{$errors{'HEAD WRONG MONTH'}}, sprintf("Head of letter %s has strange month: [%s]\n", $amid, $month);
	}
	else {
		$monthrep = $mois[$month-1];
	}
	my $prerep = '';
	if (length $pre) {
		$prerep = ' ';
	}
	return "$prerep $monthrep $year";
}

sub hyphen {
	my ($l, $r) = @_;
	if (($l =~ m/\w/ and $l =~ m/[^0-9]/) and ($r =~ m/\w/ and $r =~ m/[^0-9]/)) {
		$nhyph++;
		return "$l-$r";
	}
	return $l.'9'.$r;
}

sub linkmeta {
	my ($amid, $jlet) = @_;
	my ($amvol, $ampg) = $amid =~ m/^([0-9])([0-9]{3})/;
	my $jid = $jlet;
	my ($pre, $jnum, $post) = $jlet =~ m/^([^0-9]*)([0-9]+)(.*)$/;
	if (defined $jnum) {
		$jid = sprintf "%s-%s-%s%03d%s", $amvol, $ampg, $pre, $jnum, $post;
	}
	my $metakey = sprintf("%s <l %s>", $amid, $jlet);
	my $metarep = $meta{$metakey};
	if (!defined $metarep) {
		push @{$errors{'META NOT IN INDEX'}}, sprintf("At %s <l %s>:  no metadata in the index\n", $amid, $jlet);
		$metarep .= "<meta type=\"id\" value=\"AM$jid\"\/>\n";
		$metarep .= "<!--NO METADATA FOUND-->\n";
		$metanotmerged++;
	}
	else {
		$metamerged++;
		my (@dates) = $metarep =~ m/type="date" value="([^"]*)"/sg;
		if ($#dates > 0) {
			push @{$errors{'DATES'}}, sprintf("At %s <l %s>:  multiple dates in metadata [%s]\n", $amid, $jlet, join(',', @dates));
		}
	}
	my $result = "";
	if (defined $prev_jid) {
		$result .= "\n</text>\n</TEI>\n### [AM$prev_jid.xml]\n";
	}
	$result .= "\n### [AM$jid.xml]\n<!--$amid <l $jlet>-->\n<TEI>\n<teiHeader>\n$metarep</teiHeader>\n<text>\n";
	$prev_jid = $jid;
	return $result;
}

sub linkimages {
	my ($amid, $pre) = @_;
	my ($pic, $instruction, $imagerep);
	my $info;
	$info = $image{$amid};
	if (!defined $info) {
		push @{$errors{'IMAGE NOT IN INDEX'}}, sprintf("At %s is a <fig> for which no picture is in the index\n", $amid);
		$imagerep = "<figure><graphic url=\"!!NOT FOUND\"/></figure>"; 
		$picnotmerged++;
	}
	else {
		($pic, $instruction) = @$info;
		my $inlineatt = '';
		my $instrrep = '';
		if ($instruction eq 'inline') {
			$inlineatt = " rend=\"inline\"";
			$instrrep = 'inline';
		}
		$imagerep = "<figure$inlineatt><graphic url=\"$pic.gif\"/></figure>"; 
		$picmerged++;
	}
	return "$amid $pre$imagerep";
}

sub invert {
	return $b cmp $a;
}

sub lengthfirst {
	my $la = length $a;
	my $lb = length $b;
	if ($la != $lb) {
		return $lb <=> $la;
	}
	return $la cmp $lb;
}

sub readfile {
	my $file = shift;
	if (!open(F, "<:encoding(UTF-8)", $file)) {
		printf STDERR $emessfmtx, "Can't read file [$file]";
		return 0;
	}
	my @lines = <F>;
	close F;
	my ($f) = $file =~ m/([^\/]*)$/;
	printf STDERR $imessfmtr, $f, (scalar @lines);
	return \@lines;
}

sub timestamp {
	my $task = shift;
	my @time = gettimeofday();
	$times{$task} = \@time;
}

sub elapsed {
	my $task = shift;
	my $elapsed = tv_interval($times{$task});
	return sprintf("%.2f", $elapsed);
}

sub getnowtime {
	my $l = localtime();
	return sprintf "%04d-%02d-%02d %02d:%02d:%02d", $l->year()+1900, $l->mon()+1, $l->mday(), $l->hour(), $l->min(), $l->sec();
}

sub dummy {
	1;
}

sub init {

# determine which tasks to do based on the command line

	my $giventask = $ARGV[0];

	my ($firsttask, $lasttask);
	if (defined $giventask) {
		my ($ftask, $fl, $ltask) = $giventask =~ m/^([^-]*+)(-?+)([^-]*+)$/;
		if (!defined $ftask) {
			printf STDERR "Illegal task range specification [%s]. It should be: - or  task or -task or task- or task1-task2 or empty.\n", $giventask;
			return 0;
		}
		else {
			if ($fl) {
				if ($ftask eq '') {
					$firsttask = $tasks[0];
				}
				else {
					$firsttask = $ftask;
				}
				if ($ltask eq '') {
					$lasttask = $tasks[$#tasks];
				}
				else {
					$lasttask = $ltask;
				}
			}
			else {
				if ($ftask eq '') {
					$firsttask = $tasks[0];
					$lasttask = $tasks[$#tasks];
				}
				else {
					$firsttask = $ftask;
					$lasttask = $ftask;
				}
			}
		}
	}
	else {
		$firsttask = $tasks[0];
		$lasttask = $tasks[$#tasks];
	}

	my $good = 1;

# compile the list of tasks to be executed

	for my $task (@tasks) {
		$task{$task} = 1;
	}

	for my $t ($firsttask, $lasttask) {
		if (length $t and !exists $task{$t}) {
			printf STDERR "Unknown task [%s].\n", $t;
			$good = 0;
		}
	}
	if (!$good) {
		printf STDERR "Possible tasks:\n\t%s", join("\n\t", @tasks);
		return 0;
	}

	my ($findex, $lindex);
	my $nt = 0;
	for my $task (@tasks) {
		if ($task eq $firsttask) {
			$findex = $nt;
		}
		if ($task eq $lasttask) {
			$lindex = $nt;
		}
		$nt++;
	}

	print STDERR "Going to do:\n";
	for my $task (@tasks[$findex .. $lindex]) {
		$todo{$task} = 1;
		print STDERR "$task ";
	}
	print STDERR ":\n";

# create output directories if they do not exist

	for my $path ($logpath, $outputpath, $reviewpath, $texpath) {
		if (!-d $path) {
			eval {mkpath($path)};
			my $msg = $@;
			if ($msg ne '') {
				printf STDERR $emessfmtx, "Cannot create dir [$path]\n\t$msg";
				$good = 0;
			}
		}
	}

# determine the input file (especially when the selected first task is not the absolute first task)

	my ($thiseditionpath, $thiseditionfile) = ($editionpath, $editionfile);
	if ($findex > 0) {
		#my $inputrep = sprintf "%02d", $findex;
		my $inputrep = 't';
		my $sourcetask = $tasks[$findex-1];
		($thiseditionpath, $thiseditionfile) = ($convertpath, $convertfile);
		$thiseditionfile =~ s/(\.[^.]+)$/-$inputrep-$sourcetask$1/;
		$thiseditionpath =~ s/(\.[^.]+)$/-$inputrep-$sourcetask$1/;
	}
	my $editionsrc = readfile($thiseditionpath);

# if the first task is also the absolute first task, take the input from the source Japam edition
# and skip the lines that have been commented out

	if ($editionpath eq $thiseditionpath) {
		$editiontext = '';
		for my $line (@$editionsrc) {
			if ($line =~ m/^[0-9]{6}!/) {
				next;
			}
			$line =~ s/\r//sg;
			$editiontext .= $line;
		}
	}
	else {
		$editiontext = join "", @$editionsrc;
	}
	return 1;
}

sub main {
	$timestamp = getnowtime();
	timestamp('main');
	printf STDERR "%sBEGIN (%-2s)===%-20s\n", ('=' x 70), '==', 'JOB';
	if (!init()) {
		return 0;
	}


# execute the tasks

	my $good = 1;
	my $tasknumber = 0;
	for my $task (@tasks) {
		$tasknumber++;
		# my $tnrep = sprintf "%02d", $tasknumber;
		my $tnrep = 't';
		if ($todo{$task}) {
			timestamp($task);

# prepare the output and errorlocations for this task

			printf STDERR "%sBEGIN (%02d)===%-20s\n", ('=' x 70), $tasknumber, $task;
			my $method = 'do_'.$task;

			my ($thisconvertfile, $thisconvertpath, $thiserrfile, $thiserrpath) = ($convertfile, $convertpath, $errfile, $errpath);
			$thisconvertfile =~ s/(\.[^.]+)$/-$tnrep-$task$1/;
			$thisconvertpath =~ s/(\.[^.]+)$/-$tnrep-$task$1/;
			$thiserrfile =~ s/(\.[^.]+)$/-$tnrep-$task$1/;
			$thiserrpath =~ s/(\.[^.]+)$/-$tnrep-$task$1/;

# reset the errors from previous tasks and execute the task

			%errors = ();
			my $thisgood = &$method();

# write task-results to file

			if (!open(ER, ">:encoding(UTF-8)", $thiserrpath)) {
				printf STDERR $emessfmtx, "Can't write file [$thiserrpath]";
				return 0;
			}
			if (!open(CLO, ">:encoding(UTF-8)", $thisconvertpath)) {
				printf STDERR $emessfmtx, "Can't write file [$thisconvertpath]";
				$good = 0;
			}
			else {
				print CLO $editiontext;
				close CLO;
			}

# the output of the last task is written as the outcome of the conversion as a whole

			if ($tasknumber == scalar(@tasks)) {
				if (!open(CLO, ">:encoding(UTF-8)", $convertpath)) {
					printf STDERR $emessfmtx, "Can't write file [$convertpath]";
					$good = 0;
				}
				else {
					print CLO $editiontext;
					close CLO;
				}
			}

# write errors to file

			print ER $timestamp, "\n";
			for my $errkind (sort keys %errors) {
				my $messages = $errors{$errkind};
				my $nkind = scalar @$messages;
				printf ER "%-40s: %5d\n", $errkind, $nkind;
				printf STDERR $emessfmt, $errkind, $nkind;
			}

			for my $errkind (sort keys %errors) {
				my $messages = $errors{$errkind};
				my $nkind = scalar @$messages;
				printf ER "%-40s: %5d\n", $errkind, $nkind;
				print ER @$messages;
				print ER "\n";
			}
			close ER;

			if (!$thisgood) {
				$good = 0;
			}
			printf STDERR "%sEND   (%02d)===%-20s%5s\n", ('=' x 70), $tasknumber, $task, elapsed($task);
		}
	}

	printf STDERR "%sEND   (%-2s)===%-20s%5s\n", ('=' x 70), '==', 'JOB', elapsed('main');
	return $good;
}

exit !main();
