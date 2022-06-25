[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/Dans-labs/descartes-tei/)](https://archive.softwareheritage.org/browse/origin/https://github.com/Dans-labs/descartes-tei/)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

![descartes](/docs/files/Descartes.png)

[Read the docs](/docs/index.md)

# Author

[Dirk Roorda](https://github.com/dirkroorda)

# Status

2022-06-25

After a 10yr break I am playing with the idea to convert the result of this project,
a corpus in TEI with mathematical formules in TeX and then typeset in GIF images,
to Text-Fabric.

The idea is to display the formulas in TeX using the capabilities of the Jupyter Notebook, i.e.
MathJax.

Today I ran the conversion again, by means of the original Perl script.
It ran without installing anything and without modification, except for one line
in the customisation section of `convert.pl` (the path to the root of the project).

And I have a working TeX installation on this computer (MacTex, a standard install).

This run produces the TeX formulas again, ran TeX over them, and saved them as images again,
all of which are now in the repo.



