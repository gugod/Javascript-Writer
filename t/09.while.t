#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 1;

{
    # while(1){}
    my $js = JavaScript::Writer->new();

    $js->while(1 => sub {})

    is $js, "while(1){}", "an empty while loop";
}
