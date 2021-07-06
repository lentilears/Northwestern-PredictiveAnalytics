# -*- coding: utf-8 -*-
import pandas as pd #import panda
import numpy as np
#all files are in the current working directory

import cPickle as pickle

#read-in each pickle files into a separate panda datafarme
airlinesdf = pd.read_pickle('airlineslist.p')
airportsdf = pd.read_pickle('airportslist.p')
routesdf = pd.read_pickle('routeslist.p')

#Identify duplicates in airlinesdf, airportsdf and routesdf
airlinesdf.duplicated().sum()#returns a boolean 'True' if duplicated and 'False' if not
airportsdf.duplicated().sum()#for all DFs returns a sum=0 so no duplicates
routesdf.duplicated().sum()


#data types of all columns in each of the three dataframes
airlinesdf.dtypes
airportsdf.dtypes
routesdf.dtypes

#inspect first 10 indexes of all three dataframes
airlinesdf.ix[:10]
airportsdf.ix[:10]
routesdf.ix[:10]

#Number of airlines in the data (that are unique). Choose airline name column (airName)
airlinesdf.airName.unique

#Number of defunct airlines (filter ‘active’ column in airlinesdf, find where its 'N')
print(airlinesdf.loc[airlinesdf['active']=="N"])

#Show the flights from nowhere. This code counts the number of empty/blank entries in the srcAirport column
routesdf['srcAirport'].isnull().sum()#There are zero flights from nowhere

#Pickling Airlines, Airports and Routes data frames again
import cPickle as pickle
pickle.dump(airlinesdf,open('airlineslist.p', 'wb'))
pickle.dump(airportsdf,open('airportslist.p', 'wb'))
pickle.dump(routesdf,open('routeslist.p', 'wb'))

##Extra credit

#import geopy package
#Use geopy package to calulate distance from 2 sets of longi-latitude data
import geopy as geo
from geopy.distance import VincentyDistance
x = (41.9742, 87.9073)#coordinates of Chicago (ORD)
y = (35.0433, 106.6129)#example coordinates of ABQ (Alberquerque)
print(VincentyDistance(x, y).miles)#prints distance ORD -> ABQ

#Create a dataframe for all routes from ORD to other airports
ordRoutesdf = routesdf[routesdf.srcAirport=="ORD"] #558 records

#rename apID column in airportsdf to be same as ordRoutesdf column 
#('destApID' for merging), so that df contains lat/long coordinates
airportsdf.rename(columns={'apID':'destApID'}, inplace=True)
#df now contains all ordRoutesdf, airport and location data
df = ordRoutesdf.merge(airportsdf, on='destApID', how='left')
len(df)#right size, 558 records

#Need to iterate through df to pass lat/long coordinates to distance function.
#Got upto here and got stuck! For some reason the coordinates appear as 'NaN'!
#keep x coordinates constant and for y use coordinates extracted from destApID.
   