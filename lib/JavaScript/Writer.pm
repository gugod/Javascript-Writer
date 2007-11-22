package JavaScript::Writer;

use warnings;
use strict;
use v5.8.0;
use base 'Class::Accessor::Fast';
use overload
    '<<' => \&append,
    '""' => \&as_string;

__PACKAGE__->mk_accessors qw(statements);

our $VERSION = '0.0.1';

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->statements([]);
    return $self;
}

sub call {
    my ($self, $function, @args) = @_;
    push @{$self->statements},{ call => $function, args => \@args }
}

sub append {
    my ($self, $code) = @_;
    push @{$self->statements}, {
        code => $code
    }
}

use UNIVERSAL::to_json;

sub as_string {
    require YAML;
    my ($self) = @_;
    my $ret = "";
    for (@{$self->statements}) {
        if (my $f = $_->{call}) {
            my $args = $_->{args};
            $ret .= "$f(" . join(",", map { $_->to_json } @$args ) . ");";
        }
        elsif (my $c = $_->{code}) {
            $c .= ";" unless $c =~ /;\s*$/s;
            $ret .= $c;
        }
    }
    return $ret;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

JavaScript::Writer - JavaScript code generation from Perl.

=head1 VERSION

This document describes JavaScript::Writer version 0.0.1

=head1 SYNOPSIS

    use JavaScript::Writer;

    my $js = JavaScript::Writer->new;

    # Call alert("Nihao")
    $js->call("alert", "Nihao");

    # Similar, but display localized message of "Nihao". (that might be "哈囉")
    $js->call("alert", _("Nihao") );

=head1 DESCRIPTION

As you can see, this module is trying to simulate what RJS does. It's
meant to be used in some web app framework, or for those who are
generate javascript code from perl data.

It requires you loaded several javascript librarys in advance, then
use its C<call> method to call a certain functions from your library.

=head1 INTERFACE

=over

=item new()

Object constructor. Takes nothing, gives you an javascript writer object.

=item call( $function, $arg1, $arg2, $arg3, ...)

Call an javascript function with arguments. Arguments are given in
perl's native form, you don't need to use L<JSON> module to serialized
it first.  (Unless, of course, that's your purpose: to get a JSON
string in JavaScript.)

=item append( $statement )

Manually append a statement. With this function, you need to properly
serialize everything to JSON. Make sure you now that what you're
doing.

=item as_string()

Output your statements as a snippet of javascript code.

=back

=head1 CONFIGURATION AND ENVIRONMENT

JavaScript::Writer requires no configuration files or environment variables.

=head1 DEPENDENCIES

L<Class::Accessor::Fast>, L<UNIVERSAL::to_json>

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-javascript-writer@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Kang-min Liu  C<< <gugod@gugod.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Kang-min Liu C<< <gugod@gugod.org> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
