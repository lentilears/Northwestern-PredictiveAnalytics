# Predict 452-55: Nature & Environment Team 
# Reads XML-formatted sitemaps for Chevy Bolt, Nissan Leaf 
# and Tesla M3 and outputs URLs from the respective sitemaps

import re

#Get URLs from the Nissan leaf XML file
f = open('leafsitemap.xml','r')
res = f.readlines()
for d in res:
    data = re.findall('>(https:\/\/.+)<',d)
    for i in data:
        print i
        
#Get URLs from the 2017 Chevy Bolt XML file
f = open('2017boltsitemap.xml','r')
res = f.readlines()
for d in res:
    data = re.findall('>(http:\/\/.+)<',d)
    for i in data:
        print i 
               
#Get URLs from the Tesla Model 3 XML file
f = open('model3sitemap.xml','r')
res = f.readlines()
for d in res:
    data = re.findall('>(https:\/\/.+)<',d)
    for i in data:
        print i               