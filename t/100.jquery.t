#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use JavaScript::Writer::jQueryHelper;

use Test::More;

plan tests => 7;

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

{
    js->new;

    jQuery('#foo')->click(
        sub {
            js->alert(\ "Nihao");
        }
    );

    is(
        js->as_string,
        q{jQuery("#foo").click(function(){alert("Nihao");});},
        "with jQuery( selector ) from jQueryHelper"
    )
}

{
    js->new;

    jQuery->get(
        \ "foo.json",
        sub {
            js->alert(\ "Nihao");
        }
    );

    js->alert(42);

    is(
        js->as_string,
        q{jQuery.get("foo.json",function(){alert("Nihao");});alert(42);},
        "with jQuery from jQueryHelper"
    )
}

{
    js->new;

    my $cb = js->function(sub {
                              js->alert(\ "Nihao");
                          });

    jQuery->ajax({
        url => "foo.json",
        success => $cb
    });

    js->alert(42);

    is(
        js->as_string,
        'jQuery.ajax({"success":function(){alert("Nihao");},"url":foo.json});alert(42);',
        "with jQuery from jQueryHelper"
    )
}
