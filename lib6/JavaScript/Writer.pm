
class JavaScript::Writer-0.0.1 {
    has @!statements;

    method call($function, @args) {
        @!statements.push({
            call => $function,
            args => @args
        })
    }

    method append($code) {
        @!statements.push({ code => $code })
    }

    method as_string {
        my $ret = "";
        for @!statements -> my %s {
            if (%s{'call'}) {
                # Should use JSON.
                my $args = %s{'args'}.join(",");
                $ret ~= %s{'call'} ~ "(\"$args\");";
            }
            elsif (%s{'code'}) {
                $ret ~= "%s{code};"
            }
        }
        return $ret;
    }
}

