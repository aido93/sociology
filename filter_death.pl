#!/usr/bin/perl
use strict;
use warnings;
use 5.20.2;
#use utf8;
open my $file_m, '<', $ARGV[0] or die "Невозможно открыть файл: $!\n";
open my $file_w, '<', $ARGV[1] or die "Невозможно открыть файл: $!\n";

mkdir "regions_stat";
my $num_str_m;
my @num_str_array_m;
my @all_str_m;

while(<$file_m>)
{
	chomp;
	s/\r//g;
	if (/^0,/)
	{
		push(@num_str_array_m, $num_str_m);
	}
	$num_str_m++;
	push(@all_str_m, $_);
}

close $file_m;

my $num_str_w;
my @num_str_array_w;
my @all_str_w;

while(<$file_w>)
{
	chomp;
	s/\r//g;
	if (/^0,/)
	{
		push(@num_str_array_w, $num_str_w);
	}
	$num_str_w++;
	push(@all_str_w, $_);
}

close $file_w;

foreach my $x (@num_str_array_m)
{
	$_=$all_str_m[$x-5];
	s/([ ()])/\\\1/g;
	s/,//;
	my $b=join( '/' => ("regions_stat",  $_, "full", "man"));
	my $c=join( '/' => ("regions_stat",  $_, "city", "man"));
	my $d=join( '/' => ("regions_stat",  $_, "village", "man"));
	system( "mkdir -p $b");
	system( "mkdir -p $c");
	system( "mkdir -p $d");
    $b=~s/\\//g;
    $c=~s/\\//g;
    $d=~s/\\//g;
    say $b;
	open my $full_out, '>', "./$b/mortality.csv" or die "$!: $b/mortality.csv\n";
	open my $city_out, '>', "./$c/mortality.csv" or die "$!: $c/mortality.csv\n";
	open my $village_out, '>', "./$d/mortality.csv" or die "$!: $d/mortality.csv\n";
	print $full_out 	$all_str_m[0]."\n";
	print $city_out 	$all_str_m[0]."\n";
	print $village_out 	$all_str_m[0]."\n";
    my $t;
    my $u;
	for (my $i=0; $i<18;$i=$i+1)#18 категорий возрастов
	{
        $t=$all_str_m[$x+$i*4];
        $t=~s/\.//;
		$u=substr(@all_str_w[$x+$i*4+1],26);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $full_out 	$t.$u."\n";
        $u=substr(@all_str_w[$x+$i*4+2],38);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $city_out 	$t.$u."\n";
        $u=substr(@all_str_w[$x+$i*4+3],36);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $village_out 	$t.$u."\n";
	}
	close $full_out;
	close $city_out;
	close $village_out;
}
foreach my $x (@num_str_array_w)
{
	$_=$all_str_m[$x-5];
	s/([ ()])/\\\1/g;
	s/,//;
	my $b=join( '/' => ("regions_stat",  $_, "full", "woman"));
	my $c=join( '/' => ("regions_stat",  $_, "city", "woman"));
	my $d=join( '/' => ("regions_stat",  $_, "village", "woman"));
	system( "mkdir -p $b");
	system( "mkdir -p $c");
	system( "mkdir -p $d");
    $b=~s/\\//g;
    $c=~s/\\//g;
    $d=~s/\\//g;
	#print "$b\n";
	open my $full_out, '>', "$b/mortality.csv" or die "$!: $b/mortality.csv\n";
	open my $city_out, '>', "$c/mortality.csv" or die "$!: $c/mortality.csv\n";
	open my $village_out, '>', "$d/mortality.csv" or die "$!: $d/mortality.csv\n";
	print $full_out 	$all_str_w[0]."\n";
	print $city_out 	$all_str_w[0]."\n";
	print $village_out 	$all_str_w[0]."\n";
    my $t;
    my $u;
	for (my $i=0; $i<18;$i=$i+1)#18 категорий возрастов
	{
        $t=$all_str_m[$x+$i*4];
        $t=~s/\.//;
        $u=substr(@all_str_w[$x+$i*4+1],26);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $full_out 	$t.$u."\n";
        $u=substr(@all_str_w[$x+$i*4+2],38);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $city_out 	$t.$u."\n";
        $u=substr(@all_str_w[$x+$i*4+3],36);
        $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
		print $village_out 	$t.$u."\n";
	}
	close $full_out;
	close $city_out;
	close $village_out;
}
