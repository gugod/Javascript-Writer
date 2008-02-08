#!/usr/bin/perl

use strict;
use warnings;
use JavaScript::Writer;
use JavaScript::Writer::BasicHelpers;
use Test::More;

plan tests => 3;

{
    my $js = JavaScript::Writer->new;

    $js->closure(
        sub {
            my $js = shift;
            $js->alert( 42 );
        }
    );

    is($js->as_string(), ";(function(){alert(42);})();");
}

{
    my $js = JavaScript::Writer->new;

    $js->closure(
        parameters => {
            obj => 42
        },
        body => sub {
            my $js = shift;
            $js->alert("obj");
        }
    );

    is($js->as_string(), ";(function(obj){alert(obj);})(42);");
}

{
    my $js = JavaScript::Writer->new;

    $js->closure(
        this => "el",
        parameters => {
            msg => \ "Hello, World"
        },
        body => sub {
            my $js = shift;
            $js->jQuery("this")->html("msg")
        }
    );

    is(
        $js->as_string(),
        ';(function(msg){jQuery(this).html(msg);}).call(el,"Hello, World");'
    );

}
