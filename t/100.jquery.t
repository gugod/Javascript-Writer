#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;

use Test::More;

plan tests => 4;

my $wanted = 'jQuery("#foo").bar();';

{
    my $js = JavaScript::Writer->new;
    $js->call('jQuery',\ "#foo")->bar();

    is $js->as_string(), $wanted, "Used chained calls"
}

{
    my $js = JavaScript::Writer->new;
    $js->object('jQuery("#foo")')->bar();

    is $js->as_string(), $wanted, "call() on object()"
}

{
    my $js = JavaScript::Writer->new;

    $js->jQuery(\ "#foo")->bar();

    is $js->as_string(), $wanted, "chained autoloaded calls"
}

{
    my $js = JavaScript::Writer->new;
    $js->jQuery(\ "#foo")->click(
        sub {
            my $js = shift;
            $js->alert(\ "Nihao")
        }
    );

    is(
        $js->as_string,
        q{jQuery("#foo").click(function(){alert("Nihao");});},
        "It can write a jQuery with callback."
    )
}
