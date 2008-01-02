package JavaScript::Writer::Base;
use strict;
use warnings;
use self;
use overload
    '<<' => \&append,
    '""' => \&as_string;

use JSON::Syck;

sub new {
    if (ref(self) ne __PACKAGE__) {
        my $self = bless { args }, self;
        $self->{statements} = [];
        return $self;
    }

    self->{statements} = [];
    return self;
}

sub call {
    my ($function, @args) = args;
    push @{self->{statements}},{
        object => self->{object} || undef,
        call => $function,
        args => \@args,
        end_of_call_chain => (!defined wantarray)
    };
    delete self->{object};
    return self;
}

sub append {
    my ($code, @xs) = args;
    push @{self->{statements}}, { code => $code, @xs };
    return self;
}

sub end {
    my $last = self->{statements}[-1];
    $last->{end_of_call_chain} = 1;
    return self;
}

sub object {
    my ($object) = args;
    self->{object} = $object;
    return self;
}

require JavaScript::Writer::Function;

sub latter {
    my ($cb) = args;

    my $timeout = self->{target};
    $timeout =~ s/ms$//;
    $timeout =~ s/s$/000/;

    my $jsf = JavaScript::Writer::Function->new;
    $jsf->body($cb);
    my $func_as_string = $jsf->as_string;

    self->append(
        "setTimeout($func_as_string, $timeout)",
        end_of_call_chain => 1
    );
    return self;
}

sub as_string {
    my $ret = "";
    for (@{self->{statements}}) {
        if (my $f = $_->{call}) {
            my $delimiter = $_->{delimiter} ||
                ($_->{end_of_call_chain} ? ";" : ".");
            my $args = $_->{args};
            $ret .= ($_->{object} ? "$_->{object}." : "" ) .
                "$f(" .
                    join(",",
                         map {
                             if (ref($_) eq 'CODE') {
                                 self->function($_)
                             }
                             else {
                                 JSON::Syck::Dump($_)
                             }
                         } @$args
                     ) . ")" . $delimiter
        }
        elsif (my $c = $_->{code}) {
            my $delimiter = $_->{delimiter} || ";";
            $c .= $delimiter
                unless $c =~ /$delimiter\s*$/s;
            $ret .= $c;
        }
    }
    return $ret;
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $function = $AUTOLOAD;
    $function =~ s/.*:://;
    return self->call($function, args);
}

1;
