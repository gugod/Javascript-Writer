package JavaScript::Writer;

use warnings;
use strict;
use v5.8.0;
use overload
    '<<' => \&append,
    '""' => \&as_string;

use JSON::Syck;

our $VERSION = '0.0.7';

sub new {
    my $class = shift;
    if (ref $class) {
        return __PACKAGE__->new;
    }
    my $self = bless {}, $class;
    $self->{statements} = [];
    return $self;
}

sub call {
    my ($self, $function, @args) = @_;
    push @{$self->{statements}},{
        object => $self->{object} || undef,
        call => $function,
        args => \@args,
        end_of_call_chain => (!defined wantarray)
    };
    delete $self->{object};
    return $self;
}

sub append {
    my ($self, $code, @xs) = @_;
    push @{$self->{statements}}, { code => $code, @xs };
    return $self;
}

sub end {
    my $self = shift;
    my $last = $self->{statements}[-1];
    $last->{end_of_call_chain} = 1;
    return $self;
}

sub object {
    my ($self, $object) = @_;
    $self->{object} = $object;
    return $self;
}


use JavaScript::Writer::Var;

sub var {
    my ($self, $var, $value) = @_;
    my $s = "";
    if (defined $value) {
        if (ref($value) eq 'ARRAY' || ref($value) eq 'HASH' || !ref($value) ) {
            $s = "var $var = " . JSON::Syck::Dump($value) . ";"
        }
        elsif (ref($value) eq 'CODE') {
            $s = "var $var = " . $self->function($value);
        }
        elsif (ref($value) =~ '^JavaScript::Writer') {
            $s = "var $var = " . $value->as_string();
        }
    }
    else {
        $s = "var $var;";
    }
    $self->append($s);

    if (ref $value eq 'SCALAR') {
        my $v = JavaScript::Writer::Var->new(
            $value,
            {
                name => $var,
                jsw  => $self
            }
        );
        if (defined $$value) {
            my $s = "var $var = " . JSON::Syck::Dump($$value) . ";";
            $self->append($s);
        }
        else {
            my $s = "var $var;";
            $self->append($s);
        }
        return $v;
    }
}

use JavaScript::Writer::Block;

sub while {
    my ($self, $condition, $block) = @_;
    my $b = JavaScript::Writer::Block->new;
    $b->body($block);
    $self->append("while(${condition})${b}")
}

sub if {
    my ($self, $condition, $block) = @_;
    my $b = JavaScript::Writer::Block->new;
    $b->body($block);
    $self->append("if(${condition})${b}", delimiter => "\n")
}

sub elsif {
    my ($self, $condition, $block) = @_;
    my $b = JavaScript::Writer::Block->new;
    $b->body($block);
    $self->append("else if(${condition})${b}", delimiter => "\n");
}

sub else {
    my ($self, $block) = @_;
    my $b = JavaScript::Writer::Block->new;
    $b->body($block);
    $self->append("else${b}", delimiter => "\n");
}

use JavaScript::Writer::Function;

sub function {
    my ($self, $sub) = @_;
    my $jsf = JavaScript::Writer::Function->new;
    $jsf->body($sub);
    return $jsf;
}

