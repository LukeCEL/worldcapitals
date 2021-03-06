#!/usr/bin/perl

use strict;
use warnings;
use Spreadsheet::ParseExcel;
use Text::Unidecode;

my %capitals = (); # capitals will be stored in this hash
my $output = 'worldcapitals.ssc';

# ======================================== READ DATA ========================================
my $parser    = Spreadsheet::ParseExcel->new();
my $workbook  = $parser->parse('WUP2018-F13-Capital_Cities.xls');
my $worksheet = $workbook->worksheet('Data');

if (!defined $workbook) {
    die $parser->error(), ".\n";
}

my $rowrange = $worksheet->row_range();

# READ DATA
# The data start at row 18
for (my $i = 17; $i <= $rowrange; $i++)
{
    # Extract data
    my $index      = $worksheet->get_cell($i, 0)->unformatted();
    my $capital    = $worksheet->get_cell($i, 3)->unformatted();
    my $lat        = $worksheet->get_cell($i, 7)->unformatted();
    my $long       = $worksheet->get_cell($i, 8)->unformatted();
    my $population = $worksheet->get_cell($i, 9)->unformatted();
    
    $capitals{$index} = {
        'name'       => $capital,
        'lat'        => $lat,
        'long'       => $long,
        'population' => $population,
        'importance' => '',
    };
}

# ==================================== HANDLE EXCEPTIONS ====================================
# Tokelau has no population value listed.
# We use its final population count from the 2016 census: 1,499
# https://www.tokelau.org.nz/site/tokelau/files/TokelauNSO/2016Census/TokelauCensusTechnicalRelease1E.pdf
$capitals{217}{'population'} = 1.499;

# Fix names for a few capitals
$capitals{20}{'name'}  = 'Brussels';
$capitals{39}{'name'}  = 'Ottawa';
$capitals{50}{'name'}  = 'Taipei';
$capitals{54}{'name'}  = 'Avarua';
$capitals{90}{'name'}  = 'Nuuk';
$capitals{147}{'name'} = 'Naypyidaw';
$capitals{149}{'name'} = 'Yaren District';
$capitals{174}{'name'} = 'Chisinau';
$capitals{236}{'name'} = 'Hanoi';
$capitals{237}{'name'} = 'Mata-Utu';
$capitals{238}{'name'} = 'Laayoune';
$capitals{239}{'name'} = 'Sanaa';

# ======================================= PROCESS DATA =======================================
foreach my $index (sort keys %capitals)
{
    # POPULATION:
    # Estimate "Importance" parameter from population
    my $importance = 15 * $capitals{$index}{'population'} ** (1/3);
    $capitals{$index}{'importance'} = $importance;
    
    # NAMES:
    # Use Unidecode to replace special characters with ASCII equivalents
    my $name = $capitals{$index}{'name'};
    $name = unidecode($name);
    
    # Standardize "St." spelling to spell out the word "Saint"
    $name =~ s/St\.\s?/Saint /;
    
    # Use English-language names (usually held inside the parentheses)
    if ($name =~ /(.+) \((.+)\)/) {
        $capitals{$index}{'name'} = $2;
    } else {
        $capitals{$index}{'name'} = $name;
    }
}

# ==================================== OUTPUT SSC FILE ====================================
local(*SSC_PATH);
open(SSC_PATH, '>', $output) or die "ERROR: Could not write to $output\n";

# print header
print SSC_PATH "# Database of World Capitals\n";
print SSC_PATH "# Version 1.0 (2020-05-26)\n";
print SSC_PATH "# by LukeCEL\n";
print SSC_PATH "#\n";
print SSC_PATH "# United Nations, Department of Economic and Social Affairs, Population\n";
print SSC_PATH "# Division (2018). World Urbanization Prospects: The 2018 Revision, Online\n";
print SSC_PATH "# Available at https://population.un.org/wup/Download/\n";
print SSC_PATH "#\n";
print SSC_PATH "# This catalogue was made using a Perl script, worldcapitals.pl. Importance\n";
print SSC_PATH "# values were calculated by taking the cube root of the population (in\n";
print SSC_PATH "# thousands), and multiplying by 15. The list is more or less accurate as of\n";
print SSC_PATH "# 2018, although a few capitals are missing or outdated. The population of\n";
print SSC_PATH "# Tokelau is not listed in the file; it has been taken from the 2016 census.\n";
print SSC_PATH "# Names for a few capitals have been fixed to include more correct names or\n";
print SSC_PATH "# more common spelling variations.";

foreach my $index (sort { $capitals{$a}->{'name'} cmp $capitals{$b}->{'name'} } keys %capitals)
{
    my $name = $capitals{$index}{'name'};
    my $long = $capitals{$index}{'long'};
    my $lat = $capitals{$index}{'lat'};
    my $importance = $capitals{$index}{'importance'};

    print  SSC_PATH "\n\nLocation \"$name\" \"Sol/Earth\"\n";
    printf SSC_PATH "{\n";
    printf SSC_PATH "    LongLat [ %.4f %.4f 0 ]\n", $long, $lat;
    printf SSC_PATH "    Importance %.2f\n", $importance;
    print  SSC_PATH "    Type \"City\"\n";
    print  SSC_PATH "}";
}
