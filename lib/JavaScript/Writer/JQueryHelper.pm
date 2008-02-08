use strict;
use warnings;

package JavaScript::Writer::JQueryHelper;

our $VERSION = v0.0.1;
package JavaScript::Writer;

sub jQuery {
    my ($self, $arg) = @_;
    if (ref($arg) eq '') {
        return $self->call('jQuery', \ $arg);
    }
    return $self->call('jQuery', $arg);
}

1;

__END__

=head1 NAME

JavaScript::Writer::JQueryHelper - Helper methods powered by jQuery.

=head1 SYNOPSIS

=head1 METHODS

=head1 DESCRIPTION



=cut

