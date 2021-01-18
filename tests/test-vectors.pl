#!/usr/bin/perl
#
# -- jordan hrycaj <jordan@mjh-it.com>
#
# $Id$
#

use Digest::JHash qw (jhash) ;

for my $s (@ARGV) {
    print "(\"$s\", " . sprintf "%#08xu64),\n", jhash $s ;
}

1;
