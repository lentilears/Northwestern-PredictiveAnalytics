# -*- coding: utf-8 -*-
# Predict 452-55: Nature & Environment Team 
import pandas as pd
import requests
from bs4 import BeautifulSoup
from tabulate import tabulate

#Extract historical sales figures for Nissan Leaf 
res = requests.get("http://carsalesbase.com/us-car-sales-data/nissan/nissan-leaf")
soup = BeautifulSoup(res.content, 'lxml')
table = soup.find_all('table')[0]
df = pd.read_html(str(table))
print(tabulate(df[0], tablefmt='psql'))
#f = open('nissanleafsales.txt', 'w')
#for item in df:
#  print >> f, tabulate(df[0], tablefmt='psql')

#Extract historical sales figures for Chevy Bolt 
res = requests.get("http://carsalesbase.com/us-car-sales-data/chevrolet/chevrolet-bolt-ev")
soup = BeautifulSoup(res.content, 'lxml')
table = soup.find_all('table')[0]
df = pd.read_html(str(table))
print(tabulate(df2[0], tablefmt='psql'))
#f = open('chevyboltsales.txt', 'w')
#for item in df:
#  print >> f, tabulate(df[0], tablefmt='psql')

#Extract historical sales figures for Tesla Model 3 
res = requests.get("http://carsalesbase.com/us-car-sales-data/tesla/tesla-model-3")
soup = BeautifulSoup(res.content, 'lxml')
table = soup.find_all('table')[0]
df = pd.read_html(str(table))
print(tabulate(df[0], tablefmt='psql'))
#f2 = open('teslamodel3sales.txt', 'w')
#for item in df:
#  print >> f, tabulate(df[0], tablefmt='psql')

#Global EV, hybrid and plug-in sales data 1999-2015
#https://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_statistics/html/table_01_19.html
res = requests.get("https://www.rita.dot.gov/bts/sites/rita.dot.gov.bts/files/publications/national_transportation_statistics/html/table_01_19.html")
soup = BeautifulSoup(res.content, 'lxml')
table = soup.find_all('table')[0]
df = pd.read_html(str(table))
print(tabulate(df[0], tablefmt='psql'))

