#!/usr/bin/perl
use strict;
use warnings;
use 5.20.2;

open my $file_m, '<', $ARGV[0] or die "Невозможно открыть файл: $!\n";
open my $file_w, '<', $ARGV[1] or die "Невозможно открыть файл: $!\n";

mkdir "regions_stat";
my $num_str_m;
my @num_str_array_m;
my @all_str_m;

while(my $line=<$file_m>)
{
	chomp $line;
	if ($line=~/^0,/)
	{
		push(@num_str_array_m, $num_str_m);
	}
	$num_str_m++;
	push(@all_str_m, $line);
}

close $file_m;

my $num_str_w;
my @num_str_array_w;
my @all_str_w;

while(my $line=<$file_w>)
{
	chomp $line;
	if ($line=~/^0,/)
	{
		push(@num_str_array_w, $num_str_w);
	}
	$num_str_w++;
	push(@all_str_w, $line);
}

close $file_w;

foreach $a (@num_str_array_m)
{
	$_=$all_str_m[$a-5];
	s/.*[ \t\n]*$//;
	s/ /\\ /;
	s/,//;
	my $b=join( '/' => ("regions_stat",  $_, "full", "man/"));
	my $c=join( '/' => ("regions_stat",  $_, "city", "man/"));
	my $d=join( '/' => ("regions_stat",  $_, "village", "man/"));
	system( "mkdir -p $b");
	system( "mkdir -p $c");
	system( "mkdir -p $d");
	say $b;
	#print "$b/mortality.csv\n";
	#print "$c/mortality.csv\n";
	#print "$d/mortality.csv\n";
	open my $full_out, '>', "$b/mortality.csv" or die "$b/mortality.csv\n";
	open my $city_out, '>', "$c/mortality.csv" or die "$c/mortality.csv\n";
	open my $village_out, '>', "$d/mortality.csv" or die "$d/mortality.csv\n";
	print $full_out 	$all_str_m[0];
	print $city_out 	$all_str_m[0];
	print $village_out 	$all_str_m[0];
	for (my $i=0; $i<18;$i=$i+1)#18 категорий возрастов
	{
		print $full_out 	$all_str_m[$a+$i*4].substr($all_str_m[$a+$i*4+1],14);
		print $city_out 	$all_str_m[$a+$i*4].substr($all_str_m[$a+$i*4+2],20);
		print $village_out 	$all_str_m[$a+$i*4].substr($all_str_m[$a+$i*4+3],19);
	}
	close $full_out;
	close $city_out;
	close $village_out;
}
foreach $b (@num_str_array_w)
{
	$_=$all_str_m[$a-5];
	s/.*[ \t\n]*$//;
	s/ /\\ /;
	s/,//;
	my $b=join( '/' => ("regions_stat",  $_, "full", "woman/"));
	my $c=join( '/' => ("regions_stat",  $_, "city", "woman/"));
	my $d=join( '/' => ("regions_stat",  $_, "village", "woman/"));
	system( "mkdir -p $b");
	system( "mkdir -p $c");
	system( "mkdir -p $d");
	#print "$b\n";
	open my $full_out, '>', "regions_stat/$_/full/woman/mortality.csv" or die "$!: regions_stat/$_/full/woman/mortality.csv\n";
	open my $city_out, '>', "regions_stat/$_/city/woman/mortality.csv" or die "$!: regions_stat/$_/full/woman/mortality.csv\n";
	open my $village_out, '>', "regions_stat/$_/village/woman/mortality.csv" or die "$!: regions_stat/$_/full/woman/mortality.csv\n";
	print $full_out 	$all_str_w[0];
	print $city_out 	$all_str_w[0];
	print $village_out 	$all_str_w[0];
	for (my $i=0; $i<18;$i=$i+1)#18 категорий возрастов
	{
		print $full_out 	@all_str_w[$b+$i*4].substr(@all_str_w[$b+$i*4+1],14);
		print $city_out 	@all_str_w[$b+$i*4].substr(@all_str_w[$b+$i*4+2],20);
		print $village_out 	@all_str_w[$b+$i*4].substr(@all_str_w[$b+$i*4+3],19);
	}
	close $full_out;
	close $city_out;
	close $village_out;
}
