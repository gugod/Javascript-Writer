#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 3;

my $wanted = 'jQuery("#foo").bar();';

diag qq{Several ways to write: $wanted };

{
    my $js = JavaScript::Writer->new;
    $js->call('jQuery',"#foo")->bar();

    is $js->as_string(), $wanted, "Used chained calls"
}

{
    diag "One way to write jquery";
    my $js = JavaScript::Writer->new;
    $js->object('jQuery("#foo")')->bar();

    is $js->as_string(), $wanted, "call() on object()"
}

{
    diag "The other";
    my $js = JavaScript::Writer->new;

    $js->jQuery("#foo")->bar();

    is $js->as_string(), $wanted, "chained autoloaded calls"
}
