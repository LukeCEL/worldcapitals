# worldcapitals
Creates updated database of world capital locations for Celestia.

## License
Copyright (C) 2020  LukeCEL

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.


## About
The official development of Celestia stopped in 2011, and has only recently picked up. Since then, most of the catalogs have since become outdated. This script creates worldcapitals.ssc, a file intended to replace world-capitals.ssc. The old file uses [APPENDIX-f of the CIA Factbook 2003](https://web.archive.org/web/20030205084318/http://www.odci.gov/cia/publications/factbook/appendix/appendix-f.html), supplemented by the [Getty Thesaurus](http://www.getty.edu/research/conducting_research/vocabularies/tgn/index.html). This one mainly uses the [UN's Excel spreadsheet of capital city populations, 2018 revision](https://population.un.org/wup/Download/).

I am not an expert at Perl by any means. If you spot any bugs, please do give feedback!

## Prerequisites
This script was written in Perl. In addition to Perl, you also need these modules:

* Spreadsheet::ParseExcel
* Text::Unidecode

It is recommended that you install both of these modules using `cpanm`. You can find instructions for installing `cpanm` here at https://www.cpan.org/modules/INSTALL.html.

To download the data source itself, go to https://population.un.org/wup/Download/, click on "Urban Agglomerations", and click on "WUP2018-F13-Capital_Cities.xls". The downloaded spreadsheet must be in the same directory as the one you are running from.

## Usage

1. Install Perl and the prerequisite modules.

2. Download the Excel spreadsheet.

3. In the command-line, `cd` (change the current directory) to the one that has the Excel spreadsheet.

4. In the command-line, type: `perl worldcapitals.pl`. Instead of `worldcapitals.pl`, you may also add the location of the file relative to the directory from which you are running.

The Perl script should automatically create an SSC file called `worldcapitals.ssc`. Note the lack of a hyphen; the original SSC file is called `world-capitals.ssc` with a hyphen.

## Acknowledgements
This code primarily makes use of this source: [United Nations, Department of Economic and Social Affairs, Population Division (2018). World Urbanization Prospects: The 2018 Revision, Online Edition; File 13: Population of Capital Cities in 2018 (thousands)](https://population.un.org/wup/Download/). It is copyright © 2018 by United Nations and is licensed under [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/).

Thank you to Chris Laurel and everyone who helped make Celestia great in the first place. In addition, thank you to Fridger Schrempp for providing the original world-capitals.ssc file.
