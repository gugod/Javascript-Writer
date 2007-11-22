use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/JavaScript/Writer.pm';

build_requires  'Test::More'        => '0.42';

WriteAll;


