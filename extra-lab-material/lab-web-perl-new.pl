#!/usr/bin/perl

# sat3310 - lab05
# created by dvmichae@mtu.edu
# 6/2/2021

# Variables

$dataurl = "https://pages.mtu.edu/~toarney/sat3310/lab07/";
$datafile = "fortune500.tsv";
# $datafilesmall = "fortune500.tsv.small";
$datapath = "/home/sat3310/Documents/labs/lab05/data/";

# Main
# make sure to:
# dnf install perl-LWP-Online
# dnf install perl-LWP-Protocol-https
use LWP::Simple;

# Get a file - list of websites
getstore($dataurl.$datafile, $datapath.$datafile);

# Parsing the lines of the file to turn into an array then closing the file 
# open(FILE, "<", $datapath.$datafilesmall);
open(FILE, "<", $datapath.$datafile);

while ($line = <FILE>) {
my @website=split("\t",$line);
	push @arrayofurls, $website[2];
	#print "Website2: $website[2]\n";
	}
	
close FILE;

# Suffering from bufferring
$|=1;

# Remove first element of array
shift @arrayofurls;

# Print size of array
$totalsize = scalar @arrayofurls;
print "Total number of websites: $totalsize\n";

# Start the loop
# mod by toarney@mtu.edu
#foreach my $website (@arrayofurls) {
foreach my $url (@arrayofurls) {
	# mod by toarney@mtu.edu
	# my $completeurl = "http://".@$website[2];
	my $completeurl = "http://".$url;
	# print "Complete URL: $completeurl\n";
	my ($type, $length, $modtime, $expiretime, $servertype) = head($completeurl);
	if ($servertype eq "") {$servertype = "Unknown"};
	if (index($servertype, "/") > 0) {
		$servertypesubstring = substr($servertype, 0, index($servertype, "/"));
	}
	else {
		$servertypesubstring = $servertype;
	}
	push (@arrayofservertypes, $servertypesubstring);
	$working++;
	print "Working... $working of $totalsize done.";
	print "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b";
}
print "\n";

# Display results
#for my $key (keys %servertypehash) {
#	print "Key: $key \t Value:\t$servertypehash{$key}\n";
#}
# servertype hash (key, value)
# keys are server type names, values are number of times seen

%servertypehash = ();
foreach my $servername (@arrayofservertypes) {
	$servertypehash{$servername}++;
	# print "Hash: $servername\t $servertypehash{$servername} \n";
}

# Sort and
# Print results

print "\nResults:\n";
foreach my $server (sort { $servertypehash{$a} <=> $servertypehash{$b} } keys %servertypehash) {
        print "$servertypehash{$server} \t $server\n";
    }