use strict;
use warnings;

package JavaScript::Writer::jQueryHelper;

our $VERSION = '0.0.2';

use JavaScript::Writer;

use Sub::Exporter -setup => {
    exports => ['jQuery'],
    groups  => {
        default =>  [ -all ],
    }
};

sub jQuery {
    my ($selector) = @_;
    if (!defined $selector) {
        return js->object('jQuery')
    }
    elsif (ref($selector) eq '') {
        return js->call('jQuery', \ $selector);
    }
}

1;

__END__

=head1 NAME

JavaScript::Writer::JQueryHelper - Helper methods powered by jQuery.

=head1 SYNOPSIS

=head1 METHODS

=head1 DESCRIPTION



=cut

