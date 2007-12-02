#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 6;

{
    my $js = JavaScript::Writer->new();

    $js->var(a => 1);

    is $js, "var a = 1;", "variable assignment in perl can be written as javascript.";
}


{
    my $js = JavaScript::Writer->new();

    my $a = 1;
    $js->var(a => \$a);

    is $js, "var a = 1;", "variable initialize in perl can be written as javascript.";
}

{
    my $js = JavaScript::Writer->new();

    my $a;

    $js->var(a => \$a);
    $a = 1;

    is $js, "var a;a = 1;", "variable assignment in perl can be written as javascript.";
}


{
    my $js = JavaScript::Writer->new();

    my $a = 1;

    $js->var(a => \$a);
    $a = 42;

    is $js, "var a = 1;a = 42;", "variable assignment in perl can be written as javascript.";
}

SKIP: {
    skip "This feels quit difficult with tie.. ", 1;

    my $js = JavaScript::Writer->new();
    my $a = 1;
    my $b = 41;
    $js->var(a => \$a);
    $js->var(b => \$b);
    $a = $a + $b;
    is $js, "var a = 1;var b = 41;a = a + b;";
}

{
    my $js = JavaScript::Writer->new();

    my $a;
    $js->var(a => \$a);
    $a = $js->new->somefunc("/foo/bar")->end;

    is $js, 'var a;a = somefunc("/foo/bar");';
}
