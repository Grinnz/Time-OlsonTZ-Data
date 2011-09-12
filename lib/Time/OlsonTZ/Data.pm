=head1 NAME

Time::OlsonTZ::Data - Olson timezone data

=head1 SYNOPSIS

	use Time::OlsonTZ::Data qw(olson_version);

	$version = olson_version;

	use Time::OlsonTZ::Data qw(
		olson_canonical_names olson_link_names olson_all_names
		olson_links
		olson_country_selection
	);

	$names = olson_canonical_names;
	$names = olson_link_names;
	$names = olson_all_names;
	$links = olson_links;
	$countries = olson_country_selection;

	use Time::OlsonTZ::Data qw(olson_tzfile);

	$filename = olson_tzfile("America/New_York");

=head1 DESCRIPTION

This module encapsulates the Olson timezone database, providing binary
tzfiles and ancillary data.  Each version of this module encapsulates
a particular version of the timezone database.  It is intended to be
regularly updated, as the timezone database changes.

=cut

package Time::OlsonTZ::Data;

{ use 5.006; }
use warnings;
use strict;

use Carp qw(croak);
use File::Spec ();

our $VERSION = "0.201110";

use parent "Exporter";
our @EXPORT_OK = qw(
	olson_version
	olson_canonical_names olson_link_names olson_all_names
	olson_links
	olson_country_selection
	olson_tzfile
);

=head1 FUNCTIONS

=head2 Basic information

=over

=item olson_version

Returns the version number of the database that this module encapsulates.
Version numbers for the Olson database currently consist of a year number
and a lowercase letter, such as "C<2010k>"; they are not guaranteed to
retain this format in the future.

=cut

use constant olson_version => "2011j";

=back

=head2 Zone metadata

=over

=item olson_canonical_names

Returns the set of timezone names that this version of the database
defines as canonical.  These are the timezone names that are directly
associated with a set of observance data.  The return value is a reference
to a hash, in which the keys are the canonical timezone names and the
values are all C<undef>.

=cut

use constant olson_canonical_names => { map { ($_ => undef) } qw(
	Africa/Abidjan Africa/Accra Africa/Addis_Ababa Africa/Algiers
	Africa/Asmara Africa/Bamako Africa/Bangui Africa/Banjul Africa/Bissau
	Africa/Blantyre Africa/Brazzaville Africa/Bujumbura Africa/Cairo
	Africa/Casablanca Africa/Ceuta Africa/Conakry Africa/Dakar
	Africa/Dar_es_Salaam Africa/Djibouti Africa/Douala Africa/El_Aaiun
	Africa/Freetown Africa/Gaborone Africa/Harare Africa/Johannesburg
	Africa/Juba Africa/Kampala Africa/Khartoum Africa/Kigali Africa/Kinshasa
	Africa/Lagos Africa/Libreville Africa/Lome Africa/Luanda
	Africa/Lubumbashi Africa/Lusaka Africa/Malabo Africa/Maputo
	Africa/Maseru Africa/Mbabane Africa/Mogadishu Africa/Monrovia
	Africa/Nairobi Africa/Ndjamena Africa/Niamey Africa/Nouakchott
	Africa/Ouagadougou Africa/Porto-Novo Africa/Sao_Tome Africa/Tripoli
	Africa/Tunis Africa/Windhoek America/Adak America/Anchorage
	America/Anguilla America/Antigua America/Araguaina
	America/Argentina/Buenos_Aires America/Argentina/Catamarca
	America/Argentina/Cordoba America/Argentina/Jujuy
	America/Argentina/La_Rioja America/Argentina/Mendoza
	America/Argentina/Rio_Gallegos America/Argentina/Salta
	America/Argentina/San_Juan America/Argentina/San_Luis
	America/Argentina/Tucuman America/Argentina/Ushuaia America/Aruba
	America/Asuncion America/Atikokan America/Bahia America/Bahia_Banderas
	America/Barbados America/Belem America/Belize America/Blanc-Sablon
	America/Boa_Vista America/Bogota America/Boise America/Cambridge_Bay
	America/Campo_Grande America/Cancun America/Caracas America/Cayenne
	America/Cayman America/Chicago America/Chihuahua America/Costa_Rica
	America/Cuiaba America/Curacao America/Danmarkshavn America/Dawson
	America/Dawson_Creek America/Denver America/Detroit America/Dominica
	America/Edmonton America/Eirunepe America/El_Salvador America/Fortaleza
	America/Glace_Bay America/Godthab America/Goose_Bay America/Grand_Turk
	America/Grenada America/Guadeloupe America/Guatemala America/Guayaquil
	America/Guyana America/Halifax America/Havana America/Hermosillo
	America/Indiana/Indianapolis America/Indiana/Knox
	America/Indiana/Marengo America/Indiana/Petersburg
	America/Indiana/Tell_City America/Indiana/Vevay
	America/Indiana/Vincennes America/Indiana/Winamac America/Inuvik
	America/Iqaluit America/Jamaica America/Juneau
	America/Kentucky/Louisville America/Kentucky/Monticello America/La_Paz
	America/Lima America/Los_Angeles America/Maceio America/Managua
	America/Manaus America/Martinique America/Matamoros America/Mazatlan
	America/Menominee America/Merida America/Metlakatla America/Mexico_City
	America/Miquelon America/Moncton America/Monterrey America/Montevideo
	America/Montreal America/Montserrat America/Nassau America/New_York
	America/Nipigon America/Nome America/Noronha America/North_Dakota/Beulah
	America/North_Dakota/Center America/North_Dakota/New_Salem
	America/Ojinaga America/Panama America/Pangnirtung America/Paramaribo
	America/Phoenix America/Port-au-Prince America/Port_of_Spain
	America/Porto_Velho America/Puerto_Rico America/Rainy_River
	America/Rankin_Inlet America/Recife America/Regina America/Resolute
	America/Rio_Branco America/Santa_Isabel America/Santarem
	America/Santiago America/Santo_Domingo America/Sao_Paulo
	America/Scoresbysund America/Sitka America/St_Johns America/St_Kitts
	America/St_Lucia America/St_Thomas America/St_Vincent
	America/Swift_Current America/Tegucigalpa America/Thule
	America/Thunder_Bay America/Tijuana America/Toronto America/Tortola
	America/Vancouver America/Whitehorse America/Winnipeg America/Yakutat
	America/Yellowknife Antarctica/Casey Antarctica/Davis
	Antarctica/DumontDUrville Antarctica/Macquarie Antarctica/Mawson
	Antarctica/McMurdo Antarctica/Palmer Antarctica/Rothera Antarctica/Syowa
	Antarctica/Vostok Asia/Aden Asia/Almaty Asia/Amman Asia/Anadyr
	Asia/Aqtau Asia/Aqtobe Asia/Ashgabat Asia/Baghdad Asia/Bahrain Asia/Baku
	Asia/Bangkok Asia/Beirut Asia/Bishkek Asia/Brunei Asia/Choibalsan
	Asia/Chongqing Asia/Colombo Asia/Damascus Asia/Dhaka Asia/Dili
	Asia/Dubai Asia/Dushanbe Asia/Gaza Asia/Harbin Asia/Ho_Chi_Minh
	Asia/Hong_Kong Asia/Hovd Asia/Irkutsk Asia/Jakarta Asia/Jayapura
	Asia/Jerusalem Asia/Kabul Asia/Kamchatka Asia/Karachi Asia/Kashgar
	Asia/Kathmandu Asia/Kolkata Asia/Krasnoyarsk Asia/Kuala_Lumpur
	Asia/Kuching Asia/Kuwait Asia/Macau Asia/Magadan Asia/Makassar
	Asia/Manila Asia/Muscat Asia/Nicosia Asia/Novokuznetsk Asia/Novosibirsk
	Asia/Omsk Asia/Oral Asia/Phnom_Penh Asia/Pontianak Asia/Pyongyang
	Asia/Qatar Asia/Qyzylorda Asia/Rangoon Asia/Riyadh Asia/Riyadh87
	Asia/Riyadh88 Asia/Riyadh89 Asia/Sakhalin Asia/Samarkand Asia/Seoul
	Asia/Shanghai Asia/Singapore Asia/Taipei Asia/Tashkent Asia/Tbilisi
	Asia/Tehran Asia/Thimphu Asia/Tokyo Asia/Ulaanbaatar Asia/Urumqi
	Asia/Vientiane Asia/Vladivostok Asia/Yakutsk Asia/Yekaterinburg
	Asia/Yerevan Atlantic/Azores Atlantic/Bermuda Atlantic/Canary
	Atlantic/Cape_Verde Atlantic/Faroe Atlantic/Madeira Atlantic/Reykjavik
	Atlantic/South_Georgia Atlantic/St_Helena Atlantic/Stanley
	Australia/Adelaide Australia/Brisbane Australia/Broken_Hill
	Australia/Currie Australia/Darwin Australia/Eucla Australia/Hobart
	Australia/Lindeman Australia/Lord_Howe Australia/Melbourne
	Australia/Perth Australia/Sydney CET CST6CDT EET EST EST5EDT Etc/GMT
	Etc/GMT+1 Etc/GMT+10 Etc/GMT+11 Etc/GMT+12 Etc/GMT+2 Etc/GMT+3 Etc/GMT+4
	Etc/GMT+5 Etc/GMT+6 Etc/GMT+7 Etc/GMT+8 Etc/GMT+9 Etc/GMT-1 Etc/GMT-10
	Etc/GMT-11 Etc/GMT-12 Etc/GMT-13 Etc/GMT-14 Etc/GMT-2 Etc/GMT-3
	Etc/GMT-4 Etc/GMT-5 Etc/GMT-6 Etc/GMT-7 Etc/GMT-8 Etc/GMT-9 Etc/UCT
	Etc/UTC Europe/Amsterdam Europe/Andorra Europe/Athens Europe/Belgrade
	Europe/Berlin Europe/Brussels Europe/Bucharest Europe/Budapest
	Europe/Chisinau Europe/Copenhagen Europe/Dublin Europe/Gibraltar
	Europe/Helsinki Europe/Istanbul Europe/Kaliningrad Europe/Kiev
	Europe/Lisbon Europe/London Europe/Luxembourg Europe/Madrid Europe/Malta
	Europe/Minsk Europe/Monaco Europe/Moscow Europe/Oslo Europe/Paris
	Europe/Prague Europe/Riga Europe/Rome Europe/Samara Europe/Simferopol
	Europe/Sofia Europe/Stockholm Europe/Tallinn Europe/Tirane
	Europe/Uzhgorod Europe/Vaduz Europe/Vienna Europe/Vilnius
	Europe/Volgograd Europe/Warsaw Europe/Zaporozhye Europe/Zurich Factory
	HST Indian/Antananarivo Indian/Chagos Indian/Christmas Indian/Cocos
	Indian/Comoro Indian/Kerguelen Indian/Mahe Indian/Maldives
	Indian/Mauritius Indian/Mayotte Indian/Reunion MET MST MST7MDT PST8PDT
	Pacific/Apia Pacific/Auckland Pacific/Chatham Pacific/Chuuk
	Pacific/Easter Pacific/Efate Pacific/Enderbury Pacific/Fakaofo
	Pacific/Fiji Pacific/Funafuti Pacific/Galapagos Pacific/Gambier
	Pacific/Guadalcanal Pacific/Guam Pacific/Honolulu Pacific/Johnston
	Pacific/Kiritimati Pacific/Kosrae Pacific/Kwajalein Pacific/Majuro
	Pacific/Marquesas Pacific/Midway Pacific/Nauru Pacific/Niue
	Pacific/Norfolk Pacific/Noumea Pacific/Pago_Pago Pacific/Palau
	Pacific/Pitcairn Pacific/Pohnpei Pacific/Port_Moresby Pacific/Rarotonga
	Pacific/Saipan Pacific/Tahiti Pacific/Tarawa Pacific/Tongatapu
	Pacific/Wake Pacific/Wallis WET
) };

=item olson_link_names

Returns the set of timezone names that this version of the database
defines as links.  These are the timezone names that are aliases for
other names.  The return value is a reference to a hash, in which the
keys are the link timezone names and the values are all C<undef>.

=cut

sub olson_links();

my $link_names;
sub olson_link_names() {
	return $link_names ||= { map { ($_ => undef) } keys %{olson_links()} };
}

=item olson_all_names

Returns the set of timezone names that this version of the
database defines.  These are the L</olson_canonical_names> and the
L</olson_link_names>.  The return value is a reference to a hash, in
which the keys are the timezone names and the values are all C<undef>.

=cut

my $all_names;
sub olson_all_names() {
	return $all_names ||= {
		%{olson_canonical_names()},
		%{olson_link_names()},
	};
}

=item olson_links

Returns details of the timezone name links in this version of the
database.  Each link defines one timezone name as an alias for some
other timezone name.  The return value is a reference to a hash, in
which the keys are the aliases and each value is the canonical name of
the timezone to which that alias refers.  All such canonical names can
be found in the L</olson_canonical_names> hash.

=cut

