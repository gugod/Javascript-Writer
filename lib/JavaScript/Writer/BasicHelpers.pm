use strict;
use warnings;

package JavaScript::Writer::BasicHelpers;

our $VERSION = '0.0.2';

package JavaScript::Writer;

sub delay {
    my ($self, $seconds, $block) = @_;
    $self->setTimeout($block, $seconds);
}

sub closure {
    my $self = shift;

    my %args;
    if (ref($_[0]) eq 'CODE') {
        $args{body} = $_[0];
    }
    else {
        %args = @_;
    }
    my $params = delete $args{parameters};

    my (@arguments, @values);
    while(my ($name, $value) = each %$params) {
        push @arguments, $name;
        push @values, $value;
    }
    my $jsf = $self->function(
        body => $args{body},
    );
    $jsf->arguments(@arguments);

    my $argvalue = $_;
    if (defined $args{this}) {
        $self->call(";($jsf).call", $args{this}, @values);
    }
    else {
        $self->call(";($jsf)", @values);
    }

    return $self;
}

1;

__END__

=head1 NAME

JavaScript::Writer::BasicHelpers - Basic helper methods

=head1 DESCRIPTION

This module inject several nice helper methods into JavaScript::Writer
namespace. It helps to make your Perl code shorter, (hopefully) less
painful.

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


=head2 closure(arguments => { name => value }, body => sub {... }, ...)

Another form of the closure function. For example:

  js->closure(
      parameters => {
          el => "document.getElementById('foo')",
          var1 => "var1",
          var2 => \ "var 2 value"
      },
      body => sub {
          ...
      }
  );

This generates something like this:

    ;(function(el, var1, var2){
        ...
    })(document.getElementById('foo'), var1, "var 2 value");

The value to the key "parameters" is a hashref, which means the order
of function arguments is not guarenteed. But that shouldn't matter at
all because they are all named. They have to be named anyway.

The value to the key "this" refers to te value of "this" variable in
the closure. For example:

  js->closure(
      this => "el",
      parameters => { msg => \ "Hello, World" }
      body => sub {
        js->jQuery("this")->html("msg");
      }
  );

This generates

    ;(function(msg){
        jQuery(this).html(msg);
    }).call(el, "Hello, World");

=head1 AUTHOR and LICENSE

See L<JavaScript::Writer>

=cut

