#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 3;

{
    my $js = JavaScript::Writer->new;
    $js->if( 1 => sub { $_[0]->alert(42) });
    is $js, "if(1){alert(42);};"
}

TODO:
{
    local $TODO = "not implemented yet";

    my $js = JavaScript::Writer->new;
    $js->if(
        1 => sub { $_[0]->alert(42) },
        else => sub {$_[0]->alert(43)}
    );
    is $js, "if(1){alert(42);}else{alert(43);};"
}

{
    local $TODO = "not implemented yet";

    my $js = JavaScript::Writer->new;
    $js->if(
        1 => sub { $_[0]->alert(42) },
        elsif => { 2 => sub {$_[0]->alert(43)} },
        else => sub {$_[0]->alert(44)}
    );
    is $js, "if(1){alert(42);}elsif(2){alert(43);}else{alert(43);};"
}
