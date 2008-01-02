#!/usr/bin/env perl

use strict;
use warnings;

use JavaScript::Writer;
use Test::More;

plan tests => 5;

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

{
    js->new->let(a => "foo", b => 3);
    is js->as_string, q{var a = "foo";var b = 3;};
}

{
    js->new->let(a => sub { $_[0]->alert(42); });
    is js->as_string, q{var a = function(){alert(42);};};
}
