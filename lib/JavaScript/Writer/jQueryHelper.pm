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
    my $js = JavaScript::Writer::_js;
    my $selector = shift;

    my $s = ref($selector) ? $selector : \$selector;

    if (defined $js) {
        return $js->jQuery( $s ) if defined $selector;;
        return $js->object('jQuery');
    }

    return js->jQuery($s) if defined $selector;
    return js->object('jQuery');
}

1;

__END__

=head1 NAME

JavaScript::Writer::JQueryHelper - Helper methods powered by jQuery.

=head1 SYNOPSIS

=head1 METHODS

=head1 DESCRIPTION



=cut

