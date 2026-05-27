# vi ~/Documents/labs/SAT-3310---Lab-5/sat3310-s26-lab05.pl

#!/usr/bin/perl

# SAT 3310 - Lab 5
# Created by Athena Lieu (xlieu@mtu.edu)
# Date: May 26th, 2026
# Comments: This script retrieves a list of websites from a specified URL,
# extracts the server type for each website,
# and counts the occurrences of each server type.
# The results are printed in sorted order based on the count of each server type.

use LWP::Simple;

# Variables

$dataurl = "https://pages.mtu.edu/~toarney/sat3310/lab07/";
$datafile = "fortune500.tsv";
$datapath = "/home/sat3310/Documents/labs/SAT-3310---Lab-5/data/";

@arrayofurls = ();
@arrayofservertype = ();

$working = 0;

# Main

# Get a file - list of websites
getstore($dataurl.$datafile, $datapath.$datafile);

# Parsing the lines of the file to turn into an array then closing the file
open(FILE, "<", $datapath.$datafile);

while ($line = <FILE>) {

    # Split the line into an array using tab as the delimiter
    my @website=split("\t",$line);

    # Push the third element of the array (the website URL) into the @arrayofurls array
    push @arrayofurls, $website[2];
    # Print the website URL for debugging purposes
    # print "Website2: $website[2]\n";
}

close(FILE);

# Remove first element of array (the header row)
shift @arrayofurls;

# Disable buffering to ensure immediate output
$|=1;

# Count the total number of websites and print it
$totalsize = scalar @arrayofurls;

# Loop through each URL in the @arrayofurls array
foreach my $url (@arrayofurls) {
    # Construct the complete URL by prepending "http://"
    my $completeurl = "http://".$url;

    # Use the head function to get the server type and other information
    my ($type, $length, $modtime, $expiretime, $servertype) = head($completeurl);

    # If the server type is empty, set it to "Unknown"
    if ($servertype eq "") {
        $servertype = "Unknown";
    }

    # If the server type contains a "/", extract the substring before it
    if (index($servertype, "/") > 0) {
        $servertypesubstring = substr($servertype, 0, index($servertype, "/"));
    }
    else {
        $servertypesubstring = $servertype;
    }

    # Push the server type substring into the @arrayofservertype array
    push @arrayofservertype, $servertypesubstring;

    # Increment the working counter and print the progress
    $working++;

    print "Working... $working of $totalsize done.";

    # Print backspaces to overwrite the previous progress output
    print "\b" x 30; # Adjust the number of backspaces as needed
}

print "\n\n";

# Count the occurrences of each server type and store in a hash
%servertypehash = ();

foreach my $servername (@arrayofservertype) {

    # Increment the count for the server type in the hash
    $servertypehash{$servername}++;
}

# Sort the server types by count and print the results
foreach my $server (sort { $servertypehash{$a} <=> $servertypehash{$b} } keys %servertypehash) {
    
    # Print the server type and its count
    print "Server Type: $server\t Count: $servertypehash{$server}\n";
}