sub as_string {
    my ($self) = @_;
    my $ret = "";

    for (@{$self->{statements}}) {
        if (my $f = $_->{call}) {
            my $delimiter = $_->{delimiter} ||
                ($_->{end_of_call_chain} ? ";" : ".");
            my $args = $_->{args};
            $ret .= ($_->{object} ? "$_->{object}." : "" ) .
                "$f(" .
                    join(",",
                         map {
                             if (ref($_) eq 'CODE') {
                                 $self->function($_)
                             }
                             else {
                                 JSON::Syck::Dump $_
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

sub as_html {
    my $self = shift;
    qq{<script type="text/javascript">$self</script>}
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $function = $AUTOLOAD;
    $function =~ s/.*:://;

    return $self->call($function, @_);
}


sub FETCH {
    my ($self, $obj) = @_;
    $self->{object} = $obj;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

JavaScript::Writer - JavaScript code generation from Perl.

=head1 SYNOPSIS

    use JavaScript::Writer;

    my $js = JavaScript::Writer->new;

    # Call alert("Nihao")
    $js->call("alert", "Nihao");

    # Similar, but display Perl-localized message of "Nihao". (that might be "哈囉")
    $js->call("alert", _("Nihao") );

    # Overload

=head1 DESCRIPTION

As you can see, this module is trying to simulate what RJS does. It's
meant to be used in some web app framework, or for those who are
generate javascript code from perl data.

It requires you loaded several javascript librarys in advance, then
use its C<call> method to call a certain functions from your library.

=head1 INTERFACE

=over

=item new()

Object constructor. Takes nothing, gives you an javascript writer
object. It can be called as a class method, or an object method.
However, calling it on objects does not imply cloning the original
object, but just a shorthand because typing package name is always
longer.

=item call( $function, $arg1, $arg2, $arg3, ...)

Call an javascript function with arguments. Arguments are given in
perl's native form, you don't need to use L<JSON> module to serialized
it first.  (Unless, of course, that's your purpose: to get a JSON
string in JavaScript.)


=item var( $name, [ $value ] )

Declare a value named $name with a optional default value $value.
$value could be an arrayref, hashref, or scalar.


=item var( $name, \$your_var )

Another form of calling var. Please notice that the second argument
must be a scalar reference.

This let you tie a Perl scalar into a javascript variable. Further
assignments on that Perl scalar will directly effect the output of your
javasciprt writer objcet. For example:

    my $a;
    my $js = JavaScript::Writer->new;
    $js->var(ans => \$a);
    $a = 42;

    print $js->as_string;
    # "var a;a = 42;"

Or something like this;

    my $js = JavaScript::Writer->new;
    my $a;
    $js->var(ans => \$a);

    my $a = $js->new->myAjaxGet("/my/foo.json")->end();
    print $js->as_string;
    # var a;a = myAjaxGet("/my/foo.json");

=item end()

Assert an end of call chain. Calling this is required if you're
calling $js methods at the right side of an assignment. Like:

    my $a = $js->new->somefunc("foobar")->end();

Please also refer to the example code in the description of C<var>
method.

=item object( $object )

Give the object name for next function call. The preferred usage is:

    $js->object("Widget.Lightbox")->show("Nihao")

Which will then generated this javascript code snippet:

    Widget.Lightbox.show("Nihao")


=item while( $condition => $code_ref )

C<$condition> is a string (yes, just a string for now) of javascript
code, and a $code_ref is used to generate the block required for this
while block.

The output of 'while' statement look like this:

    while($condition) {
        $code
    }

=item if ( $codnition => $code_ref )

=item elsif ( $codnition => $code_ref )

=item else ( $code_ref )

These 3 methods forms a trinity to construct the if..elsif..else form
of control structure. Of course, in JavaScript, it it's not called
"elsif", but "else if". But hey, we're Perl people.

The arguements are pretty similar to C<while> method. But these
function use newline characters to deliminate them from others rather
then using ";".  That's the major difference between them and all
other methods.

=item function( $code_ref )

This is a javascript function writer. It'll output something like this:

    function(){...}

The passed $code_ref is a callback to generate the function
body. It'll be passed in a JavaScript::Writer object so you can use it
to write more javascript statements. Here defines a function that
simply slauts to you.

    my $js = JavaScript::Writer->new;
    my $f = $js->function(sub {
        my $js = shift;
        $js->alert("Nihao")
    })

The returned $f is a L<JavaScript::Writer::Function> object that
stringify to this string:

    function(){alert("Nihao")}

=item append( $statement )

Manually append a statement. With this function, you need to properly
serialize everything to JSON. Make sure you now that what you're
doing.

=item as_string()

Output your statements as a snippet of javascript code.

=item as_html()

Output your javascript statements as a snippet with a <script> tag.

=back

=head1 CONFIGURATION AND ENVIRONMENT

JavaScript::Writer requires no configuration files or environment variables.

=head1 DEPENDENCIES

L<Class::Accessor::Fast>

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
