#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;

my $cmd = `locate .git/HEAD`;
#my $cmd = `find / -wholename "*.git/HEAD" 2>/dev/null`;
my @gitMasterRepo = ();
my @gitOtherRepo  = ();

foreach my $line (split /[\r\n]+/, $cmd) {
    open(my $fh, '<', $line);

    while(my $row = <$fh>)
    {
        chomp $row;
        if($row =~ /^ref: refs\/heads\/master$/)
        {
            push @gitMasterRepo, $line;
        }
        else
        {
            push @gitOtherRepo, {'line' => $line, 'row' => $row};
        }
    }

    close $fh;
}

for(my $i = 0; $i < scalar(@gitMasterRepo); $i++)
{
    my $path = '';
    if($gitMasterRepo[$i] =~ /^(\/.+)\.git\/HEAD$/)
    {
        $path = $1;
        print $path."\n";
    }

    $cmd = `cd $path && git status`;

    foreach my $gitStatus (split /[\r\n]+/, $cmd) {
        if($gitStatus =~ m/(modified|added|deleted|renamed|copied):/)
        {
            print color('blue');
            print $gitStatus."\n";
            print color('reset');
        }
    }
}

for(my $i = 0; $i < scalar(@gitOtherRepo); $i++)
{
    my $branch;
    if($gitOtherRepo[$i]->{'row'} =~ /^ref: refs\/heads\/(.+)$/)
    {
        $branch = $1;
    }

    my $path = '';
    if($gitOtherRepo[$i]->{'line'} =~ /^(\/.+)\.git\/HEAD$/)
    {
        $path = $1;

        print $path;
        print color('green');
        print ' GIT['.$branch."]\n";
        print color('reset');
    }

    $cmd = `cd $path && git status`;

    foreach my $gitStatus (split /[\r\n]+/, $cmd) {
        if($gitStatus =~ m/(modified|added|deleted|renamed|copied):/)
        {
            print color('blue');
            print $gitStatus."\n";
            print color('reset');
        }
    }
}

