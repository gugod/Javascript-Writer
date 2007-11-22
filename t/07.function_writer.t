#!/usr/bin/env perl
use strict;
use warnings;

use JavaScript::Writer::Function;
use Test::More tests => 3;

{
    my $jsf = JavaScript::Writer::Function->new;

    $jsf->body(sub {
                   my $js = shift;
                   $js->alert("Foo");
               }
           );
    is $jsf->as_string, qq{function(){alert("Foo");}};

}

{
    my $jsf = JavaScript::Writer::Function->new;

    $jsf->body(sub {
                   my $js = shift;
                   $js->alert("Foo");
                   print "123\n";
               }
           );
    is $jsf->as_string, qq{function(){alert("Foo");}};
}

{
    my $jsf = JavaScript::Writer::Function->new;

    $jsf->body(sub {
                   my $js = shift;
                   $js->alert("Foo");
                   $js->return(1);
               }
           );
    is $jsf->as_string, qq{function(){alert("Foo");return(1);}};
}
