package JavaScript::Writer::Var;
use strict;
use warnings;

our $VERSION = '0.0.1';

use self;
use JSON::Syck;

sub new {
    my ($class, $ref, $params) = @_;
    tie $$ref, $class, $$ref, $params;
    return $$ref;
}

sub TIESCALAR {
    my ($class, $value, $params) = @_;
    return bless {
        %$params,
        value => $value
    }, $class;
}

sub STORE {
    self->{value} = (args)[0];

    unless (self->{name}) {
        die("Doing assignment on an anonymous variable ? That's not going to work");
    }
    my $v = "";
    if (ref(self->{value}) =~ (/^JavaScript::Writer/)) {
        $v = self->{value}->as_string;
    }
    else {
        $v = JSON::Syck::Dump( self->{value} );
    }

    $v =~ s/;?$/;/;
    my $s = self->{name} . " = $v" ;
    self->{jsw}->append($s);
}

sub FETCH {
    self->{value};
}


1;

