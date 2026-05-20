#!/usr/bin/python

# sat3310
# lab05
# 3/2/22
# by toarney@mtu.edu

# Variables
dataurl = 'https://pages.mtu.edu/~toarney/sat3310/lab08/'
#datafile = 'fortune500.tsv'
datafile = 'fortune500.tsv.small'
datapath = '/home/sat3310/Documents/labs/lab05/data/'
mytimeout = 5
myserverresponses = []
mywebsitecount = 0
mytotalwebsitecount = 0
mydebug = False

# Modules
import csv
import requests
import collections
import sys


# Download a file

mydownloadfile = requests.get(dataurl + datafile)

# Write the downloaded file

open(datapath + datafile, 'wb').write(mydownloadfile.content)

# Count the lines in the downloaded file

file = open(datapath + datafile)
reader = csv.DictReader(file)
lines = len(list(reader))
mytotalwebsitecount = lines
if mydebug:
    print("Total websites: ", mytotalwebsitecount)


# Read each line from downloaded file

with open(datapath + datafile, 'rt') as myinputfile:
    
    myline = csv.DictReader(myinputfile, delimiter='\t')
   
    # Get the HTTP server response
    
    for row in myline:
        mywebsite = "http://" + row["Website"]

        if mydebug:
            print(row["Company"], row["Website"], mywebsite)
        
        try:
            myresponse = requests.get(mywebsite, timeout=mytimeout)
            myservertype = myresponse.headers['server']
        except:
            myservertype = 'Unknown'
        finally:
            # count the websites
            mywebsitecount +=1
            myserverresponses.append(myservertype)
        
        if mydebug:
            print(myservertype)

        print ("Working: ", mywebsitecount, "of", mytotalwebsitecount, end='\r', flush=True)

myinputfile.close()

# Count lines

if mydebug:
    print(mywebsitecount)
    print(len(myserverresponses))


# Count and sort results

print ("\n\nResults:\n")
counter = collections.Counter(myserverresponses)
for servers, freq in counter.most_common():
    print (freq, "\t", servers)

