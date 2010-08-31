use warnings;
use strict;

BEGIN {
	eval { require IO::File; IO::File->VERSION(1.03); };
	if($@ ne "") {
		require Test::More;
		Test::More::plan(skip_all => "no IO::File");
	}
}

use Test::More tests => 2;

BEGIN { use_ok "Time::OlsonTZ::Data", qw(olson_canonical_names olson_tzfile); }

my $failures = 0;
foreach(sort keys %{olson_canonical_names()}) {
	my $h = IO::File->new(olson_tzfile($_), "r") or $failures++;
	local $/ = \5;
	$h->getline eq "TZif2" or $failures++;
}
is $failures, 0;

1;