use constant olson_links => {
	"Africa/Asmera" => "Africa/Asmara",
	"Africa/Timbuktu" => "Africa/Bamako",
	"America/Argentina/ComodRivadavia" => "America/Argentina/Catamarca",
	"America/Atka" => "America/Adak",
	"America/Buenos_Aires" => "America/Argentina/Buenos_Aires",
	"America/Catamarca" => "America/Argentina/Catamarca",
	"America/Coral_Harbour" => "America/Atikokan",
	"America/Cordoba" => "America/Argentina/Cordoba",
	"America/Ensenada" => "America/Tijuana",
	"America/Fort_Wayne" => "America/Indiana/Indianapolis",
	"America/Indianapolis" => "America/Indiana/Indianapolis",
	"America/Jujuy" => "America/Argentina/Jujuy",
	"America/Knox_IN" => "America/Indiana/Knox",
	"America/Kralendijk" => "America/Curacao",
	"America/Louisville" => "America/Kentucky/Louisville",
	"America/Lower_Princes" => "America/Curacao",
	"America/Marigot" => "America/Guadeloupe",
	"America/Mendoza" => "America/Argentina/Mendoza",
	"America/Porto_Acre" => "America/Rio_Branco",
	"America/Rosario" => "America/Argentina/Cordoba",
	"America/Shiprock" => "America/Denver",
	"America/St_Barthelemy" => "America/Guadeloupe",
	"America/Virgin" => "America/St_Thomas",
	"Antarctica/South_Pole" => "Antarctica/McMurdo",
	"Arctic/Longyearbyen" => "Europe/Oslo",
	"Asia/Ashkhabad" => "Asia/Ashgabat",
	"Asia/Calcutta" => "Asia/Kolkata",
	"Asia/Chungking" => "Asia/Chongqing",
	"Asia/Dacca" => "Asia/Dhaka",
	"Asia/Istanbul" => "Europe/Istanbul",
	"Asia/Katmandu" => "Asia/Kathmandu",
	"Asia/Macao" => "Asia/Macau",
	"Asia/Saigon" => "Asia/Ho_Chi_Minh",
	"Asia/Tel_Aviv" => "Asia/Jerusalem",
	"Asia/Thimbu" => "Asia/Thimphu",
	"Asia/Ujung_Pandang" => "Asia/Makassar",
	"Asia/Ulan_Bator" => "Asia/Ulaanbaatar",
	"Atlantic/Faeroe" => "Atlantic/Faroe",
	"Atlantic/Jan_Mayen" => "Europe/Oslo",
	"Australia/ACT" => "Australia/Sydney",
	"Australia/Canberra" => "Australia/Sydney",
	"Australia/LHI" => "Australia/Lord_Howe",
	"Australia/NSW" => "Australia/Sydney",
	"Australia/North" => "Australia/Darwin",
	"Australia/Queensland" => "Australia/Brisbane",
	"Australia/South" => "Australia/Adelaide",
	"Australia/Tasmania" => "Australia/Hobart",
	"Australia/Victoria" => "Australia/Melbourne",
	"Australia/West" => "Australia/Perth",
	"Australia/Yancowinna" => "Australia/Broken_Hill",
	"Brazil/Acre" => "America/Rio_Branco",
	"Brazil/DeNoronha" => "America/Noronha",
	"Brazil/East" => "America/Sao_Paulo",
	"Brazil/West" => "America/Manaus",
	"Canada/Atlantic" => "America/Halifax",
	"Canada/Central" => "America/Winnipeg",
	"Canada/East-Saskatchewan" => "America/Regina",
	"Canada/Eastern" => "America/Toronto",
	"Canada/Mountain" => "America/Edmonton",
	"Canada/Newfoundland" => "America/St_Johns",
	"Canada/Pacific" => "America/Vancouver",
	"Canada/Saskatchewan" => "America/Regina",
	"Canada/Yukon" => "America/Whitehorse",
	"Chile/Continental" => "America/Santiago",
	"Chile/EasterIsland" => "Pacific/Easter",
	Cuba => "America/Havana",
	Egypt => "Africa/Cairo",
	Eire => "Europe/Dublin",
	"Etc/GMT+0" => "Etc/GMT",
	"Etc/GMT-0" => "Etc/GMT",
	"Etc/GMT0" => "Etc/GMT",
	"Etc/Greenwich" => "Etc/GMT",
	"Etc/Universal" => "Etc/UTC",
	"Etc/Zulu" => "Etc/UTC",
	"Europe/Belfast" => "Europe/London",
	"Europe/Bratislava" => "Europe/Prague",
	"Europe/Guernsey" => "Europe/London",
	"Europe/Isle_of_Man" => "Europe/London",
	"Europe/Jersey" => "Europe/London",
	"Europe/Ljubljana" => "Europe/Belgrade",
	"Europe/Mariehamn" => "Europe/Helsinki",
	"Europe/Nicosia" => "Asia/Nicosia",
	"Europe/Podgorica" => "Europe/Belgrade",
	"Europe/San_Marino" => "Europe/Rome",
	"Europe/Sarajevo" => "Europe/Belgrade",
	"Europe/Skopje" => "Europe/Belgrade",
	"Europe/Tiraspol" => "Europe/Chisinau",
	"Europe/Vatican" => "Europe/Rome",
	"Europe/Zagreb" => "Europe/Belgrade",
	GB => "Europe/London",
	"GB-Eire" => "Europe/London",
	GMT => "Etc/GMT",
	"GMT+0" => "Etc/GMT",
	"GMT-0" => "Etc/GMT",
	GMT0 => "Etc/GMT",
	Greenwich => "Etc/GMT",
	Hongkong => "Asia/Hong_Kong",
	Iceland => "Atlantic/Reykjavik",
	Iran => "Asia/Tehran",
	Israel => "Asia/Jerusalem",
	Jamaica => "America/Jamaica",
	Japan => "Asia/Tokyo",
	Kwajalein => "Pacific/Kwajalein",
	Libya => "Africa/Tripoli",
	"Mexico/BajaNorte" => "America/Tijuana",
	"Mexico/BajaSur" => "America/Mazatlan",
	"Mexico/General" => "America/Mexico_City",
	"Mideast/Riyadh87" => "Asia/Riyadh87",
	"Mideast/Riyadh88" => "Asia/Riyadh88",
	"Mideast/Riyadh89" => "Asia/Riyadh89",
	NZ => "Pacific/Auckland",
	"NZ-CHAT" => "Pacific/Chatham",
	Navajo => "America/Denver",
	PRC => "Asia/Shanghai",
	"Pacific/Ponape" => "Pacific/Pohnpei",
	"Pacific/Samoa" => "Pacific/Pago_Pago",
	"Pacific/Truk" => "Pacific/Chuuk",
	"Pacific/Yap" => "Pacific/Chuuk",
	Poland => "Europe/Warsaw",
	Portugal => "Europe/Lisbon",
	ROC => "Asia/Taipei",
	ROK => "Asia/Seoul",
	Singapore => "Asia/Singapore",
	Turkey => "Europe/Istanbul",
	UCT => "Etc/UCT",
	"US/Alaska" => "America/Anchorage",
	"US/Aleutian" => "America/Adak",
	"US/Arizona" => "America/Phoenix",
	"US/Central" => "America/Chicago",
	"US/East-Indiana" => "America/Indiana/Indianapolis",
	"US/Eastern" => "America/New_York",
	"US/Hawaii" => "Pacific/Honolulu",
	"US/Indiana-Starke" => "America/Indiana/Knox",
	"US/Michigan" => "America/Detroit",
	"US/Mountain" => "America/Denver",
	"US/Pacific" => "America/Los_Angeles",
	"US/Pacific-New" => "America/Los_Angeles",
	"US/Samoa" => "Pacific/Pago_Pago",
	UTC => "Etc/UTC",
	Universal => "Etc/UTC",
	"W-SU" => "Europe/Moscow",
	Zulu => "Etc/UTC",
};

=item olson_country_selection

Returns information about how timezones relate to countries, intended
to aid humans in selecting a geographical timezone.  This information
is derived from the C<zone.tab> and C<iso3166.tab> files in the database
source.

The return value is a reference to a hash, keyed by (ISO 3166 alpha-2
uppercase) country code.  The value for each country is a hash containing
these values:

=over

=item B<alpha2_code>

The ISO 3166 alpha-2 uppercase country code.

=item B<olson_name>

An English name for the country, possibly in a modified form, optimised
to help humans find the right entry in alphabetical lists.  This is
not necessarily identical to the country's standard short or long name.
(For other forms of the name, consult a database of countries, keying
by the country code.)

=item B<regions>

Information about the regions of the country that use distinct
timezones.  This is a hash, keyed by English description of the region.
The description is empty if there is only one region.  The value for
each region is a hash containing these values:

=over

=item B<olson_description>

Brief English description of the region, used to distinguish between
the regions of a single country.  Empty string if the country has only
one region for timezone purposes.  (This is the same string used as the
key in the B<regions> hash.)

=item B<timezone_name>

Name of the Olson timezone used in this region.  This is not necessarily
a canonical name (it may be a link).  Typically, where there are aliases
or identical canonical zones, a name is chosen that refers to a location
in the country of interest.  It is guaranteed that the named timezone
exists in the database.

=item B<location_coords>

Geographical coordinates of some point within the location referred to in
the timezone name.  This is a latitude and longitude, in ISO 6709 format.

=back

=back

This data structure is intended to help a human select the appropriate
timezone based on political geography, specifically working from a
selection of country.  It is of essentially no use for any other purpose.
It is not strictly guaranteed that every geographical timezone in the
database is listed somewhere in this structure, so it is of limited use
in providing information about an already-selected timezone.  It does
not include non-geographic timezones at all.  It also does not claim
to be a comprehensive list of countries, and does not make any claims
regarding the political status of any entity listed: the "country"
classification is loose, and used only for identification purposes.

=cut

