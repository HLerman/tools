#!/usr/bin/perl
use strict;
use warnings;

my $raidState = `cat /proc/mdstat`;

foreach my $line(split /[\r\n]+/, $raidState)
{
    if($line =~ m/active raid([0-9]+)/)
    {
        print "Raid type : $1\n";
    }
    if($line =~ m/(\[[U_]+\])/)
    {
	print "Raid State : $1\n";
    }
}

my $hardwareCommand = `lshw -class disk -short`;
my @disks        = ();

foreach my $line (split /[\r\n]+/, $hardwareCommand) {
    if($line =~ m/(\/dev\/sd[a-z])/)
    {
        push @disks, $1;
    }
}

$hardwareCommand = 'smartctl -a';
my $output = '';

for my $disk (@disks)
{
    $output = `$hardwareCommand $disk`;
    my $error = 0;

    foreach my $line (split /[\r\n]+/, $output) {
    	if($line =~ m/^ATA Error Count/)
	    {	
	        $error = 1;
	        print "$disk : ERROR\n";
	        last;
	    }
    }

    if(not $error)
    {
        print "$disk : NO ERROR\n";
    }
}

