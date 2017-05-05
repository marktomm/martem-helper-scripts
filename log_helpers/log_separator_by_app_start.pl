#!/usr/bin/perl

undef $/;
$_ = <>;
$n = 0;

for $match (split(/(?=Config file\: )/)) {
      open(O, '>app_start' . ++$n);
      print O $match;
      close(O);
} 
