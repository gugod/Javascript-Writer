#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More tests => 2;

my $page = JavaScript::Writer->new;
$page->call("alert", "Nihao");


is($page->as_string(), 'alert("Nihao");' );

$page->append('confirm("Nihao")');
is($page->as_string(), 'alert("Nihao");confirm("Nihao");' );
