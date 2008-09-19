#!/usr/bin/perl


package CAF;

BEGIN {
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_ro_accessors('ro');
__PACKAGE__->mk_wo_accessors('wo_one', 'wo_multi');
__PACKAGE__->mk_accessors('both');
}

package CAFXS;

BEGIN {
use base qw(Class::Accessor::Fast::XS);
__PACKAGE__->mk_ro_accessors('ro');
__PACKAGE__->mk_wo_accessors('wo_one', 'wo_multi');
__PACKAGE__->mk_accessors('both');
}

package Dummy;

package DummySub;

sub ro { return $_[0]->{'ro'} }
sub wo_one { return $_[0]->{'wo_one'} = $_[1] }
sub wo_multi { return (shift)->{'wo_multi'} = [@_] }
sub both {
    return $_[0]->{'both'} if @_ == 1;
    return $_[0]->{'both'} = $_[1];
}

package main;

use warnings FATAL => 'all';
use strict;
use Benchmark qw(cmpthese);

my @arr = (0..3);

my $caf = CAF->new({ro => 'foo'});
my $cafxs = CAFXS->new({ro => 'foo'});
my $dummy = bless { ro => 'foo' }, 'Dummy';
my $dummy_sub = bless { ro => 'foo' }, 'DummySub';


my $t = -1;

cmpthese($t, {
	get_caf => sub { $caf->ro },
	get_caf_xs => sub { $cafxs->ro },
	get_dummy_ha => sub { $dummy->{'ro'} },
	get_dummy_sub => sub { $dummy_sub->ro },
});

cmpthese($t, {
	set_one_caf => sub { $caf->wo_one('new') },
	set_one_caf_xs => sub { $cafxs->wo_one('new') },
	set_one_dummy_ha => sub { $dummy->{'wo_one'} = 'new' },
	set_one_dummy_sub => sub { $dummy_sub->wo_one('new') },
});

cmpthese($t, {
	set_multi_caf => sub { $caf->wo_multi('foo', 'bar') },
	set_multi_caf_xs => sub { $cafxs->wo_multi('foo', 'bar') },
	set_multi_dummy_ha => sub { $dummy->{'wo_multi'} = ['foo', 'bar'] },
	set_multi_dummy_sub => sub { $dummy_sub->wo_multi('foo', 'bar') },
});

cmpthese($t, {
	mix_caf => sub { $caf->both('new'); my $v = $caf->both; $v = $caf->both; },
	mix_caf_xs => sub { $cafxs->both('new'); my $v = $cafxs->both; $v = $cafxs->both; },
	mix_dummy_ha => sub { $dummy->{'both'} = 'new'; my $v = $dummy->{'both'}; $v = $dummy->{'both'} },
	mix_dummy_sub => sub { $dummy_sub->both('new'); my $v = $dummy_sub->both; $v = $dummy_sub->both },
});
