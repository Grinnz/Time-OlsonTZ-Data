use warnings;
use strict;

BEGIN {
	eval {
		require DateTime::TimeZone::Tzfile;
		DateTime::TimeZone::Tzfile->VERSION(0.004);
	};
	if($@ ne "") {
		require Test::More;
		Test::More::plan(skip_all => "no DateTime::TimeZone::Tzfile");
	}
}

use Test::More tests => 2;

BEGIN { use_ok "Time::OlsonTZ::Data", qw(olson_canonical_names olson_tzfile); }

my $failures = 0;
foreach(sort keys %{olson_canonical_names()}) {
	DateTime::TimeZone::Tzfile->new(olson_tzfile($_)) or $failures++;
}
is $failures, 0;

1;
