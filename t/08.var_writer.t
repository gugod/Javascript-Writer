#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 4;

{
    # var a;
    my $js = JavaScript::Writer->new();

    $js->var('a');

    is $js, "var a;", "variable declarition";
}

{
    # var a = 1;
    my $js = JavaScript::Writer->new();

    $js->var(a => 1);

    is $js, "var a = 1;", "Scalar assignment";
}

{
    # var a = [ ... ]
    my $js = JavaScript::Writer->new();

    $js->var(a => [ 1, 3, 5, 7, 9 ]);

    is $js, 'var a = [1,3,5,7,9];', "Array assignment";
}

{
    # var a = { ... }
    my $js = JavaScript::Writer->new();
    $js->var(a => { Lorem => 'Ipsum', 'Foo' => 0 });
    is $js, 'var a = {"Foo":0,"Lorem":"Ipsum"};', "Hash assignment";
}
