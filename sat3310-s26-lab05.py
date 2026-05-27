# vi ~/Documents/labs/SAT-3310---Lab-5/sat3310-s26-lab05.py

#!/usr/bin/python3

# SAT 3310 - Lab 5
# Created by Athena Lieu (xlieu@mtu.edu)
# Date: May 26th, 2026
# Comments: This script retrieves a list of websites from a specified URL,
# extracts the server type for each website,
# and counts the occurrences of each server type.
# The results are printed in sorted order based on the count of each server type.

import csv
import requests
import collections

# Variables
dataurl = 'https://pages.mtu.edu/~toarney/sat3310/lab08/'
datafile = 'fortune500.tsv.small'
datapath = '/home/sat3310/Documents/labs/SAT-3310---Lab-5/data/'

mytimeout = 5
myserverresponses = []

mywebsitecount = 0
mytotalwebsitecount = 0

mydebug = False

# Main

# Get the data file from the URL
mydownloadfile = requests.get(dataurl + datafile)

# Write the downloaded file to the specified path
open(datapath + datafile, 'wb').write(mydownloadfile.content)

# Count the lines in the downloaded file
file = open(datapath + datafile)

reader = csv.DictReader(file, delimiter='\t')

lines = len(list(reader))

mytotalwebsitecount = lines

# Parse the downloaded file and extract server types
with open(datapath + datafile, 'rt') as myinputfile:
    myline = csv.DictReader(myinputfile, delimiter='\t')

    # Get the HTTP server response for each website
    for row in myline:
        mywebsite = "http://" + row["Website"]

        if mydebug:
            print(row["Company"], row["Website"], mywebsite)

        # Try to access the website and extract the server type
        try:
            myresponse = requests.get(mywebsite, timeout=mytimeout)
            myservertype = myresponse.headers['server']
            myserverresponses.append(myservertype)
            mywebsitecount += 1
        except:
            myservertype = 'Unknown'
        finally:
            # Count the websites
            mywebsitecount += 1

            # Save the server type response
            myserverresponses.append(myservertype)

            print(f"Processed {mywebsitecount}/{mytotalwebsitecount} websites", end='\r')

# Count the occurrences of each server type
server_counts = collections.Counter(myserverresponses)

# Print the server types and their counts in sorted order
print("\nServer Type Counts:")

for server, count in server_counts.most_common():
    print(f"{server}: {count}")