use constant olson_country_selection => {
	AD => {
		alpha2_code => "AD",
		olson_name => "Andorra",
		regions => {
			"" => {
				location_coords => "+4230+00131",
				olson_description => "",
				timezone_name => "Europe/Andorra",
			},
		},
	},
	AE => {
		alpha2_code => "AE",
		olson_name => "United Arab Emirates",
		regions => {
			"" => {
				location_coords => "+2518+05518",
				olson_description => "",
				timezone_name => "Asia/Dubai",
			},
		},
	},
	AF => {
		alpha2_code => "AF",
		olson_name => "Afghanistan",
		regions => {
			"" => {
				location_coords => "+3431+06912",
				olson_description => "",
				timezone_name => "Asia/Kabul",
			},
		},
	},
	AG => {
		alpha2_code => "AG",
		olson_name => "Antigua & Barbuda",
		regions => {
			"" => {
				location_coords => "+1703-06148",
				olson_description => "",
				timezone_name => "America/Antigua",
			},
		},
	},
	AI => {
		alpha2_code => "AI",
		olson_name => "Anguilla",
		regions => {
			"" => {
				location_coords => "+1812-06304",
				olson_description => "",
				timezone_name => "America/Anguilla",
			},
		},
	},
	AL => {
		alpha2_code => "AL",
		olson_name => "Albania",
		regions => {
			"" => {
				location_coords => "+4120+01950",
				olson_description => "",
				timezone_name => "Europe/Tirane",
			},
		},
	},
	AM => {
		alpha2_code => "AM",
		olson_name => "Armenia",
		regions => {
			"" => {
				location_coords => "+4011+04430",
				olson_description => "",
				timezone_name => "Asia/Yerevan",
			},
		},
	},
	AO => {
		alpha2_code => "AO",
		olson_name => "Angola",
		regions => {
			"" => {
				location_coords => "-0848+01314",
				olson_description => "",
				timezone_name => "Africa/Luanda",
			},
		},
	},
	AQ => {
		alpha2_code => "AQ",
		olson_name => "Antarctica",
		regions => {
			"Amundsen-Scott Station, South Pole" => {
				location_coords => "-9000+00000",
				olson_description => "Amundsen-Scott Station, South Pole",
				timezone_name => "Antarctica/South_Pole",
			},
			"Casey Station, Bailey Peninsula" => {
				location_coords => "-6617+11031",
				olson_description => "Casey Station, Bailey Peninsula",
				timezone_name => "Antarctica/Casey",
			},
			"Davis Station, Vestfold Hills" => {
				location_coords => "-6835+07758",
				olson_description => "Davis Station, Vestfold Hills",
				timezone_name => "Antarctica/Davis",
			},
			"Dumont-d'Urville Station, Terre Adelie" => {
				location_coords => "-6640+14001",
				olson_description => "Dumont-d'Urville Station, Terre Adelie",
				timezone_name => "Antarctica/DumontDUrville",
			},
			"Macquarie Island Station, Macquarie Island" => {
				location_coords => "-5430+15857",
				olson_description => "Macquarie Island Station, Macquarie Island",
				timezone_name => "Antarctica/Macquarie",
			},
			"Mawson Station, Holme Bay" => {
				location_coords => "-6736+06253",
				olson_description => "Mawson Station, Holme Bay",
				timezone_name => "Antarctica/Mawson",
			},
			"McMurdo Station, Ross Island" => {
				location_coords => "-7750+16636",
				olson_description => "McMurdo Station, Ross Island",
				timezone_name => "Antarctica/McMurdo",
			},
			"Palmer Station, Anvers Island" => {
				location_coords => "-6448-06406",
				olson_description => "Palmer Station, Anvers Island",
				timezone_name => "Antarctica/Palmer",
			},
			"Rothera Station, Adelaide Island" => {
				location_coords => "-6734-06808",
				olson_description => "Rothera Station, Adelaide Island",
				timezone_name => "Antarctica/Rothera",
			},
			"Syowa Station, E Ongul I" => {
				location_coords => "-690022+0393524",
				olson_description => "Syowa Station, E Ongul I",
				timezone_name => "Antarctica/Syowa",
			},
			"Vostok Station, Lake Vostok" => {
				location_coords => "-7824+10654",
				olson_description => "Vostok Station, Lake Vostok",
				timezone_name => "Antarctica/Vostok",
			},
		},
	},
	AR => {
		alpha2_code => "AR",
		olson_name => "Argentina",
		regions => {
			"(SA, LP, NQ, RN)" => {
				location_coords => "-2447-06525",
				olson_description => "(SA, LP, NQ, RN)",
				timezone_name => "America/Argentina/Salta",
			},
			"Buenos Aires (BA, CF)" => {
				location_coords => "-3436-05827",
				olson_description => "Buenos Aires (BA, CF)",
				timezone_name => "America/Argentina/Buenos_Aires",
			},
			"Catamarca (CT), Chubut (CH)" => {
				location_coords => "-2828-06547",
				olson_description => "Catamarca (CT), Chubut (CH)",
				timezone_name => "America/Argentina/Catamarca",
			},
			"Jujuy (JY)" => {
				location_coords => "-2411-06518",
				olson_description => "Jujuy (JY)",
				timezone_name => "America/Argentina/Jujuy",
			},
			"La Rioja (LR)" => {
				location_coords => "-2926-06651",
				olson_description => "La Rioja (LR)",
				timezone_name => "America/Argentina/La_Rioja",
			},
			"Mendoza (MZ)" => {
				location_coords => "-3253-06849",
				olson_description => "Mendoza (MZ)",
				timezone_name => "America/Argentina/Mendoza",
			},
			"San Juan (SJ)" => {
				location_coords => "-3132-06831",
				olson_description => "San Juan (SJ)",
				timezone_name => "America/Argentina/San_Juan",
			},
			"San Luis (SL)" => {
				location_coords => "-3319-06621",
				olson_description => "San Luis (SL)",
				timezone_name => "America/Argentina/San_Luis",
			},
			"Santa Cruz (SC)" => {
				location_coords => "-5138-06913",
				olson_description => "Santa Cruz (SC)",
				timezone_name => "America/Argentina/Rio_Gallegos",
			},
			"Tierra del Fuego (TF)" => {
				location_coords => "-5448-06818",
				olson_description => "Tierra del Fuego (TF)",
				timezone_name => "America/Argentina/Ushuaia",
			},
			"Tucuman (TM)" => {
				location_coords => "-2649-06513",
				olson_description => "Tucuman (TM)",
				timezone_name => "America/Argentina/Tucuman",
			},
			"most locations (CB, CC, CN, ER, FM, MN, SE, SF)" => {
				location_coords => "-3124-06411",
				olson_description => "most locations (CB, CC, CN, ER, FM, MN, SE, SF)",
				timezone_name => "America/Argentina/Cordoba",
			},
		},
	},
	AS => {
		alpha2_code => "AS",
		olson_name => "Samoa (American)",
		regions => {
			"" => {
				location_coords => "-1416-17042",
				olson_description => "",
				timezone_name => "Pacific/Pago_Pago",
			},
		},
	},
	AT => {
		alpha2_code => "AT",
		olson_name => "Austria",
		regions => {
			"" => {
				location_coords => "+4813+01620",
				olson_description => "",
				timezone_name => "Europe/Vienna",
			},
		},
	},
	AU => {
		alpha2_code => "AU",
		olson_name => "Australia",
		regions => {
			"Lord Howe Island" => {
				location_coords => "-3133+15905",
				olson_description => "Lord Howe Island",
				timezone_name => "Australia/Lord_Howe",
			},
			"New South Wales - Yancowinna" => {
				location_coords => "-3157+14127",
				olson_description => "New South Wales - Yancowinna",
				timezone_name => "Australia/Broken_Hill",
			},
			"New South Wales - most locations" => {
				location_coords => "-3352+15113",
				olson_description => "New South Wales - most locations",
				timezone_name => "Australia/Sydney",
			},
			"Northern Territory" => {
				location_coords => "-1228+13050",
				olson_description => "Northern Territory",
				timezone_name => "Australia/Darwin",
			},
			"Queensland - Holiday Islands" => {
				location_coords => "-2016+14900",
				olson_description => "Queensland - Holiday Islands",
				timezone_name => "Australia/Lindeman",
			},
			"Queensland - most locations" => {
				location_coords => "-2728+15302",
				olson_description => "Queensland - most locations",
				timezone_name => "Australia/Brisbane",
			},
			"South Australia" => {
				location_coords => "-3455+13835",
				olson_description => "South Australia",
				timezone_name => "Australia/Adelaide",
			},
			"Tasmania - King Island" => {
				location_coords => "-3956+14352",
				olson_description => "Tasmania - King Island",
				timezone_name => "Australia/Currie",
			},
			"Tasmania - most locations" => {
				location_coords => "-4253+14719",
				olson_description => "Tasmania - most locations",
				timezone_name => "Australia/Hobart",
			},
			Victoria => {
				location_coords => "-3749+14458",
				olson_description => "Victoria",
				timezone_name => "Australia/Melbourne",
			},
			"Western Australia - Eucla area" => {
				location_coords => "-3143+12852",
				olson_description => "Western Australia - Eucla area",
				timezone_name => "Australia/Eucla",
			},
			"Western Australia - most locations" => {
				location_coords => "-3157+11551",
				olson_description => "Western Australia - most locations",
				timezone_name => "Australia/Perth",
			},
		},
	},
	AW => {
		alpha2_code => "AW",
		olson_name => "Aruba",
		regions => {
			"" => {
				location_coords => "+1230-06958",
				olson_description => "",
				timezone_name => "America/Aruba",
			},
		},
	},
	AX => {
		alpha2_code => "AX",
		olson_name => "Aaland Islands",
		regions => {
			"" => {
				location_coords => "+6006+01957",
				olson_description => "",
				timezone_name => "Europe/Mariehamn",
			},
		},
	},
	AZ => {
		alpha2_code => "AZ",
		olson_name => "Azerbaijan",
		regions => {
			"" => {
				location_coords => "+4023+04951",
				olson_description => "",
				timezone_name => "Asia/Baku",
			},
		},
	},
	BA => {
		alpha2_code => "BA",
		olson_name => "Bosnia & Herzegovina",
		regions => {
			"" => {
				location_coords => "+4352+01825",
				olson_description => "",
				timezone_name => "Europe/Sarajevo",
			},
		},
	},
	BB => {
		alpha2_code => "BB",
		olson_name => "Barbados",
		regions => {
			"" => {
				location_coords => "+1306-05937",
				olson_description => "",
				timezone_name => "America/Barbados",
			},
		},
	},
	BD => {
		alpha2_code => "BD",
		olson_name => "Bangladesh",
		regions => {
			"" => {
				location_coords => "+2343+09025",
				olson_description => "",
				timezone_name => "Asia/Dhaka",
			},
		},
	},
	BE => {
		alpha2_code => "BE",
		olson_name => "Belgium",
		regions => {
			"" => {
				location_coords => "+5050+00420",
				olson_description => "",
				timezone_name => "Europe/Brussels",
			},
		},
	},
	BF => {
		alpha2_code => "BF",
		olson_name => "Burkina Faso",
		regions => {
			"" => {
				location_coords => "+1222-00131",
				olson_description => "",
				timezone_name => "Africa/Ouagadougou",
			},
		},
	},
	BG => {
		alpha2_code => "BG",
		olson_name => "Bulgaria",
		regions => {
			"" => {
				location_coords => "+4241+02319",
				olson_description => "",
				timezone_name => "Europe/Sofia",
			},
		},
	},
	BH => {
		alpha2_code => "BH",
		olson_name => "Bahrain",
		regions => {
			"" => {
				location_coords => "+2623+05035",
				olson_description => "",
				timezone_name => "Asia/Bahrain",
			},
		},
	},
	BI => {
		alpha2_code => "BI",
		olson_name => "Burundi",
		regions => {
			"" => {
				location_coords => "-0323+02922",
				olson_description => "",
				timezone_name => "Africa/Bujumbura",
			},
		},
	},
	BJ => {
		alpha2_code => "BJ",
		olson_name => "Benin",
		regions => {
			"" => {
				location_coords => "+0629+00237",
				olson_description => "",
				timezone_name => "Africa/Porto-Novo",
			},
		},
	},
	BL => {
		alpha2_code => "BL",
		olson_name => "St Barthelemy",
		regions => {
			"" => {
				location_coords => "+1753-06251",
				olson_description => "",
				timezone_name => "America/St_Barthelemy",
			},
		},
	},
	BM => {
		alpha2_code => "BM",
		olson_name => "Bermuda",
		regions => {
			"" => {
				location_coords => "+3217-06446",
				olson_description => "",
				timezone_name => "Atlantic/Bermuda",
			},
		},
	},
	BN => {
		alpha2_code => "BN",
		olson_name => "Brunei",
		regions => {
			"" => {
				location_coords => "+0456+11455",
				olson_description => "",
				timezone_name => "Asia/Brunei",
			},
		},
	},
	BO => {
		alpha2_code => "BO",
		olson_name => "Bolivia",
		regions => {
			"" => {
				location_coords => "-1630-06809",
				olson_description => "",
				timezone_name => "America/La_Paz",
			},
		},
	},
	BQ => {
		alpha2_code => "BQ",
		olson_name => "Bonaire Sint Eustatius & Saba",
		regions => {
			"" => {
				location_coords => "+120903-0681636",
				olson_description => "",
				timezone_name => "America/Kralendijk",
			},
		},
	},
	BR => {
		alpha2_code => "BR",
		olson_name => "Brazil",
		regions => {
			Acre => {
				location_coords => "-0958-06748",
				olson_description => "Acre",
				timezone_name => "America/Rio_Branco",
			},
			"Alagoas, Sergipe" => {
				location_coords => "-0940-03543",
				olson_description => "Alagoas, Sergipe",
				timezone_name => "America/Maceio",
			},
			"Amapa, E Para" => {
				location_coords => "-0127-04829",
				olson_description => "Amapa, E Para",
				timezone_name => "America/Belem",
			},
			"Atlantic islands" => {
				location_coords => "-0351-03225",
				olson_description => "Atlantic islands",
				timezone_name => "America/Noronha",
			},
			Bahia => {
				location_coords => "-1259-03831",
				olson_description => "Bahia",
				timezone_name => "America/Bahia",
			},
			"E Amazonas" => {
				location_coords => "-0308-06001",
				olson_description => "E Amazonas",
				timezone_name => "America/Manaus",
			},
			"Mato Grosso" => {
				location_coords => "-1535-05605",
				olson_description => "Mato Grosso",
				timezone_name => "America/Cuiaba",
			},
			"Mato Grosso do Sul" => {
				location_coords => "-2027-05437",
				olson_description => "Mato Grosso do Sul",
				timezone_name => "America/Campo_Grande",
			},
			"NE Brazil (MA, PI, CE, RN, PB)" => {
				location_coords => "-0343-03830",
				olson_description => "NE Brazil (MA, PI, CE, RN, PB)",
				timezone_name => "America/Fortaleza",
			},
			Pernambuco => {
				location_coords => "-0803-03454",
				olson_description => "Pernambuco",
				timezone_name => "America/Recife",
			},
			Rondonia => {
				location_coords => "-0846-06354",
				olson_description => "Rondonia",
				timezone_name => "America/Porto_Velho",
			},
			Roraima => {
				location_coords => "+0249-06040",
				olson_description => "Roraima",
				timezone_name => "America/Boa_Vista",
			},
			"S & SE Brazil (GO, DF, MG, ES, RJ, SP, PR, SC, RS)" => {
				location_coords => "-2332-04637",
				olson_description => "S & SE Brazil (GO, DF, MG, ES, RJ, SP, PR, SC, RS)",
				timezone_name => "America/Sao_Paulo",
			},
			Tocantins => {
				location_coords => "-0712-04812",
				olson_description => "Tocantins",
				timezone_name => "America/Araguaina",
			},
			"W Amazonas" => {
				location_coords => "-0640-06952",
				olson_description => "W Amazonas",
				timezone_name => "America/Eirunepe",
			},
			"W Para" => {
				location_coords => "-0226-05452",
				olson_description => "W Para",
				timezone_name => "America/Santarem",
			},
		},
	},
	BS => {
		alpha2_code => "BS",
		olson_name => "Bahamas",
		regions => {
			"" => {
				location_coords => "+2505-07721",
				olson_description => "",
				timezone_name => "America/Nassau",
			},
		},
	},
	BT => {
		alpha2_code => "BT",
		olson_name => "Bhutan",
		regions => {
			"" => {
				location_coords => "+2728+08939",
				olson_description => "",
				timezone_name => "Asia/Thimphu",
			},
		},
	},
	BW => {
		alpha2_code => "BW",
		olson_name => "Botswana",
		regions => {
			"" => {
				location_coords => "-2439+02555",
				olson_description => "",
				timezone_name => "Africa/Gaborone",
			},
		},
	},
	BY => {
		alpha2_code => "BY",
		olson_name => "Belarus",
		regions => {
			"" => {
				location_coords => "+5354+02734",
				olson_description => "",
				timezone_name => "Europe/Minsk",
			},
		},
	},
	BZ => {
		alpha2_code => "BZ",
		olson_name => "Belize",
		regions => {
			"" => {
				location_coords => "+1730-08812",
				olson_description => "",
				timezone_name => "America/Belize",
			},
		},
	},
	CA => {
		alpha2_code => "CA",
		olson_name => "Canada",
		regions => {
			"Atlantic Standard Time - Quebec - Lower North Shore" => {
				location_coords => "+5125-05707",
				olson_description => "Atlantic Standard Time - Quebec - Lower North Shore",
				timezone_name => "America/Blanc-Sablon",
			},
			"Atlantic Time - Labrador - most locations" => {
				location_coords => "+5320-06025",
				olson_description => "Atlantic Time - Labrador - most locations",
				timezone_name => "America/Goose_Bay",
			},
			"Atlantic Time - New Brunswick" => {
				location_coords => "+4606-06447",
				olson_description => "Atlantic Time - New Brunswick",
				timezone_name => "America/Moncton",
			},
			"Atlantic Time - Nova Scotia (most places), PEI" => {
				location_coords => "+4439-06336",
				olson_description => "Atlantic Time - Nova Scotia (most places), PEI",
				timezone_name => "America/Halifax",
			},
			"Atlantic Time - Nova Scotia - places that did not observe DST 1966-1971" => {
				location_coords => "+4612-05957",
				olson_description => "Atlantic Time - Nova Scotia - places that did not observe DST 1966-1971",
				timezone_name => "America/Glace_Bay",
			},
			"Central Standard Time - Resolute, Nunavut" => {
				location_coords => "+744144-0944945",
				olson_description => "Central Standard Time - Resolute, Nunavut",
				timezone_name => "America/Resolute",
			},
			"Central Standard Time - Saskatchewan - midwest" => {
				location_coords => "+5017-10750",
				olson_description => "Central Standard Time - Saskatchewan - midwest",
				timezone_name => "America/Swift_Current",
			},
			"Central Standard Time - Saskatchewan - most locations" => {
				location_coords => "+5024-10439",
				olson_description => "Central Standard Time - Saskatchewan - most locations",
				timezone_name => "America/Regina",
			},
			"Central Time - Manitoba & west Ontario" => {
				location_coords => "+4953-09709",
				olson_description => "Central Time - Manitoba & west Ontario",
				timezone_name => "America/Winnipeg",
			},
			"Central Time - Rainy River & Fort Frances, Ontario" => {
				location_coords => "+4843-09434",
				olson_description => "Central Time - Rainy River & Fort Frances, Ontario",
				timezone_name => "America/Rainy_River",
			},
			"Central Time - central Nunavut" => {
				location_coords => "+624900-0920459",
				olson_description => "Central Time - central Nunavut",
				timezone_name => "America/Rankin_Inlet",
			},
			"Eastern Standard Time - Atikokan, Ontario and Southampton I, Nunavut" => {
				location_coords => "+484531-0913718",
				olson_description => "Eastern Standard Time - Atikokan, Ontario and Southampton I, Nunavut",
				timezone_name => "America/Atikokan",
			},
			"Eastern Time - Ontario & Quebec - places that did not observe DST 1967-1973" => {
				location_coords => "+4901-08816",
				olson_description => "Eastern Time - Ontario & Quebec - places that did not observe DST 1967-1973",
				timezone_name => "America/Nipigon",
			},
			"Eastern Time - Ontario - most locations" => {
				location_coords => "+4339-07923",
				olson_description => "Eastern Time - Ontario - most locations",
				timezone_name => "America/Toronto",
			},
			"Eastern Time - Pangnirtung, Nunavut" => {
				location_coords => "+6608-06544",
				olson_description => "Eastern Time - Pangnirtung, Nunavut",
				timezone_name => "America/Pangnirtung",
			},
			"Eastern Time - Quebec - most locations" => {
				location_coords => "+4531-07334",
				olson_description => "Eastern Time - Quebec - most locations",
				timezone_name => "America/Montreal",
			},
			"Eastern Time - Thunder Bay, Ontario" => {
				location_coords => "+4823-08915",
				olson_description => "Eastern Time - Thunder Bay, Ontario",
				timezone_name => "America/Thunder_Bay",
			},
			"Eastern Time - east Nunavut - most locations" => {
				location_coords => "+6344-06828",
				olson_description => "Eastern Time - east Nunavut - most locations",
				timezone_name => "America/Iqaluit",
			},
			"Mountain Standard Time - Dawson Creek & Fort Saint John, British Columbia" => {
				location_coords => "+5946-12014",
				olson_description => "Mountain Standard Time - Dawson Creek & Fort Saint John, British Columbia",
				timezone_name => "America/Dawson_Creek",
			},
			"Mountain Time - Alberta, east British Columbia & west Saskatchewan" => {
				location_coords => "+5333-11328",
				olson_description => "Mountain Time - Alberta, east British Columbia & west Saskatchewan",
				timezone_name => "America/Edmonton",
			},
			"Mountain Time - central Northwest Territories" => {
				location_coords => "+6227-11421",
				olson_description => "Mountain Time - central Northwest Territories",
				timezone_name => "America/Yellowknife",
			},
			"Mountain Time - west Northwest Territories" => {
				location_coords => "+682059-1334300",
				olson_description => "Mountain Time - west Northwest Territories",
				timezone_name => "America/Inuvik",
			},
			"Mountain Time - west Nunavut" => {
				location_coords => "+690650-1050310",
				olson_description => "Mountain Time - west Nunavut",
				timezone_name => "America/Cambridge_Bay",
			},
			"Newfoundland Time, including SE Labrador" => {
				location_coords => "+4734-05243",
				olson_description => "Newfoundland Time, including SE Labrador",
				timezone_name => "America/St_Johns",
			},
			"Pacific Time - north Yukon" => {
				location_coords => "+6404-13925",
				olson_description => "Pacific Time - north Yukon",
				timezone_name => "America/Dawson",
			},
			"Pacific Time - south Yukon" => {
				location_coords => "+6043-13503",
				olson_description => "Pacific Time - south Yukon",
				timezone_name => "America/Whitehorse",
			},
			"Pacific Time - west British Columbia" => {
				location_coords => "+4916-12307",
				olson_description => "Pacific Time - west British Columbia",
				timezone_name => "America/Vancouver",
			},
		},
	},
	CC => {
		alpha2_code => "CC",
		olson_name => "Cocos (Keeling) Islands",
		regions => {
			"" => {
				location_coords => "-1210+09655",
				olson_description => "",
				timezone_name => "Indian/Cocos",
			},
		},
	},
	CD => {
		alpha2_code => "CD",
		olson_name => "Congo (Dem. Rep.)",
		regions => {
			"east Dem. Rep. of Congo" => {
				location_coords => "-1140+02728",
				olson_description => "east Dem. Rep. of Congo",
				timezone_name => "Africa/Lubumbashi",
			},
			"west Dem. Rep. of Congo" => {
				location_coords => "-0418+01518",
				olson_description => "west Dem. Rep. of Congo",
				timezone_name => "Africa/Kinshasa",
			},
		},
	},
	CF => {
		alpha2_code => "CF",
		olson_name => "Central African Rep.",
		regions => {
			"" => {
				location_coords => "+0422+01835",
				olson_description => "",
				timezone_name => "Africa/Bangui",
			},
		},
	},
	CG => {
		alpha2_code => "CG",
		olson_name => "Congo (Rep.)",
		regions => {
			"" => {
				location_coords => "-0416+01517",
				olson_description => "",
				timezone_name => "Africa/Brazzaville",
			},
		},
	},
	CH => {
		alpha2_code => "CH",
		olson_name => "Switzerland",
		regions => {
			"" => {
				location_coords => "+4723+00832",
				olson_description => "",
				timezone_name => "Europe/Zurich",
			},
		},
	},
	CI => {
		alpha2_code => "CI",
		olson_name => "Cote d'Ivoire",
		regions => {
			"" => {
				location_coords => "+0519-00402",
				olson_description => "",
				timezone_name => "Africa/Abidjan",
			},
		},
	},
	CK => {
		alpha2_code => "CK",
		olson_name => "Cook Islands",
		regions => {
			"" => {
				location_coords => "-2114-15946",
				olson_description => "",
				timezone_name => "Pacific/Rarotonga",
			},
		},
	},
	CL => {
		alpha2_code => "CL",
		olson_name => "Chile",
		regions => {
			"Easter Island & Sala y Gomez" => {
				location_coords => "-2709-10926",
				olson_description => "Easter Island & Sala y Gomez",
				timezone_name => "Pacific/Easter",
			},
			"most locations" => {
				location_coords => "-3327-07040",
				olson_description => "most locations",
				timezone_name => "America/Santiago",
			},
		},
	},
	CM => {
		alpha2_code => "CM",
		olson_name => "Cameroon",
		regions => {
			"" => {
				location_coords => "+0403+00942",
				olson_description => "",
				timezone_name => "Africa/Douala",
			},
		},
	},
	CN => {
		alpha2_code => "CN",
		olson_name => "China",
		regions => {
			"Heilongjiang (except Mohe), Jilin" => {
				location_coords => "+4545+12641",
				olson_description => "Heilongjiang (except Mohe), Jilin",
				timezone_name => "Asia/Harbin",
			},
			"central China - Sichuan, Yunnan, Guangxi, Shaanxi, Guizhou, etc." => {
				location_coords => "+2934+10635",
				olson_description => "central China - Sichuan, Yunnan, Guangxi, Shaanxi, Guizhou, etc.",
				timezone_name => "Asia/Chongqing",
			},
			"east China - Beijing, Guangdong, Shanghai, etc." => {
				location_coords => "+3114+12128",
				olson_description => "east China - Beijing, Guangdong, Shanghai, etc.",
				timezone_name => "Asia/Shanghai",
			},
			"most of Tibet & Xinjiang" => {
				location_coords => "+4348+08735",
				olson_description => "most of Tibet & Xinjiang",
				timezone_name => "Asia/Urumqi",
			},
			"west Tibet & Xinjiang" => {
				location_coords => "+3929+07559",
				olson_description => "west Tibet & Xinjiang",
				timezone_name => "Asia/Kashgar",
			},
		},
	},
	CO => {
		alpha2_code => "CO",
		olson_name => "Colombia",
		regions => {
			"" => {
				location_coords => "+0436-07405",
				olson_description => "",
				timezone_name => "America/Bogota",
			},
		},
	},
	CR => {
		alpha2_code => "CR",
		olson_name => "Costa Rica",
		regions => {
			"" => {
				location_coords => "+0956-08405",
				olson_description => "",
				timezone_name => "America/Costa_Rica",
			},
		},
	},
	CU => {
		alpha2_code => "CU",
		olson_name => "Cuba",
		regions => {
			"" => {
				location_coords => "+2308-08222",
				olson_description => "",
				timezone_name => "America/Havana",
			},
		},
	},
	CV => {
		alpha2_code => "CV",
		olson_name => "Cape Verde",
		regions => {
			"" => {
				location_coords => "+1455-02331",
				olson_description => "",
				timezone_name => "Atlantic/Cape_Verde",
			},
		},
	},
	CW => {
		alpha2_code => "CW",
		olson_name => "Curacao",
		regions => {
			"" => {
				location_coords => "+1211-06900",
				olson_description => "",
				timezone_name => "America/Curacao",
			},
		},
	},
	CX => {
		alpha2_code => "CX",
		olson_name => "Christmas Island",
		regions => {
			"" => {
				location_coords => "-1025+10543",
				olson_description => "",
				timezone_name => "Indian/Christmas",
			},
		},
	},
	CY => {
		alpha2_code => "CY",
		olson_name => "Cyprus",
		regions => {
			"" => {
				location_coords => "+3510+03322",
				olson_description => "",
				timezone_name => "Asia/Nicosia",
			},
		},
	},
	CZ => {
		alpha2_code => "CZ",
		olson_name => "Czech Republic",
		regions => {
			"" => {
				location_coords => "+5005+01426",
				olson_description => "",
				timezone_name => "Europe/Prague",
			},
		},
	},
	DE => {
		alpha2_code => "DE",
		olson_name => "Germany",
		regions => {
			"" => {
				location_coords => "+5230+01322",
				olson_description => "",
				timezone_name => "Europe/Berlin",
			},
		},
	},
	DJ => {
		alpha2_code => "DJ",
		olson_name => "Djibouti",
		regions => {
			"" => {
				location_coords => "+1136+04309",
				olson_description => "",
				timezone_name => "Africa/Djibouti",
			},
		},
	},
	DK => {
		alpha2_code => "DK",
		olson_name => "Denmark",
		regions => {
			"" => {
				location_coords => "+5540+01235",
				olson_description => "",
				timezone_name => "Europe/Copenhagen",
			},
		},
	},
	DM => {
		alpha2_code => "DM",
		olson_name => "Dominica",
		regions => {
			"" => {
				location_coords => "+1518-06124",
				olson_description => "",
				timezone_name => "America/Dominica",
			},
		},
	},
	DO => {
		alpha2_code => "DO",
		olson_name => "Dominican Republic",
		regions => {
			"" => {
				location_coords => "+1828-06954",
				olson_description => "",
				timezone_name => "America/Santo_Domingo",
			},
		},
	},
	DZ => {
		alpha2_code => "DZ",
		olson_name => "Algeria",
		regions => {
			"" => {
				location_coords => "+3647+00303",
				olson_description => "",
				timezone_name => "Africa/Algiers",
			},
		},
	},
	EC => {
		alpha2_code => "EC",
		olson_name => "Ecuador",
		regions => {
			"Galapagos Islands" => {
				location_coords => "-0054-08936",
				olson_description => "Galapagos Islands",
				timezone_name => "Pacific/Galapagos",
			},
			mainland => {
				location_coords => "-0210-07950",
				olson_description => "mainland",
				timezone_name => "America/Guayaquil",
			},
		},
	},
	EE => {
		alpha2_code => "EE",
		olson_name => "Estonia",
		regions => {
			"" => {
				location_coords => "+5925+02445",
				olson_description => "",
				timezone_name => "Europe/Tallinn",
			},
		},
	},
	EG => {
		alpha2_code => "EG",
		olson_name => "Egypt",
		regions => {
			"" => {
				location_coords => "+3003+03115",
				olson_description => "",
				timezone_name => "Africa/Cairo",
			},
		},
	},
	EH => {
		alpha2_code => "EH",
		olson_name => "Western Sahara",
		regions => {
			"" => {
				location_coords => "+2709-01312",
				olson_description => "",
				timezone_name => "Africa/El_Aaiun",
			},
		},
	},
	ER => {
		alpha2_code => "ER",
		olson_name => "Eritrea",
		regions => {
			"" => {
				location_coords => "+1520+03853",
				olson_description => "",
				timezone_name => "Africa/Asmara",
			},
		},
	},
	ES => {
		alpha2_code => "ES",
		olson_name => "Spain",
		regions => {
			"Canary Islands" => {
				location_coords => "+2806-01524",
				olson_description => "Canary Islands",
				timezone_name => "Atlantic/Canary",
			},
			"Ceuta & Melilla" => {
				location_coords => "+3553-00519",
				olson_description => "Ceuta & Melilla",
				timezone_name => "Africa/Ceuta",
			},
			mainland => {
				location_coords => "+4024-00341",
				olson_description => "mainland",
				timezone_name => "Europe/Madrid",
			},
		},
	},
	ET => {
		alpha2_code => "ET",
		olson_name => "Ethiopia",
		regions => {
			"" => {
				location_coords => "+0902+03842",
				olson_description => "",
				timezone_name => "Africa/Addis_Ababa",
			},
		},
	},
	FI => {
		alpha2_code => "FI",
		olson_name => "Finland",
		regions => {
			"" => {
				location_coords => "+6010+02458",
				olson_description => "",
				timezone_name => "Europe/Helsinki",
			},
		},
	},
	FJ => {
		alpha2_code => "FJ",
		olson_name => "Fiji",
		regions => {
			"" => {
				location_coords => "-1808+17825",
				olson_description => "",
				timezone_name => "Pacific/Fiji",
			},
		},
	},
	FK => {
		alpha2_code => "FK",
		olson_name => "Falkland Islands",
		regions => {
			"" => {
				location_coords => "-5142-05751",
				olson_description => "",
				timezone_name => "Atlantic/Stanley",
			},
		},
	},
	FM => {
		alpha2_code => "FM",
		olson_name => "Micronesia",
		regions => {
			"Chuuk (Truk) and Yap" => {
				location_coords => "+0725+15147",
				olson_description => "Chuuk (Truk) and Yap",
				timezone_name => "Pacific/Chuuk",
			},
			Kosrae => {
				location_coords => "+0519+16259",
				olson_description => "Kosrae",
				timezone_name => "Pacific/Kosrae",
			},
			"Pohnpei (Ponape)" => {
				location_coords => "+0658+15813",
				olson_description => "Pohnpei (Ponape)",
				timezone_name => "Pacific/Pohnpei",
			},
		},
	},
	FO => {
		alpha2_code => "FO",
		olson_name => "Faroe Islands",
		regions => {
			"" => {
				location_coords => "+6201-00646",
				olson_description => "",
				timezone_name => "Atlantic/Faroe",
			},
		},
	},
	FR => {
		alpha2_code => "FR",
		olson_name => "France",
		regions => {
			"" => {
				location_coords => "+4852+00220",
				olson_description => "",
				timezone_name => "Europe/Paris",
			},
		},
	},
	GA => {
		alpha2_code => "GA",
		olson_name => "Gabon",
		regions => {
			"" => {
				location_coords => "+0023+00927",
				olson_description => "",
				timezone_name => "Africa/Libreville",
			},
		},
	},
	GB => {
		alpha2_code => "GB",
		olson_name => "Britain (UK)",
		regions => {
			"" => {
				location_coords => "+513030-0000731",
				olson_description => "",
				timezone_name => "Europe/London",
			},
		},
	},
	GD => {
		alpha2_code => "GD",
		olson_name => "Grenada",
		regions => {
			"" => {
				location_coords => "+1203-06145",
				olson_description => "",
				timezone_name => "America/Grenada",
			},
		},
	},
	GE => {
		alpha2_code => "GE",
		olson_name => "Georgia",
		regions => {
			"" => {
				location_coords => "+4143+04449",
				olson_description => "",
				timezone_name => "Asia/Tbilisi",
			},
		},
	},
	GF => {
		alpha2_code => "GF",
		olson_name => "French Guiana",
		regions => {
			"" => {
				location_coords => "+0456-05220",
				olson_description => "",
				timezone_name => "America/Cayenne",
			},
		},
	},
	GG => {
		alpha2_code => "GG",
		olson_name => "Guernsey",
		regions => {
			"" => {
				location_coords => "+4927-00232",
				olson_description => "",
				timezone_name => "Europe/Guernsey",
			},
		},
	},
	GH => {
		alpha2_code => "GH",
		olson_name => "Ghana",
		regions => {
			"" => {
				location_coords => "+0533-00013",
				olson_description => "",
				timezone_name => "Africa/Accra",
			},
		},
	},
	GI => {
		alpha2_code => "GI",
		olson_name => "Gibraltar",
		regions => {
			"" => {
				location_coords => "+3608-00521",
				olson_description => "",
				timezone_name => "Europe/Gibraltar",
			},
		},
	},
	GL => {
		alpha2_code => "GL",
		olson_name => "Greenland",
		regions => {
			"Scoresbysund / Ittoqqortoormiit" => {
				location_coords => "+7029-02158",
				olson_description => "Scoresbysund / Ittoqqortoormiit",
				timezone_name => "America/Scoresbysund",
			},
			"Thule / Pituffik" => {
				location_coords => "+7634-06847",
				olson_description => "Thule / Pituffik",
				timezone_name => "America/Thule",
			},
			"east coast, north of Scoresbysund" => {
				location_coords => "+7646-01840",
				olson_description => "east coast, north of Scoresbysund",
				timezone_name => "America/Danmarkshavn",
			},
			"most locations" => {
				location_coords => "+6411-05144",
				olson_description => "most locations",
				timezone_name => "America/Godthab",
			},
		},
	},
	GM => {
		alpha2_code => "GM",
		olson_name => "Gambia",
		regions => {
			"" => {
				location_coords => "+1328-01639",
				olson_description => "",
				timezone_name => "Africa/Banjul",
			},
		},
	},
	GN => {
		alpha2_code => "GN",
		olson_name => "Guinea",
		regions => {
			"" => {
				location_coords => "+0931-01343",
				olson_description => "",
				timezone_name => "Africa/Conakry",
			},
		},
	},
	GP => {
		alpha2_code => "GP",
		olson_name => "Guadeloupe",
		regions => {
			"" => {
				location_coords => "+1614-06132",
				olson_description => "",
				timezone_name => "America/Guadeloupe",
			},
		},
	},
	GQ => {
		alpha2_code => "GQ",
		olson_name => "Equatorial Guinea",
		regions => {
			"" => {
				location_coords => "+0345+00847",
				olson_description => "",
				timezone_name => "Africa/Malabo",
			},
		},
	},
	GR => {
		alpha2_code => "GR",
		olson_name => "Greece",
		regions => {
			"" => {
				location_coords => "+3758+02343",
				olson_description => "",
				timezone_name => "Europe/Athens",
			},
		},
	},
	GS => {
		alpha2_code => "GS",
		olson_name => "South Georgia & the South Sandwich Islands",
		regions => {
			"" => {
				location_coords => "-5416-03632",
				olson_description => "",
				timezone_name => "Atlantic/South_Georgia",
			},
		},
	},
	GT => {
		alpha2_code => "GT",
		olson_name => "Guatemala",
		regions => {
			"" => {
				location_coords => "+1438-09031",
				olson_description => "",
				timezone_name => "America/Guatemala",
			},
		},
	},
	GU => {
		alpha2_code => "GU",
		olson_name => "Guam",
		regions => {
			"" => {
				location_coords => "+1328+14445",
				olson_description => "",
				timezone_name => "Pacific/Guam",
			},
		},
	},
	GW => {
		alpha2_code => "GW",
		olson_name => "Guinea-Bissau",
		regions => {
			"" => {
				location_coords => "+1151-01535",
				olson_description => "",
				timezone_name => "Africa/Bissau",
			},
		},
	},
	GY => {
		alpha2_code => "GY",
		olson_name => "Guyana",
		regions => {
			"" => {
				location_coords => "+0648-05810",
				olson_description => "",
				timezone_name => "America/Guyana",
			},
		},
	},
	HK => {
		alpha2_code => "HK",
		olson_name => "Hong Kong",
		regions => {
			"" => {
				location_coords => "+2217+11409",
				olson_description => "",
				timezone_name => "Asia/Hong_Kong",
			},
		},
	},
	HN => {
		alpha2_code => "HN",
		olson_name => "Honduras",
		regions => {
			"" => {
				location_coords => "+1406-08713",
				olson_description => "",
				timezone_name => "America/Tegucigalpa",
			},
		},
	},
	HR => {
		alpha2_code => "HR",
		olson_name => "Croatia",
		regions => {
			"" => {
				location_coords => "+4548+01558",
				olson_description => "",
				timezone_name => "Europe/Zagreb",
			},
		},
	},
	HT => {
		alpha2_code => "HT",
		olson_name => "Haiti",
		regions => {
			"" => {
				location_coords => "+1832-07220",
				olson_description => "",
				timezone_name => "America/Port-au-Prince",
			},
		},
	},
	HU => {
		alpha2_code => "HU",
		olson_name => "Hungary",
		regions => {
			"" => {
				location_coords => "+4730+01905",
				olson_description => "",
				timezone_name => "Europe/Budapest",
			},
		},
	},
	ID => {
		alpha2_code => "ID",
		olson_name => "Indonesia",
		regions => {
			"Java & Sumatra" => {
				location_coords => "-0610+10648",
				olson_description => "Java & Sumatra",
				timezone_name => "Asia/Jakarta",
			},
			"east & south Borneo, Sulawesi (Celebes), Bali, Nusa Tengarra, west Timor" => {
				location_coords => "-0507+11924",
				olson_description => "east & south Borneo, Sulawesi (Celebes), Bali, Nusa Tengarra, west Timor",
				timezone_name => "Asia/Makassar",
			},
			"west & central Borneo" => {
				location_coords => "-0002+10920",
				olson_description => "west & central Borneo",
				timezone_name => "Asia/Pontianak",
			},
			"west New Guinea (Irian Jaya) & Malukus (Moluccas)" => {
				location_coords => "-0232+14042",
				olson_description => "west New Guinea (Irian Jaya) & Malukus (Moluccas)",
				timezone_name => "Asia/Jayapura",
			},
		},
	},
	IE => {
		alpha2_code => "IE",
		olson_name => "Ireland",
		regions => {
			"" => {
				location_coords => "+5320-00615",
				olson_description => "",
				timezone_name => "Europe/Dublin",
			},
		},
	},
	IL => {
		alpha2_code => "IL",
		olson_name => "Israel",
		regions => {
			"" => {
				location_coords => "+3146+03514",
				olson_description => "",
				timezone_name => "Asia/Jerusalem",
			},
		},
	},
	IM => {
		alpha2_code => "IM",
		olson_name => "Isle of Man",
		regions => {
			"" => {
				location_coords => "+5409-00428",
				olson_description => "",
				timezone_name => "Europe/Isle_of_Man",
			},
		},
	},
	IN => {
		alpha2_code => "IN",
		olson_name => "India",
		regions => {
			"" => {
				location_coords => "+2232+08822",
				olson_description => "",
				timezone_name => "Asia/Kolkata",
			},
		},
	},
	IO => {
		alpha2_code => "IO",
		olson_name => "British Indian Ocean Territory",
		regions => {
			"" => {
				location_coords => "-0720+07225",
				olson_description => "",
				timezone_name => "Indian/Chagos",
			},
		},
	},
	IQ => {
		alpha2_code => "IQ",
		olson_name => "Iraq",
		regions => {
			"" => {
				location_coords => "+3321+04425",
				olson_description => "",
				timezone_name => "Asia/Baghdad",
			},
		},
	},
	IR => {
		alpha2_code => "IR",
		olson_name => "Iran",
		regions => {
			"" => {
				location_coords => "+3540+05126",
				olson_description => "",
				timezone_name => "Asia/Tehran",
			},
		},
	},
	IS => {
		alpha2_code => "IS",
		olson_name => "Iceland",
		regions => {
			"" => {
				location_coords => "+6409-02151",
				olson_description => "",
				timezone_name => "Atlantic/Reykjavik",
			},
		},
	},
	IT => {
		alpha2_code => "IT",
		olson_name => "Italy",
		regions => {
			"" => {
				location_coords => "+4154+01229",
				olson_description => "",
				timezone_name => "Europe/Rome",
			},
		},
	},
	JE => {
		alpha2_code => "JE",
		olson_name => "Jersey",
		regions => {
			"" => {
				location_coords => "+4912-00207",
				olson_description => "",
				timezone_name => "Europe/Jersey",
			},
		},
	},
	JM => {
		alpha2_code => "JM",
		olson_name => "Jamaica",
		regions => {
			"" => {
				location_coords => "+1800-07648",
				olson_description => "",
				timezone_name => "America/Jamaica",
			},
		},
	},
	JO => {
		alpha2_code => "JO",
		olson_name => "Jordan",
		regions => {
			"" => {
				location_coords => "+3157+03556",
				olson_description => "",
				timezone_name => "Asia/Amman",
			},
		},
	},
	JP => {
		alpha2_code => "JP",
		olson_name => "Japan",
		regions => {
			"" => {
				location_coords => "+353916+1394441",
				olson_description => "",
				timezone_name => "Asia/Tokyo",
			},
		},
	},
	KE => {
		alpha2_code => "KE",
		olson_name => "Kenya",
		regions => {
			"" => {
				location_coords => "-0117+03649",
				olson_description => "",
				timezone_name => "Africa/Nairobi",
			},
		},
	},
	KG => {
		alpha2_code => "KG",
		olson_name => "Kyrgyzstan",
		regions => {
			"" => {
				location_coords => "+4254+07436",
				olson_description => "",
				timezone_name => "Asia/Bishkek",
			},
		},
	},
	KH => {
		alpha2_code => "KH",
		olson_name => "Cambodia",
		regions => {
			"" => {
				location_coords => "+1133+10455",
				olson_description => "",
				timezone_name => "Asia/Phnom_Penh",
			},
		},
	},
	KI => {
		alpha2_code => "KI",
		olson_name => "Kiribati",
		regions => {
			"Gilbert Islands" => {
				location_coords => "+0125+17300",
				olson_description => "Gilbert Islands",
				timezone_name => "Pacific/Tarawa",
			},
			"Line Islands" => {
				location_coords => "+0152-15720",
				olson_description => "Line Islands",
				timezone_name => "Pacific/Kiritimati",
			},
			"Phoenix Islands" => {
				location_coords => "-0308-17105",
				olson_description => "Phoenix Islands",
				timezone_name => "Pacific/Enderbury",
			},
		},
	},
	KM => {
		alpha2_code => "KM",
		olson_name => "Comoros",
		regions => {
			"" => {
				location_coords => "-1141+04316",
				olson_description => "",
				timezone_name => "Indian/Comoro",
			},
		},
	},
	KN => {
		alpha2_code => "KN",
		olson_name => "St Kitts & Nevis",
		regions => {
			"" => {
				location_coords => "+1718-06243",
				olson_description => "",
				timezone_name => "America/St_Kitts",
			},
		},
	},
	KP => {
		alpha2_code => "KP",
		olson_name => "Korea (North)",
		regions => {
			"" => {
				location_coords => "+3901+12545",
				olson_description => "",
				timezone_name => "Asia/Pyongyang",
			},
		},
	},
	KR => {
		alpha2_code => "KR",
		olson_name => "Korea (South)",
		regions => {
			"" => {
				location_coords => "+3733+12658",
				olson_description => "",
				timezone_name => "Asia/Seoul",
			},
		},
	},
	KW => {
		alpha2_code => "KW",
		olson_name => "Kuwait",
		regions => {
			"" => {
				location_coords => "+2920+04759",
				olson_description => "",
				timezone_name => "Asia/Kuwait",
			},
		},
	},
	KY => {
		alpha2_code => "KY",
		olson_name => "Cayman Islands",
		regions => {
			"" => {
				location_coords => "+1918-08123",
				olson_description => "",
				timezone_name => "America/Cayman",
			},
		},
	},
	KZ => {
		alpha2_code => "KZ",
		olson_name => "Kazakhstan",
		regions => {
			"Aqtobe (Aktobe)" => {
				location_coords => "+5017+05710",
				olson_description => "Aqtobe (Aktobe)",
				timezone_name => "Asia/Aqtobe",
			},
			"Atyrau (Atirau, Gur'yev), Mangghystau (Mankistau)" => {
				location_coords => "+4431+05016",
				olson_description => "Atyrau (Atirau, Gur'yev), Mangghystau (Mankistau)",
				timezone_name => "Asia/Aqtau",
			},
			"Qyzylorda (Kyzylorda, Kzyl-Orda)" => {
				location_coords => "+4448+06528",
				olson_description => "Qyzylorda (Kyzylorda, Kzyl-Orda)",
				timezone_name => "Asia/Qyzylorda",
			},
			"West Kazakhstan" => {
				location_coords => "+5113+05121",
				olson_description => "West Kazakhstan",
				timezone_name => "Asia/Oral",
			},
			"most locations" => {
				location_coords => "+4315+07657",
				olson_description => "most locations",
				timezone_name => "Asia/Almaty",
			},
		},
	},
	LA => {
		alpha2_code => "LA",
		olson_name => "Laos",
		regions => {
			"" => {
				location_coords => "+1758+10236",
				olson_description => "",
				timezone_name => "Asia/Vientiane",
			},
		},
	},
	LB => {
		alpha2_code => "LB",
		olson_name => "Lebanon",
		regions => {
			"" => {
				location_coords => "+3353+03530",
				olson_description => "",
				timezone_name => "Asia/Beirut",
			},
		},
	},
	LC => {
		alpha2_code => "LC",
		olson_name => "St Lucia",
		regions => {
			"" => {
				location_coords => "+1401-06100",
				olson_description => "",
				timezone_name => "America/St_Lucia",
			},
		},
	},
	LI => {
		alpha2_code => "LI",
		olson_name => "Liechtenstein",
		regions => {
			"" => {
				location_coords => "+4709+00931",
				olson_description => "",
				timezone_name => "Europe/Vaduz",
			},
		},
	},
	LK => {
		alpha2_code => "LK",
		olson_name => "Sri Lanka",
		regions => {
			"" => {
				location_coords => "+0656+07951",
				olson_description => "",
				timezone_name => "Asia/Colombo",
			},
		},
	},
	LR => {
		alpha2_code => "LR",
		olson_name => "Liberia",
		regions => {
			"" => {
				location_coords => "+0618-01047",
				olson_description => "",
				timezone_name => "Africa/Monrovia",
			},
		},
	},
	LS => {
		alpha2_code => "LS",
		olson_name => "Lesotho",
		regions => {
			"" => {
				location_coords => "-2928+02730",
				olson_description => "",
				timezone_name => "Africa/Maseru",
			},
		},
	},
	LT => {
		alpha2_code => "LT",
		olson_name => "Lithuania",
		regions => {
			"" => {
				location_coords => "+5441+02519",
				olson_description => "",
				timezone_name => "Europe/Vilnius",
			},
		},
	},
	LU => {
		alpha2_code => "LU",
		olson_name => "Luxembourg",
		regions => {
			"" => {
				location_coords => "+4936+00609",
				olson_description => "",
				timezone_name => "Europe/Luxembourg",
			},
		},
	},
	LV => {
		alpha2_code => "LV",
		olson_name => "Latvia",
		regions => {
			"" => {
				location_coords => "+5657+02406",
				olson_description => "",
				timezone_name => "Europe/Riga",
			},
		},
	},
	LY => {
		alpha2_code => "LY",
		olson_name => "Libya",
		regions => {
			"" => {
				location_coords => "+3254+01311",
				olson_description => "",
				timezone_name => "Africa/Tripoli",
			},
		},
	},
	MA => {
		alpha2_code => "MA",
		olson_name => "Morocco",
		regions => {
			"" => {
				location_coords => "+3339-00735",
				olson_description => "",
				timezone_name => "Africa/Casablanca",
			},
		},
	},
	MC => {
		alpha2_code => "MC",
		olson_name => "Monaco",
		regions => {
			"" => {
				location_coords => "+4342+00723",
				olson_description => "",
				timezone_name => "Europe/Monaco",
			},
		},
	},
	MD => {
		alpha2_code => "MD",
		olson_name => "Moldova",
		regions => {
			"" => {
				location_coords => "+4700+02850",
				olson_description => "",
				timezone_name => "Europe/Chisinau",
			},
		},
	},
	ME => {
		alpha2_code => "ME",
		olson_name => "Montenegro",
		regions => {
			"" => {
				location_coords => "+4226+01916",
				olson_description => "",
				timezone_name => "Europe/Podgorica",
			},
		},
	},
	MF => {
		alpha2_code => "MF",
		olson_name => "St Martin (French part)",
		regions => {
			"" => {
				location_coords => "+1804-06305",
				olson_description => "",
				timezone_name => "America/Marigot",
			},
		},
	},
	MG => {
		alpha2_code => "MG",
		olson_name => "Madagascar",
		regions => {
			"" => {
				location_coords => "-1855+04731",
				olson_description => "",
				timezone_name => "Indian/Antananarivo",
			},
		},
	},
	MH => {
		alpha2_code => "MH",
		olson_name => "Marshall Islands",
		regions => {
			Kwajalein => {
				location_coords => "+0905+16720",
				olson_description => "Kwajalein",
				timezone_name => "Pacific/Kwajalein",
			},
			"most locations" => {
				location_coords => "+0709+17112",
				olson_description => "most locations",
				timezone_name => "Pacific/Majuro",
			},
		},
	},
	MK => {
		alpha2_code => "MK",
		olson_name => "Macedonia",
		regions => {
			"" => {
				location_coords => "+4159+02126",
				olson_description => "",
				timezone_name => "Europe/Skopje",
			},
		},
	},
	ML => {
		alpha2_code => "ML",
		olson_name => "Mali",
		regions => {
			"" => {
				location_coords => "+1239-00800",
				olson_description => "",
				timezone_name => "Africa/Bamako",
			},
		},
	},
	MM => {
		alpha2_code => "MM",
		olson_name => "Myanmar (Burma)",
		regions => {
			"" => {
				location_coords => "+1647+09610",
				olson_description => "",
				timezone_name => "Asia/Rangoon",
			},
		},
	},
	MN => {
		alpha2_code => "MN",
		olson_name => "Mongolia",
		regions => {
			"Bayan-Olgiy, Govi-Altai, Hovd, Uvs, Zavkhan" => {
				location_coords => "+4801+09139",
				olson_description => "Bayan-Olgiy, Govi-Altai, Hovd, Uvs, Zavkhan",
				timezone_name => "Asia/Hovd",
			},
			"Dornod, Sukhbaatar" => {
				location_coords => "+4804+11430",
				olson_description => "Dornod, Sukhbaatar",
				timezone_name => "Asia/Choibalsan",
			},
			"most locations" => {
				location_coords => "+4755+10653",
				olson_description => "most locations",
				timezone_name => "Asia/Ulaanbaatar",
			},
		},
	},
	MO => {
		alpha2_code => "MO",
		olson_name => "Macau",
		regions => {
			"" => {
				location_coords => "+2214+11335",
				olson_description => "",
				timezone_name => "Asia/Macau",
			},
		},
	},
	MP => {
		alpha2_code => "MP",
		olson_name => "Northern Mariana Islands",
		regions => {
			"" => {
				location_coords => "+1512+14545",
				olson_description => "",
				timezone_name => "Pacific/Saipan",
			},
		},
	},
	MQ => {
		alpha2_code => "MQ",
		olson_name => "Martinique",
		regions => {
			"" => {
				location_coords => "+1436-06105",
				olson_description => "",
				timezone_name => "America/Martinique",
			},
		},
	},
	MR => {
		alpha2_code => "MR",
		olson_name => "Mauritania",
		regions => {
			"" => {
				location_coords => "+1806-01557",
				olson_description => "",
				timezone_name => "Africa/Nouakchott",
			},
		},
	},
	MS => {
		alpha2_code => "MS",
		olson_name => "Montserrat",
		regions => {
			"" => {
				location_coords => "+1643-06213",
				olson_description => "",
				timezone_name => "America/Montserrat",
			},
		},
	},
	MT => {
		alpha2_code => "MT",
		olson_name => "Malta",
		regions => {
			"" => {
				location_coords => "+3554+01431",
				olson_description => "",
				timezone_name => "Europe/Malta",
			},
		},
	},
	MU => {
		alpha2_code => "MU",
		olson_name => "Mauritius",
		regions => {
			"" => {
				location_coords => "-2010+05730",
				olson_description => "",
				timezone_name => "Indian/Mauritius",
			},
		},
	},
	MV => {
		alpha2_code => "MV",
		olson_name => "Maldives",
		regions => {
			"" => {
				location_coords => "+0410+07330",
				olson_description => "",
				timezone_name => "Indian/Maldives",
			},
		},
	},
	MW => {
		alpha2_code => "MW",
		olson_name => "Malawi",
		regions => {
			"" => {
				location_coords => "-1547+03500",
				olson_description => "",
				timezone_name => "Africa/Blantyre",
			},
		},
	},
	MX => {
		alpha2_code => "MX",
		olson_name => "Mexico",
		regions => {
			"Central Time - Campeche, Yucatan" => {
				location_coords => "+2058-08937",
				olson_description => "Central Time - Campeche, Yucatan",
				timezone_name => "America/Merida",
			},
			"Central Time - Quintana Roo" => {
				location_coords => "+2105-08646",
				olson_description => "Central Time - Quintana Roo",
				timezone_name => "America/Cancun",
			},
			"Central Time - most locations" => {
				location_coords => "+1924-09909",
				olson_description => "Central Time - most locations",
				timezone_name => "America/Mexico_City",
			},
			"Mexican Central Time - Bahia de Banderas" => {
				location_coords => "+2048-10515",
				olson_description => "Mexican Central Time - Bahia de Banderas",
				timezone_name => "America/Bahia_Banderas",
			},
			"Mexican Central Time - Coahuila, Durango, Nuevo Leon, Tamaulipas away from US border" => {
				location_coords => "+2540-10019",
				olson_description => "Mexican Central Time - Coahuila, Durango, Nuevo Leon, Tamaulipas away from US border",
				timezone_name => "America/Monterrey",
			},
			"Mexican Mountain Time - Chihuahua away from US border" => {
				location_coords => "+2838-10605",
				olson_description => "Mexican Mountain Time - Chihuahua away from US border",
				timezone_name => "America/Chihuahua",
			},
			"Mexican Pacific Time - Baja California away from US border" => {
				location_coords => "+3018-11452",
				olson_description => "Mexican Pacific Time - Baja California away from US border",
				timezone_name => "America/Santa_Isabel",
			},
			"Mountain Standard Time - Sonora" => {
				location_coords => "+2904-11058",
				olson_description => "Mountain Standard Time - Sonora",
				timezone_name => "America/Hermosillo",
			},
			"Mountain Time - S Baja, Nayarit, Sinaloa" => {
				location_coords => "+2313-10625",
				olson_description => "Mountain Time - S Baja, Nayarit, Sinaloa",
				timezone_name => "America/Mazatlan",
			},
			"US Central Time - Coahuila, Durango, Nuevo Leon, Tamaulipas near US border" => {
				location_coords => "+2550-09730",
				olson_description => "US Central Time - Coahuila, Durango, Nuevo Leon, Tamaulipas near US border",
				timezone_name => "America/Matamoros",
			},
			"US Mountain Time - Chihuahua near US border" => {
				location_coords => "+2934-10425",
				olson_description => "US Mountain Time - Chihuahua near US border",
				timezone_name => "America/Ojinaga",
			},
			"US Pacific Time - Baja California near US border" => {
				location_coords => "+3232-11701",
				olson_description => "US Pacific Time - Baja California near US border",
				timezone_name => "America/Tijuana",
			},
		},
	},
	MY => {
		alpha2_code => "MY",
		olson_name => "Malaysia",
		regions => {
			"Sabah & Sarawak" => {
				location_coords => "+0133+11020",
				olson_description => "Sabah & Sarawak",
				timezone_name => "Asia/Kuching",
			},
			"peninsular Malaysia" => {
				location_coords => "+0310+10142",
				olson_description => "peninsular Malaysia",
				timezone_name => "Asia/Kuala_Lumpur",
			},
		},
	},
	MZ => {
		alpha2_code => "MZ",
		olson_name => "Mozambique",
		regions => {
			"" => {
				location_coords => "-2558+03235",
				olson_description => "",
				timezone_name => "Africa/Maputo",
			},
		},
	},
	NA => {
		alpha2_code => "NA",
		olson_name => "Namibia",
		regions => {
			"" => {
				location_coords => "-2234+01706",
				olson_description => "",
				timezone_name => "Africa/Windhoek",
			},
		},
	},
	NC => {
		alpha2_code => "NC",
		olson_name => "New Caledonia",
		regions => {
			"" => {
				location_coords => "-2216+16627",
				olson_description => "",
				timezone_name => "Pacific/Noumea",
			},
		},
	},
	NE => {
		alpha2_code => "NE",
		olson_name => "Niger",
		regions => {
			"" => {
				location_coords => "+1331+00207",
				olson_description => "",
				timezone_name => "Africa/Niamey",
			},
		},
	},
	NF => {
		alpha2_code => "NF",
		olson_name => "Norfolk Island",
		regions => {
			"" => {
				location_coords => "-2903+16758",
				olson_description => "",
				timezone_name => "Pacific/Norfolk",
			},
		},
	},
	NG => {
		alpha2_code => "NG",
		olson_name => "Nigeria",
		regions => {
			"" => {
				location_coords => "+0627+00324",
				olson_description => "",
				timezone_name => "Africa/Lagos",
			},
		},
	},
	NI => {
		alpha2_code => "NI",
		olson_name => "Nicaragua",
		regions => {
			"" => {
				location_coords => "+1209-08617",
				olson_description => "",
				timezone_name => "America/Managua",
			},
		},
	},
	NL => {
		alpha2_code => "NL",
		olson_name => "Netherlands",
		regions => {
			"" => {
				location_coords => "+5222+00454",
				olson_description => "",
				timezone_name => "Europe/Amsterdam",
			},
		},
	},
	NO => {
		alpha2_code => "NO",
		olson_name => "Norway",
		regions => {
			"" => {
				location_coords => "+5955+01045",
				olson_description => "",
				timezone_name => "Europe/Oslo",
			},
		},
	},
	NP => {
		alpha2_code => "NP",
		olson_name => "Nepal",
		regions => {
			"" => {
				location_coords => "+2743+08519",
				olson_description => "",
				timezone_name => "Asia/Kathmandu",
			},
		},
	},
	NR => {
		alpha2_code => "NR",
		olson_name => "Nauru",
		regions => {
			"" => {
				location_coords => "-0031+16655",
				olson_description => "",
				timezone_name => "Pacific/Nauru",
			},
		},
	},
	NU => {
		alpha2_code => "NU",
		olson_name => "Niue",
		regions => {
			"" => {
				location_coords => "-1901-16955",
				olson_description => "",
				timezone_name => "Pacific/Niue",
			},
		},
	},
	NZ => {
		alpha2_code => "NZ",
		olson_name => "New Zealand",
		regions => {
			"Chatham Islands" => {
				location_coords => "-4357-17633",
				olson_description => "Chatham Islands",
				timezone_name => "Pacific/Chatham",
			},
			"most locations" => {
				location_coords => "-3652+17446",
				olson_description => "most locations",
				timezone_name => "Pacific/Auckland",
			},
		},
	},
	OM => {
		alpha2_code => "OM",
		olson_name => "Oman",
		regions => {
			"" => {
				location_coords => "+2336+05835",
				olson_description => "",
				timezone_name => "Asia/Muscat",
			},
		},
	},
	PA => {
		alpha2_code => "PA",
		olson_name => "Panama",
		regions => {
			"" => {
				location_coords => "+0858-07932",
				olson_description => "",
				timezone_name => "America/Panama",
			},
		},
	},
	PE => {
		alpha2_code => "PE",
		olson_name => "Peru",
		regions => {
			"" => {
				location_coords => "-1203-07703",
				olson_description => "",
				timezone_name => "America/Lima",
			},
		},
	},
	PF => {
		alpha2_code => "PF",
		olson_name => "French Polynesia",
		regions => {
			"Gambier Islands" => {
				location_coords => "-2308-13457",
				olson_description => "Gambier Islands",
				timezone_name => "Pacific/Gambier",
			},
			"Marquesas Islands" => {
				location_coords => "-0900-13930",
				olson_description => "Marquesas Islands",
				timezone_name => "Pacific/Marquesas",
			},
			"Society Islands" => {
				location_coords => "-1732-14934",
				olson_description => "Society Islands",
				timezone_name => "Pacific/Tahiti",
			},
		},
	},
	PG => {
		alpha2_code => "PG",
		olson_name => "Papua New Guinea",
		regions => {
			"" => {
				location_coords => "-0930+14710",
				olson_description => "",
				timezone_name => "Pacific/Port_Moresby",
			},
		},
	},
	PH => {
		alpha2_code => "PH",
		olson_name => "Philippines",
		regions => {
			"" => {
				location_coords => "+1435+12100",
				olson_description => "",
				timezone_name => "Asia/Manila",
			},
		},
	},
	PK => {
		alpha2_code => "PK",
		olson_name => "Pakistan",
		regions => {
			"" => {
				location_coords => "+2452+06703",
				olson_description => "",
				timezone_name => "Asia/Karachi",
			},
		},
	},
	PL => {
		alpha2_code => "PL",
		olson_name => "Poland",
		regions => {
			"" => {
				location_coords => "+5215+02100",
				olson_description => "",
				timezone_name => "Europe/Warsaw",
			},
		},
	},
	PM => {
		alpha2_code => "PM",
		olson_name => "St Pierre & Miquelon",
		regions => {
			"" => {
				location_coords => "+4703-05620",
				olson_description => "",
				timezone_name => "America/Miquelon",
			},
		},
	},
	PN => {
		alpha2_code => "PN",
		olson_name => "Pitcairn",
		regions => {
			"" => {
				location_coords => "-2504-13005",
				olson_description => "",
				timezone_name => "Pacific/Pitcairn",
			},
		},
	},
	PR => {
		alpha2_code => "PR",
		olson_name => "Puerto Rico",
		regions => {
			"" => {
				location_coords => "+182806-0660622",
				olson_description => "",
				timezone_name => "America/Puerto_Rico",
			},
		},
	},
	PS => {
		alpha2_code => "PS",
		olson_name => "Palestine",
		regions => {
			"" => {
				location_coords => "+3130+03428",
				olson_description => "",
				timezone_name => "Asia/Gaza",
			},
		},
	},
	PT => {
		alpha2_code => "PT",
		olson_name => "Portugal",
		regions => {
			Azores => {
				location_coords => "+3744-02540",
				olson_description => "Azores",
				timezone_name => "Atlantic/Azores",
			},
			"Madeira Islands" => {
				location_coords => "+3238-01654",
				olson_description => "Madeira Islands",
				timezone_name => "Atlantic/Madeira",
			},
			mainland => {
				location_coords => "+3843-00908",
				olson_description => "mainland",
				timezone_name => "Europe/Lisbon",
			},
		},
	},
	PW => {
		alpha2_code => "PW",
		olson_name => "Palau",
		regions => {
			"" => {
				location_coords => "+0720+13429",
				olson_description => "",
				timezone_name => "Pacific/Palau",
			},
		},
	},
	PY => {
		alpha2_code => "PY",
		olson_name => "Paraguay",
		regions => {
			"" => {
				location_coords => "-2516-05740",
				olson_description => "",
				timezone_name => "America/Asuncion",
			},
		},
	},
	QA => {
		alpha2_code => "QA",
		olson_name => "Qatar",
		regions => {
			"" => {
				location_coords => "+2517+05132",
				olson_description => "",
				timezone_name => "Asia/Qatar",
			},
		},
	},
	RE => {
		alpha2_code => "RE",
		olson_name => "Reunion",
		regions => {
			"" => {
				location_coords => "-2052+05528",
				olson_description => "",
				timezone_name => "Indian/Reunion",
			},
		},
	},
	RO => {
		alpha2_code => "RO",
		olson_name => "Romania",
		regions => {
			"" => {
				location_coords => "+4426+02606",
				olson_description => "",
				timezone_name => "Europe/Bucharest",
			},
		},
	},
	RS => {
		alpha2_code => "RS",
		olson_name => "Serbia",
		regions => {
			"" => {
				location_coords => "+4450+02030",
				olson_description => "",
				timezone_name => "Europe/Belgrade",
			},
		},
	},
	RU => {
		alpha2_code => "RU",
		olson_name => "Russia",
		regions => {
			"Moscow - Samara, Udmurtia" => {
				location_coords => "+5312+05009",
				olson_description => "Moscow - Samara, Udmurtia",
				timezone_name => "Europe/Samara",
			},
			"Moscow+00 - Caspian Sea" => {
				location_coords => "+4844+04425",
				olson_description => "Moscow+00 - Caspian Sea",
				timezone_name => "Europe/Volgograd",
			},
			"Moscow+00 - west Russia" => {
				location_coords => "+5545+03735",
				olson_description => "Moscow+00 - west Russia",
				timezone_name => "Europe/Moscow",
			},
			"Moscow+02 - Urals" => {
				location_coords => "+5651+06036",
				olson_description => "Moscow+02 - Urals",
				timezone_name => "Asia/Yekaterinburg",
			},
			"Moscow+03 - Novokuznetsk" => {
				location_coords => "+5345+08707",
				olson_description => "Moscow+03 - Novokuznetsk",
				timezone_name => "Asia/Novokuznetsk",
			},
			"Moscow+03 - Novosibirsk" => {
				location_coords => "+5502+08255",
				olson_description => "Moscow+03 - Novosibirsk",
				timezone_name => "Asia/Novosibirsk",
			},
			"Moscow+03 - west Siberia" => {
				location_coords => "+5500+07324",
				olson_description => "Moscow+03 - west Siberia",
				timezone_name => "Asia/Omsk",
			},
			"Moscow+04 - Yenisei River" => {
				location_coords => "+5601+09250",
				olson_description => "Moscow+04 - Yenisei River",
				timezone_name => "Asia/Krasnoyarsk",
			},
			"Moscow+05 - Lake Baikal" => {
				location_coords => "+5216+10420",
				olson_description => "Moscow+05 - Lake Baikal",
				timezone_name => "Asia/Irkutsk",
			},
			"Moscow+06 - Lena River" => {
				location_coords => "+6200+12940",
				olson_description => "Moscow+06 - Lena River",
				timezone_name => "Asia/Yakutsk",
			},
			"Moscow+07 - Amur River" => {
				location_coords => "+4310+13156",
				olson_description => "Moscow+07 - Amur River",
				timezone_name => "Asia/Vladivostok",
			},
			"Moscow+07 - Sakhalin Island" => {
				location_coords => "+4658+14242",
				olson_description => "Moscow+07 - Sakhalin Island",
				timezone_name => "Asia/Sakhalin",
			},
			"Moscow+08 - Bering Sea" => {
				location_coords => "+6445+17729",
				olson_description => "Moscow+08 - Bering Sea",
				timezone_name => "Asia/Anadyr",
			},
			"Moscow+08 - Kamchatka" => {
				location_coords => "+5301+15839",
				olson_description => "Moscow+08 - Kamchatka",
				timezone_name => "Asia/Kamchatka",
			},
			"Moscow+08 - Magadan" => {
				location_coords => "+5934+15048",
				olson_description => "Moscow+08 - Magadan",
				timezone_name => "Asia/Magadan",
			},
			"Moscow-01 - Kaliningrad" => {
				location_coords => "+5443+02030",
				olson_description => "Moscow-01 - Kaliningrad",
				timezone_name => "Europe/Kaliningrad",
			},
		},
	},
	RW => {
		alpha2_code => "RW",
		olson_name => "Rwanda",
		regions => {
			"" => {
				location_coords => "-0157+03004",
				olson_description => "",
				timezone_name => "Africa/Kigali",
			},
		},
	},
	SA => {
		alpha2_code => "SA",
		olson_name => "Saudi Arabia",
		regions => {
			"" => {
				location_coords => "+2438+04643",
				olson_description => "",
				timezone_name => "Asia/Riyadh",
			},
		},
	},
	SB => {
		alpha2_code => "SB",
		olson_name => "Solomon Islands",
		regions => {
			"" => {
				location_coords => "-0932+16012",
				olson_description => "",
				timezone_name => "Pacific/Guadalcanal",
			},
		},
	},
	SC => {
		alpha2_code => "SC",
		olson_name => "Seychelles",
		regions => {
			"" => {
				location_coords => "-0440+05528",
				olson_description => "",
				timezone_name => "Indian/Mahe",
			},
		},
	},
	SD => {
		alpha2_code => "SD",
		olson_name => "Sudan",
		regions => {
			"" => {
				location_coords => "+1536+03232",
				olson_description => "",
				timezone_name => "Africa/Khartoum",
			},
		},
	},
	SE => {
		alpha2_code => "SE",
		olson_name => "Sweden",
		regions => {
			"" => {
				location_coords => "+5920+01803",
				olson_description => "",
				timezone_name => "Europe/Stockholm",
			},
		},
	},
	SG => {
		alpha2_code => "SG",
		olson_name => "Singapore",
		regions => {
			"" => {
				location_coords => "+0117+10351",
				olson_description => "",
				timezone_name => "Asia/Singapore",
			},
		},
	},
	SH => {
		alpha2_code => "SH",
		olson_name => "St Helena",
		regions => {
			"" => {
				location_coords => "-1555-00542",
				olson_description => "",
				timezone_name => "Atlantic/St_Helena",
			},
		},
	},
	SI => {
		alpha2_code => "SI",
		olson_name => "Slovenia",
		regions => {
			"" => {
				location_coords => "+4603+01431",
				olson_description => "",
				timezone_name => "Europe/Ljubljana",
			},
		},
	},
	SJ => {
		alpha2_code => "SJ",
		olson_name => "Svalbard & Jan Mayen",
		regions => {
			"" => {
				location_coords => "+7800+01600",
				olson_description => "",
				timezone_name => "Arctic/Longyearbyen",
			},
		},
	},
	SK => {
		alpha2_code => "SK",
		olson_name => "Slovakia",
		regions => {
			"" => {
				location_coords => "+4809+01707",
				olson_description => "",
				timezone_name => "Europe/Bratislava",
			},
		},
	},
	SL => {
		alpha2_code => "SL",
		olson_name => "Sierra Leone",
		regions => {
			"" => {
				location_coords => "+0830-01315",
				olson_description => "",
				timezone_name => "Africa/Freetown",
			},
		},
	},
	SM => {
		alpha2_code => "SM",
		olson_name => "San Marino",
		regions => {
			"" => {
				location_coords => "+4355+01228",
				olson_description => "",
				timezone_name => "Europe/San_Marino",
			},
		},
	},
	SN => {
		alpha2_code => "SN",
		olson_name => "Senegal",
		regions => {
			"" => {
				location_coords => "+1440-01726",
				olson_description => "",
				timezone_name => "Africa/Dakar",
			},
		},
	},
	SO => {
		alpha2_code => "SO",
		olson_name => "Somalia",
		regions => {
			"" => {
				location_coords => "+0204+04522",
				olson_description => "",
				timezone_name => "Africa/Mogadishu",
			},
		},
	},
	SR => {
		alpha2_code => "SR",
		olson_name => "Suriname",
		regions => {
			"" => {
				location_coords => "+0550-05510",
				olson_description => "",
				timezone_name => "America/Paramaribo",
			},
		},
	},
	SS => {
		alpha2_code => "SS",
		olson_name => "South Sudan",
		regions => {
			"" => {
				location_coords => "+0451+03136",
				olson_description => "",
				timezone_name => "Africa/Juba",
			},
		},
	},
	ST => {
		alpha2_code => "ST",
		olson_name => "Sao Tome & Principe",
		regions => {
			"" => {
				location_coords => "+0020+00644",
				olson_description => "",
				timezone_name => "Africa/Sao_Tome",
			},
		},
	},
	SV => {
		alpha2_code => "SV",
		olson_name => "El Salvador",
		regions => {
			"" => {
				location_coords => "+1342-08912",
				olson_description => "",
				timezone_name => "America/El_Salvador",
			},
		},
	},
	SX => {
		alpha2_code => "SX",
		olson_name => "Sint Maarten",
		regions => {
			"" => {
				location_coords => "+180305-0630250",
				olson_description => "",
				timezone_name => "America/Lower_Princes",
			},
		},
	},
	SY => {
		alpha2_code => "SY",
		olson_name => "Syria",
		regions => {
			"" => {
				location_coords => "+3330+03618",
				olson_description => "",
				timezone_name => "Asia/Damascus",
			},
		},
	},
	SZ => {
		alpha2_code => "SZ",
		olson_name => "Swaziland",
		regions => {
			"" => {
				location_coords => "-2618+03106",
				olson_description => "",
				timezone_name => "Africa/Mbabane",
			},
		},
	},
	TC => {
		alpha2_code => "TC",
		olson_name => "Turks & Caicos Is",
		regions => {
			"" => {
				location_coords => "+2128-07108",
				olson_description => "",
				timezone_name => "America/Grand_Turk",
			},
		},
	},
	TD => {
		alpha2_code => "TD",
		olson_name => "Chad",
		regions => {
			"" => {
				location_coords => "+1207+01503",
				olson_description => "",
				timezone_name => "Africa/Ndjamena",
			},
		},
	},
	TF => {
		alpha2_code => "TF",
		olson_name => "French Southern & Antarctic Lands",
		regions => {
			"" => {
				location_coords => "-492110+0701303",
				olson_description => "",
				timezone_name => "Indian/Kerguelen",
			},
		},
	},
	TG => {
		alpha2_code => "TG",
		olson_name => "Togo",
		regions => {
			"" => {
				location_coords => "+0608+00113",
				olson_description => "",
				timezone_name => "Africa/Lome",
			},
		},
	},
	TH => {
		alpha2_code => "TH",
		olson_name => "Thailand",
		regions => {
			"" => {
				location_coords => "+1345+10031",
				olson_description => "",
				timezone_name => "Asia/Bangkok",
			},
		},
	},
	TJ => {
		alpha2_code => "TJ",
		olson_name => "Tajikistan",
		regions => {
			"" => {
				location_coords => "+3835+06848",
				olson_description => "",
				timezone_name => "Asia/Dushanbe",
			},
		},
	},
	TK => {
		alpha2_code => "TK",
		olson_name => "Tokelau",
		regions => {
			"" => {
				location_coords => "-0922-17114",
				olson_description => "",
				timezone_name => "Pacific/Fakaofo",
			},
		},
	},
	TL => {
		alpha2_code => "TL",
		olson_name => "East Timor",
		regions => {
			"" => {
				location_coords => "-0833+12535",
				olson_description => "",
				timezone_name => "Asia/Dili",
			},
		},
	},
	TM => {
		alpha2_code => "TM",
		olson_name => "Turkmenistan",
		regions => {
			"" => {
				location_coords => "+3757+05823",
				olson_description => "",
				timezone_name => "Asia/Ashgabat",
			},
		},
	},
	TN => {
		alpha2_code => "TN",
		olson_name => "Tunisia",
		regions => {
			"" => {
				location_coords => "+3648+01011",
				olson_description => "",
				timezone_name => "Africa/Tunis",
			},
		},
	},
	TO => {
		alpha2_code => "TO",
		olson_name => "Tonga",
		regions => {
			"" => {
				location_coords => "-2110-17510",
				olson_description => "",
				timezone_name => "Pacific/Tongatapu",
			},
		},
	},
	TR => {
		alpha2_code => "TR",
		olson_name => "Turkey",
		regions => {
			"" => {
				location_coords => "+4101+02858",
				olson_description => "",
				timezone_name => "Europe/Istanbul",
			},
		},
	},
	TT => {
		alpha2_code => "TT",
		olson_name => "Trinidad & Tobago",
		regions => {
			"" => {
				location_coords => "+1039-06131",
				olson_description => "",
				timezone_name => "America/Port_of_Spain",
			},
		},
	},
	TV => {
		alpha2_code => "TV",
		olson_name => "Tuvalu",
		regions => {
			"" => {
				location_coords => "-0831+17913",
				olson_description => "",
				timezone_name => "Pacific/Funafuti",
			},
		},
	},
	TW => {
		alpha2_code => "TW",
		olson_name => "Taiwan",
		regions => {
			"" => {
				location_coords => "+2503+12130",
				olson_description => "",
				timezone_name => "Asia/Taipei",
			},
		},
	},
	TZ => {
		alpha2_code => "TZ",
		olson_name => "Tanzania",
		regions => {
			"" => {
				location_coords => "-0648+03917",
				olson_description => "",
				timezone_name => "Africa/Dar_es_Salaam",
			},
		},
	},
	UA => {
		alpha2_code => "UA",
		olson_name => "Ukraine",
		regions => {
			Ruthenia => {
				location_coords => "+4837+02218",
				olson_description => "Ruthenia",
				timezone_name => "Europe/Uzhgorod",
			},
			"Zaporozh'ye, E Lugansk / Zaporizhia, E Luhansk" => {
				location_coords => "+4750+03510",
				olson_description => "Zaporozh'ye, E Lugansk / Zaporizhia, E Luhansk",
				timezone_name => "Europe/Zaporozhye",
			},
			"central Crimea" => {
				location_coords => "+4457+03406",
				olson_description => "central Crimea",
				timezone_name => "Europe/Simferopol",
			},
			"most locations" => {
				location_coords => "+5026+03031",
				olson_description => "most locations",
				timezone_name => "Europe/Kiev",
			},
		},
	},
	UG => {
		alpha2_code => "UG",
		olson_name => "Uganda",
		regions => {
			"" => {
				location_coords => "+0019+03225",
				olson_description => "",
				timezone_name => "Africa/Kampala",
			},
		},
	},
	UM => {
		alpha2_code => "UM",
		olson_name => "US minor outlying islands",
		regions => {
			"Johnston Atoll" => {
				location_coords => "+1645-16931",
				olson_description => "Johnston Atoll",
				timezone_name => "Pacific/Johnston",
			},
			"Midway Islands" => {
				location_coords => "+2813-17722",
				olson_description => "Midway Islands",
				timezone_name => "Pacific/Midway",
			},
			"Wake Island" => {
				location_coords => "+1917+16637",
				olson_description => "Wake Island",
				timezone_name => "Pacific/Wake",
			},
		},
	},
	US => {
		alpha2_code => "US",
		olson_name => "United States",
		regions => {
			"Alaska Time" => {
				location_coords => "+611305-1495401",
				olson_description => "Alaska Time",
				timezone_name => "America/Anchorage",
			},
			"Alaska Time - Alaska panhandle" => {
				location_coords => "+581807-1342511",
				olson_description => "Alaska Time - Alaska panhandle",
				timezone_name => "America/Juneau",
			},
			"Alaska Time - Alaska panhandle neck" => {
				location_coords => "+593249-1394338",
				olson_description => "Alaska Time - Alaska panhandle neck",
				timezone_name => "America/Yakutat",
			},
			"Alaska Time - southeast Alaska panhandle" => {
				location_coords => "+571035-1351807",
				olson_description => "Alaska Time - southeast Alaska panhandle",
				timezone_name => "America/Sitka",
			},
			"Alaska Time - west Alaska" => {
				location_coords => "+643004-1652423",
				olson_description => "Alaska Time - west Alaska",
				timezone_name => "America/Nome",
			},
			"Aleutian Islands" => {
				location_coords => "+515248-1763929",
				olson_description => "Aleutian Islands",
				timezone_name => "America/Adak",
			},
			"Central Time" => {
				location_coords => "+415100-0873900",
				olson_description => "Central Time",
				timezone_name => "America/Chicago",
			},
			"Central Time - Indiana - Perry County" => {
				location_coords => "+375711-0864541",
				olson_description => "Central Time - Indiana - Perry County",
				timezone_name => "America/Indiana/Tell_City",
			},
			"Central Time - Indiana - Starke County" => {
				location_coords => "+411745-0863730",
				olson_description => "Central Time - Indiana - Starke County",
				timezone_name => "America/Indiana/Knox",
			},
			"Central Time - Michigan - Dickinson, Gogebic, Iron & Menominee Counties" => {
				location_coords => "+450628-0873651",
				olson_description => "Central Time - Michigan - Dickinson, Gogebic, Iron & Menominee Counties",
				timezone_name => "America/Menominee",
			},
			"Central Time - North Dakota - Mercer County" => {
				location_coords => "+471551-1014640",
				olson_description => "Central Time - North Dakota - Mercer County",
				timezone_name => "America/North_Dakota/Beulah",
			},
			"Central Time - North Dakota - Morton County (except Mandan area)" => {
				location_coords => "+465042-1012439",
				olson_description => "Central Time - North Dakota - Morton County (except Mandan area)",
				timezone_name => "America/North_Dakota/New_Salem",
			},
			"Central Time - North Dakota - Oliver County" => {
				location_coords => "+470659-1011757",
				olson_description => "Central Time - North Dakota - Oliver County",
				timezone_name => "America/North_Dakota/Center",
			},
			"Eastern Time" => {
				location_coords => "+404251-0740023",
				olson_description => "Eastern Time",
				timezone_name => "America/New_York",
			},
			"Eastern Time - Indiana - Crawford County" => {
				location_coords => "+382232-0862041",
				olson_description => "Eastern Time - Indiana - Crawford County",
				timezone_name => "America/Indiana/Marengo",
			},
			"Eastern Time - Indiana - Daviess, Dubois, Knox & Martin Counties" => {
				location_coords => "+384038-0873143",
				olson_description => "Eastern Time - Indiana - Daviess, Dubois, Knox & Martin Counties",
				timezone_name => "America/Indiana/Vincennes",
			},
			"Eastern Time - Indiana - Pike County" => {
				location_coords => "+382931-0871643",
				olson_description => "Eastern Time - Indiana - Pike County",
				timezone_name => "America/Indiana/Petersburg",
			},
			"Eastern Time - Indiana - Pulaski County" => {
				location_coords => "+410305-0863611",
				olson_description => "Eastern Time - Indiana - Pulaski County",
				timezone_name => "America/Indiana/Winamac",
			},
			"Eastern Time - Indiana - Switzerland County" => {
				location_coords => "+384452-0850402",
				olson_description => "Eastern Time - Indiana - Switzerland County",
				timezone_name => "America/Indiana/Vevay",
			},
			"Eastern Time - Indiana - most locations" => {
				location_coords => "+394606-0860929",
				olson_description => "Eastern Time - Indiana - most locations",
				timezone_name => "America/Indiana/Indianapolis",
			},
			"Eastern Time - Kentucky - Louisville area" => {
				location_coords => "+381515-0854534",
				olson_description => "Eastern Time - Kentucky - Louisville area",
				timezone_name => "America/Kentucky/Louisville",
			},
			"Eastern Time - Kentucky - Wayne County" => {
				location_coords => "+364947-0845057",
				olson_description => "Eastern Time - Kentucky - Wayne County",
				timezone_name => "America/Kentucky/Monticello",
			},
			"Eastern Time - Michigan - most locations" => {
				location_coords => "+421953-0830245",
				olson_description => "Eastern Time - Michigan - most locations",
				timezone_name => "America/Detroit",
			},
			Hawaii => {
				location_coords => "+211825-1575130",
				olson_description => "Hawaii",
				timezone_name => "Pacific/Honolulu",
			},
			"Metlakatla Time - Annette Island" => {
				location_coords => "+550737-1313435",
				olson_description => "Metlakatla Time - Annette Island",
				timezone_name => "America/Metlakatla",
			},
			"Mountain Standard Time - Arizona" => {
				location_coords => "+332654-1120424",
				olson_description => "Mountain Standard Time - Arizona",
				timezone_name => "America/Phoenix",
			},
			"Mountain Time" => {
				location_coords => "+394421-1045903",
				olson_description => "Mountain Time",
				timezone_name => "America/Denver",
			},
			"Mountain Time - Navajo" => {
				location_coords => "+364708-1084111",
				olson_description => "Mountain Time - Navajo",
				timezone_name => "America/Shiprock",
			},
			"Mountain Time - south Idaho & east Oregon" => {
				location_coords => "+433649-1161209",
				olson_description => "Mountain Time - south Idaho & east Oregon",
				timezone_name => "America/Boise",
			},
			"Pacific Time" => {
				location_coords => "+340308-1181434",
				olson_description => "Pacific Time",
				timezone_name => "America/Los_Angeles",
			},
		},
	},
	UY => {
		alpha2_code => "UY",
		olson_name => "Uruguay",
		regions => {
			"" => {
				location_coords => "-3453-05611",
				olson_description => "",
				timezone_name => "America/Montevideo",
			},
		},
	},
	UZ => {
		alpha2_code => "UZ",
		olson_name => "Uzbekistan",
		regions => {
			"east Uzbekistan" => {
				location_coords => "+4120+06918",
				olson_description => "east Uzbekistan",
				timezone_name => "Asia/Tashkent",
			},
			"west Uzbekistan" => {
				location_coords => "+3940+06648",
				olson_description => "west Uzbekistan",
				timezone_name => "Asia/Samarkand",
			},
		},
	},
	VA => {
		alpha2_code => "VA",
		olson_name => "Vatican City",
		regions => {
			"" => {
				location_coords => "+415408+0122711",
				olson_description => "",
				timezone_name => "Europe/Vatican",
			},
		},
	},
	VC => {
		alpha2_code => "VC",
		olson_name => "St Vincent",
		regions => {
			"" => {
				location_coords => "+1309-06114",
				olson_description => "",
				timezone_name => "America/St_Vincent",
			},
		},
	},
	VE => {
		alpha2_code => "VE",
		olson_name => "Venezuela",
		regions => {
			"" => {
				location_coords => "+1030-06656",
				olson_description => "",
				timezone_name => "America/Caracas",
			},
		},
	},
	VG => {
		alpha2_code => "VG",
		olson_name => "Virgin Islands (UK)",
		regions => {
			"" => {
				location_coords => "+1827-06437",
				olson_description => "",
				timezone_name => "America/Tortola",
			},
		},
	},
	VI => {
		alpha2_code => "VI",
		olson_name => "Virgin Islands (US)",
		regions => {
			"" => {
				location_coords => "+1821-06456",
				olson_description => "",
				timezone_name => "America/St_Thomas",
			},
		},
	},
	VN => {
		alpha2_code => "VN",
		olson_name => "Vietnam",
		regions => {
			"" => {
				location_coords => "+1045+10640",
				olson_description => "",
				timezone_name => "Asia/Ho_Chi_Minh",
			},
		},
	},
	VU => {
		alpha2_code => "VU",
		olson_name => "Vanuatu",
		regions => {
			"" => {
				location_coords => "-1740+16825",
				olson_description => "",
				timezone_name => "Pacific/Efate",
			},
		},
	},
	WF => {
		alpha2_code => "WF",
		olson_name => "Wallis & Futuna",
		regions => {
			"" => {
				location_coords => "-1318-17610",
				olson_description => "",
				timezone_name => "Pacific/Wallis",
			},
		},
	},
	WS => {
		alpha2_code => "WS",
		olson_name => "Samoa (western)",
		regions => {
			"" => {
				location_coords => "-1350-17144",
				olson_description => "",
				timezone_name => "Pacific/Apia",
			},
		},
	},
	YE => {
		alpha2_code => "YE",
		olson_name => "Yemen",
		regions => {
			"" => {
				location_coords => "+1245+04512",
				olson_description => "",
				timezone_name => "Asia/Aden",
			},
		},
	},
	YT => {
		alpha2_code => "YT",
		olson_name => "Mayotte",
		regions => {
			"" => {
				location_coords => "-1247+04514",
				olson_description => "",
				timezone_name => "Indian/Mayotte",
			},
		},
	},
	ZA => {
		alpha2_code => "ZA",
		olson_name => "South Africa",
		regions => {
			"" => {
				location_coords => "-2615+02800",
				olson_description => "",
				timezone_name => "Africa/Johannesburg",
			},
		},
	},
	ZM => {
		alpha2_code => "ZM",
		olson_name => "Zambia",
		regions => {
			"" => {
				location_coords => "-1525+02817",
				olson_description => "",
				timezone_name => "Africa/Lusaka",
			},
		},
	},
	ZW => {
		alpha2_code => "ZW",
		olson_name => "Zimbabwe",
		regions => {
			"" => {
				location_coords => "-1750+03103",
				olson_description => "",
				timezone_name => "Africa/Harare",
			},
		},
	},
};

