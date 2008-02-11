package Test::JE;
use strict;
use warnings;
use JE;
use Test::More;
use self;

sub new {
    my $class = shift;
    my $self = {};
    $self->{je} = JE->new;
    $self->{je}->new_function(alert => sub{});
    $self->{je}->new_function(confirm => sub{});
    return bless $self, $class;
}

sub eval {
    self->{je}->eval(args);
}

sub eval_ok {
    my ($str) = args;
    self->{je}->eval($str);
    if ($@) { diag($@) }
    ok( !$@ );
}

1;
