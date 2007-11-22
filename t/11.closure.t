#!/usr/bin/perl

use strict;
use warnings;
use JavaScript::Writer;
use JavaScript::Writer::BasicHelpers;
use Test::More;

plan tests => 1;

{
    my $js = JavaScript::Writer->new;

    $js->closure(
        sub {
            my $js = shift;
            $js->alert( 42 );
        }
    );

    is($js->as_string(), ";(function(){alert(42);})();\n");

}
