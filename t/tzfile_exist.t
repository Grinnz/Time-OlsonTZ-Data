use warnings;
use strict;

use Test::More tests => 2;

BEGIN { use_ok "Time::OlsonTZ::Data", qw(olson_canonical_names olson_tzfile); }

my $failures = 0;
foreach(sort keys %{olson_canonical_names()}) {
	-f olson_tzfile($_) or $failures++;
}
is $failures, 0;

1;
