use warnings;
use strict;

use Test::More tests => 2;

BEGIN { use_ok "Time::OlsonTZ::Data", qw(olson_links olson_tzfile); }

my $failures;

my $links = olson_links;

$failures = 0;
foreach(keys %$links) {
	olson_tzfile($_) eq olson_tzfile($links->{$_}) or $failures++;
}
is $failures, 0;

1;
