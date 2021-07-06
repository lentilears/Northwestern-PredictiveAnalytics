import pandas as pd #import panda
#all files are in the current working directory

#Read in Airlines labels data
airlinelabs=pd.read_csv("airlinelabs.csv", sep=',', header=None)  # get a DataFrame with one row of data from a file w/o a header
# get the airlines data into a pandas DataFrame:
airlinesDF=pd.read_csv("airlines.dat", sep=',', header=None)
airlinesDF.columns=airlinelabs.loc[0] # Assign airlinelabs names to airlinesDF columns dataframe
print(airlinelabs)

#Read in Airports labels data
airportlabs=pd.read_csv("airportlabs.csv", sep=',', header=None)  # get a DataFrame with one row of data from a file w/o a header
# get the airports data into a pandas DataFrame:
airportsDF=pd.read_csv("airports.dat", sep=',', header=None)
airportsDF.columns=airportlabs.loc[0]       # Assign airportlabs names to airportsDF column dataframe
print(airportlabs)

#Read in Routes labels data
routelabs=pd.read_csv("routelabs.csv", sep=',', header=None)  # get a DataFrame with one row of data from a file w/o a header
# get the routes data into a pandas DataFrame:
routesDF=pd.read_csv("routes.dat", sep=',', header=None)
routesDF.columns=routelabs.loc[0]       # Assign routes names to routesDF dataframe
print(routelabs)

#Pickling Airlines, Airports and Routes data frames
import cPickle as pickle
pickle.dump(airlinesDF,open('airlineslist.p', 'wb'))
pickle.dump(airportsDF,open('airportslist.p', 'wb'))
pickle.dump(routesDF,open('routeslist.p', 'wb'))

#Number of departing routes from Chicago O'Hare Airport (ORD)
routesDF[routesDF.srcAirport=="ORD"].shape
#Number of incoming routes from Airport EGO
routesDF[routesDF.destAp=="EGO"].shape


