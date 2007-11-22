#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 1;

{
    my $js = JavaScript::Writer->new;
    $js->object("Widget.Lightbox")->call("show", "Nihao");

    is $js->as_string(), 'Widget.Lightbox.show("Nihao");'
}
