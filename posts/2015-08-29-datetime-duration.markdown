---
title: A DateTime::Duration surprising feature
tags: perl, programming
---

Here a surprising feature in [DateTime::Duration]()'s API.
What this code will print?

~~~~ perl
use strict;
use warnings;

use DateTime;
use DateTime::Duration;

my $dt1 = DateTime->new( year => 2015, month => 8, day => 1 );
my $dt2 = DateTime->new( year => 2015, month => 8, day => 31 );

my $duration = $dt1->delta_days( $dt2 );
print $duration->days();
~~~~

It prints `2`, because the `days()` method is implemented as

~~~~ perl
abs( ($duration->in_units( 'days', 'weeks' ) )[0] )
~~~~

meaning that the duration is **first converted to weeks**, then the
remainder is returned.

Here an extended piece of code to show what happens:

~~~~ perl
use strict;
use warnings;

use DateTime;
use DateTime::Duration;

my $dt1 = DateTime->new( year => 2015, month => 8, day => 1 );

foreach my $d ( 2 .. 31 ) {
  my $dt2 = DateTime->new( year => 2015, month => 8, day => $d );
  my $duration = $dt1->delta_days( $dt2 );
  printf "%s days and %s weeks\n", $duration->in_units( 'days', 'weeks' );
}
~~~~

which prints:

~~~~
2 days and 0 weeks
3 days and 0 weeks
4 days and 0 weeks
5 days and 0 weeks
6 days and 0 weeks
0 days and 1 weeks
1 days and 1 weeks
2 days and 1 weeks
… and so forth
~~~~

If you want to know how many days there are between two given dates,
better be explicit and use `$duration->in_units('days')`.

The doc explains it clearly if you take the time to read it:

> These methods return numbers indicating how many of the given unit
> the object represents, after having done a conversion to any larger
> units.

But it's baffling to me nonetheless.
