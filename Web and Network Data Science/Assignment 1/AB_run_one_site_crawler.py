# Bhattacharyya, PREDICT-452 Sect 55
#Simple One-Site Web Crawler and Scraper (Python) 
#
# Crawls DivvyBikes, a Chicago bike-share program, in particular,
#it begins at the Divvy Bikes main landing page:
# https://www.divvybikes.com/

# prepare for Python version 3x features and functions
from __future__ import division, print_function

import scrapy  # object-oriented framework for crawling and scraping
import os  # operating system commands

# function for walking and printing directory structure
def list_all(current_directory):
    for root, dirs, files in os.walk(current_directory):
        level = root.replace(current_directory, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))

# examine the directory structure
current_directory = os.getcwd()
list_all(current_directory)

# list the avaliable spiders, showing names to be used for crawling
os.system('scrapy list')

# Export output into JSON format

# run the scraper exporting results as a JSON text file divvyitems.jsonlines
# this file provides text information with linefeeds to provide
# text output that is easily readable in a plain text editor
os.system('scrapy crawl DIVVYBIKES -o divvyitems.jsonlines')

#run the scraper exporting results as a JSON text file divvyitems.json
os.system('scrapy crawl DIVVYBIKES -o divvyitems.json')

#Additional: Use BeautifulSoup to parse the data files page on Divvy
import urllib
from BeautifulSoup import *

html = urllib.urlopen('https://www.divvybikes.com/system-data').read()
soup = BeautifulSoup(html)

# Retrieve all of the anchor tags
tags = soup('a')
print(tags[0])
for tag in tags:
    print tag.get('href', None)

        


