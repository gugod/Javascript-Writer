#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 3;

# Assignments
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

    is $js, 'var a = {"Lorem":"Ipsum","Foo":"0"};', "Hash assignment";
}
