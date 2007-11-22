#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More;

plan tests => 3;

{
    my $js = JavaScript::Writer->new;
    $js->if( 1 => sub { $_[0]->alert(42) });
    is $js, "if(1){alert(42);}\n"
}

{
    my $js = JavaScript::Writer->new;
    $js->if(1 => sub { $_[0]->alert(42) })
        ->else(sub {$_[0]->alert(43)});

    is $js, "if(1){alert(42);}\nelse{alert(43);}\n"
}

{
    my $js = JavaScript::Writer->new;
    $js->if(1 => sub { $_[0]->alert(42) })
        ->elsif(2 => sub {$_[0]->alert(43)})
            ->else(sub {$_[0]->alert(44)});

    is $js, "if(1){alert(42);}\nelse if(2){alert(43);}\nelse{alert(44);}\n"
}
