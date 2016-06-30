#!/usr/bin/perl
use strict;
use warnings;
use 5.20.2;
#use utf8;
#open my $file_m, '<', $ARGV[0] or die "Невозможно открыть файл: $!\n";
#open my $file_w, '<', $ARGV[1] or die "Невозможно открыть файл: $!\n";

mkdir "regions_stat";

sub load($**)
{
    my ($filename, $num_str_array, $all_str) = @_;
    open my $file, '<', $filename or die "Невозможно открыть файл: $!\n";
    my $num_str;
    while(<$file>)
    {
        chomp;
        s/\r//g;
        if (/^0,/)
        {
            push(@$num_str_array, $num_str);
        }
        $num_str++;
        push(@$all_str, $_);
    }
    close $file;
}

sub generate_tree(**$)
{
    my ($num_str_array, $all_str,$type) = @_;
    foreach my $x (@$num_str_array)
    {
        $_=@$all_str[$x-5];
        s/([ ()])/\\$1/g;
        s/,//;
        my $b=join( '/' => ("regions_stat",  $_, "full", $type."man"));
        my $c=join( '/' => ("regions_stat",  $_, "city", $type."man"));
        my $d=join( '/' => ("regions_stat",  $_, "village", $type."man"));
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
        print $full_out 	@$all_str[0]."\n";
        print $city_out 	@$all_str[0]."\n";
        print $village_out 	@$all_str[0]."\n";
        my $t;
        my $u;
        for (my $i=0; $i<18;$i=$i+1)#18 категорий возрастов
        {
            $t=@$all_str[$x+$i*4];
            $t=~s/\.//;
            $u=substr(@$all_str[$x+$i*4+1],26);
            $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
            print $full_out 	$t.$u."\n";
            $u=substr(@$all_str[$x+$i*4+2],38);
            $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
            print $city_out 	$t.$u."\n";
            $u=substr(@$all_str[$x+$i*4+3],36);
            $u=~s/"([0-9]*),([0-9]*)"/$1\.$2/g;
            print $village_out 	$t.$u."\n";
        }
        close $full_out;
        close $city_out;
        close $village_out;
    }
}

my (@num_str_array_m,@all_str_m);
load($ARGV[0],\@num_str_array_m,\@all_str_m);#men
generate_tree(\@num_str_array_m,\@all_str_m,"");

my (@num_str_array_w,@all_str_w);
load($ARGV[1],\@num_str_array_w,\@all_str_w);#women
generate_tree(\@num_str_array_w,\@all_str_w,"wo");
