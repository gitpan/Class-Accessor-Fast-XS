
=head1 NAME

Class::Accessor::Fast::XS - XS replacement for Class::Accessor::Fast

=head1 DESCRIPTION

This module is a XS based replacement for L<Class::Accessor::Fast>.
Just replace Class::Accessor::Fast with Class::Accessor::Fast::XS and
it should just work.

=head1 SEE ALSO

L<Class::Accessor::Fast> and L<Class::Accessor>

=cut

package Class::Accessor::Fast::XS;

use strict;
use warnings;
use base qw(Class::Accessor::Fast);

our $VERSION = '0.01';

use XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

sub make_ro_accessor {
    my($class, $field) = @_;

    my $sub = $class ."::__xs_ro_". $field;
    xs_make_ro_accessor($sub, $field);

    no strict 'refs';
    return \&{$sub};
}

sub make_wo_accessor {
    my($class, $field) = @_;

    my $sub = $class ."::__xs_wo_". $field;
    xs_make_wo_accessor($sub, $field);

    no strict 'refs';
    return \&{$sub};
}

sub make_accessor {
    my($class, $field) = @_;

    my $sub = $class ."::__xs_". $field;
    xs_make_accessor($sub, $field);

    no strict 'refs';
    return \&{$sub};
}


1;
