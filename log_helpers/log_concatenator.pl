#!/usr/bin/perl

use Archive::Extract;
my @files = <*.tar.xz>;
foreach my $file (@files) {
  Archive::Extract->new( archive => $file )->extract();
}

if ( -d "tmp" ) {
  use File::Copy;
  my @files = <*.log>;
  foreach my $file (@files) {
    copy("$file", "tmp");
  }
}

if ( -d "tmp" ) {
  chdir("tmp");
}

use Date::Parse;
my @files = <console*>;
my %hash = ();
foreach my $file (@files) {
  open my $it_file, '<', "$file"; 
  my $firstLine = <$it_file>; 
  my $timestamp = substr($firstLine, 0, 19);
  $hash{$file} = str2time($timestamp);
  close $it_file;
}
 
my @counts = ();
open concat_log, '> console_log_concat.log';
foreach my $filename (sort { $hash{$a} <=> $hash{$b} } keys %hash) {
    if (not exists $counts{$hash{$filename}}) {
      open tmp_file, '<', "$filename";
      print concat_log <tmp_file>;
      close(tmp_file);
    }
    $counts{$hash{$filename}}++;
}
