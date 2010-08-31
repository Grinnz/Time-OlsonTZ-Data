use warnings;
use strict;

use Test::More tests => 2;

BEGIN { use_ok "Time::OlsonTZ::Data", qw(olson_version); }

like olson_version(), qr/\A[0-9]{4}[a-z]\z/;

1;
