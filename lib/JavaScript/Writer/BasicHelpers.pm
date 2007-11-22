use strict;
use warnings;

package JavaScript::Writer::BasicHelpers;

our $VERSION = v0.0.1;
package JavaScript::Writer;

sub delay {
    my ($self, $seconds, $block) = @_;
    $self->setTimeout($block, $seconds);
}

sub closure {
    my ($self, $block) = @_;
    my $jsf = $self->function( $block );
    $self->append(";($jsf)();", delimiter => "\n");
    return $self;
}

1;

__END__

=head1 NAME

JavaScript::Writer::BasicHelpers - Basic helper methods

=head1 SYNOPSIS

=head1 METHODS

=head2 delay($n, &block)

Generate a piece of code that delays the execution of &block for $n
seconds.

=head2 closure(&block)

Generate a closure with body &block. This means to generate a
construct like this:

    ;(function(){
        // ...
    })();

It's very useful for doing functional programming in javascript.

=head1 DESCRIPTION



=cut

