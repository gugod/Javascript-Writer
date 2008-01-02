#!/usr/bin/env perl

use strict;
use warnings;

use JavaScript::Writer;
use Test::More;

plan tests => 3;

{
    js("3s")->latter(
        sub {
            $_[0]->alert(42);
        }
    );

    is js->as_string, "setTimeout(function(){alert(42);}, 3000);"
};

{
    js->alert(42);
    js->new->alert(43);

    is js->as_string, "alert(43);"
};

{
    js->alert(42);
    js->new;
    js->alert(43);

    is js->as_string, "alert(43);"
};
