#!/usr/bin/env perl
use strict;
use warnings;

use JavaScript::Writer::Function;
use Test::More tests => 1;

{
    my $jsf = JavaScript::Writer::Function->new;

    $jsf->body(sub {
                   my $js = shift;
                   $js->alert("Foo");
               }
           );
    is $jsf->as_string, qq{function(){alert("Foo");}};

}
