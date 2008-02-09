#!/usr/bin/env perl

use strict;
use warnings;
use JavaScript::Writer;
use Test::More tests => 3;

my $page = JavaScript::Writer->new;
$page->call("alert", 'Nihao');

is($page->as_string(), 'alert("Nihao");' );

$page->call(confirm => "Nihao");

is($page->as_string(), 'alert("Nihao");confirm("Nihao");' );

is($page->as_html(), '<script type="text/javascript">alert("Nihao");confirm("Nihao");</script>');