=back

=head2 Zone data

=over

=item olson_tzfile(NAME)

Returns the pathname of the binary tzfile (in L<tzfile(5)> format)
describing the timezone named I<NAME> in the Olson database.  C<die>s if
the name does not exist in this version of the database.  The tzfile
is of at least version 2 of the format, and so does not suffer a Y2038
(32-bit time_t) problem.

=cut

my($datavol, $datadir, undef) =
	File::Spec->splitpath($INC{"Time/OlsonTZ/Data.pm"});

sub olson_tzfile($) {
	my($tzname) = @_;
	$tzname = olson_links()->{$tzname} if exists olson_links()->{$tzname};
	unless(exists olson_canonical_names()->{$tzname}) {
		croak "no such timezone `$tzname' ".
			"in the Olson @{[olson_version]} database";
	}
	my @nameparts = split(/\//, $tzname);
	my $filename = pop(@nameparts).".tz";
	return File::Spec->catpath($datavol,
		File::Spec->catdir($datadir, "Data", @nameparts), $filename);
}

=back

=head1 BUGS

The Olson timezone database probably contains errors in the older
historical data.  These will be corrected, as they are discovered,
in future versions of the database.

Because legislatures commonly change civil timezone rules, in
unpredictable ways and often with little advance notice, the current
timezone data is liable to get out of date quite quickly.  The Olson
timezone database is frequently updated to keep it accurate for current
dates.  Frequently updating installations of this module from CPAN should
keep it similarly accurate.

For the same reason, the future data in the database is liable to be
very inaccurate.  The database includes, for each timezone, the current
best guess regarding its future behaviour, usually consisting of the
current rules being left unchanged indefinitely.  (In most cases it is
unlikely that the rules will actually never be changed, but the current
rules still constitute the best guess available of future behaviour.)

Because this module is intended to be frequently updated, long-running
programs (such as clock displays) will experience the module being
updated while in use.  This can happen with any module, but is of
particular interest with this one.  The behaviour in this situation is
not guaranteed, but here is a guide to current behaviour.  The running
module code is of course not influenced by the C<.pm> file changing.
The ancillary data is all currently stored in the module code, and so
will be equally unaffected.  Tzfiles pointed to by the module, however,
will change visibly.  Newly reading a tzfile is liable to see a newer
version of the zone's data than the module's metadata suggests.  A tzfile
could also theoretically disappear, if a zone's canonical name changes
(so the former canonical name becomes a link).  To avoid weirdness,
it is recommended to read in all required tzfiles near the start of
a program's run, so that it doesn't matter if the files subsequently
change due to an update.

=head1 SEE ALSO

L<DateTime::TimeZone::Olson>,
L<DateTime::TimeZone::Tzfile>,
L<Time::OlsonTZ::Download>,
L<tzfile(5)>

=head1 AUTHOR

The Olson timezone database was compiled by Arthur David Olson, Paul
Eggert, and many others.  It is maintained by the denizens of the mailing
list <tz@elsie.nci.nih.gov>.

The C<Time::OlsonTZ::Data> Perl module wrapper for the database was
developed by Andrew Main (Zefram) <zefram@fysh.org>.

=head1 COPYRIGHT

The Olson timezone database is is the public domain.

The C<Time::OlsonTZ::Data> Perl module wrapper for the database is
Copyright (C) 2010, 2011 Andrew Main (Zefram) <zefram@fysh.org>.

=head1 LICENSE

No license is required to do anything with public domain materials.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
