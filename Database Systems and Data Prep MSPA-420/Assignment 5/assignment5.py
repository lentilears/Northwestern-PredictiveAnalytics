import pandas as pd #import panda
import numpy as np
#all files are in the current working directory
import cPickle as pickle

#Q1) Import passenger csv file into a pandas DataFrame
passengerDF=pd.read_csv("2014PassengerRawData2-1.csv", sep=',')
len(passengerDF)#25593 records
passengerDF.duplicated().sum()#no entirely duplicated records

#Looked at data for these airports none are a destination airport

sfoDF = passengerDF.loc[passengerDF['OriginApt']=="SFO"]
len(sfoDF)#761 deps from SFO, no instances where SFO is a destination (arrival)!
sfoDF.loc[sfoDF['Total']].sum()#158,535
sfoDF.sort_values(['Total','Carrier'], ascending=False)#AC=largest departure carrier for SFO
sfoCarrier = sfoDF.groupby('Carrier')
sfoResult = sfoCarrier['Total'].aggregate(np.sum)
sfoResult#Best carrier for SFO is UA=3,286,046 total passengers

laxDF = passengerDF.loc[passengerDF['OriginApt']=="LAX"]
len(laxDF)#1456 deps from LAX but none as destination (arrival)!
laxDF.loc[laxDF['Total']].sum()#719,960
laxDF.sort_values(['Total','Carrier'], ascending=False)#AC=largest departure carrier for LAX
laxCarrier = laxDF.groupby('Carrier')
laxResult = laxCarrier['Total'].aggregate(np.sum)
laxResult#Best carrier for LAX is DL total 1,159,667 passengers

atlDF = passengerDF.loc[passengerDF['OriginApt']=="ATL"]
len(atlDF)#1026 deps from ATL, none as destination (arrival)!
atlDF.loc[atlDF['Total']].sum()#501,702
atlDF.sort_values(['Total','Carrier'], ascending=False)#DL=largest departure carrier for ATL
atlCarrier = atlDF.groupby('Carrier')
atlResult = atlCarrier['Total'].aggregate(np.sum)
atlResult#Best carrier for ATL is DL total 8,203,111 passengers

miaDF = passengerDF.loc[passengerDF['OriginApt']=="MIA"]
len(miaDF)#2101 deps from MIA, none as destination (arrival)!
miaDF.loc[miaDF['Total']].sum()#1,039,492
miaDF.sort_values(['Total','Carrier'], ascending=False)#AA=largest departure carrier for MIA
miaCarrier = miaDF.groupby('Carrier')
miaResult = miaCarrier['Total'].aggregate(np.sum)
miaResult#Best carrier for MIA is AA total 11,066,495 passengers

jfkDF = passengerDF.loc[passengerDF['OriginApt']=="JFK"]#2178 deps from JFK, none as destination!
len(jfkDF)#2178 deps from JFK, none as destination (arrival)!
jfkDF.loc[jfkDF['Total']].sum()#1,841,657
jfkDF.sort_values(['Total','Carrier'], ascending=False)#BA=largest departure carrier
jfkCarrier = jfkDF.groupby('Carrier')
jfkResult = jfkCarrier['Total'].aggregate(np.sum)
jfkResult#Best carrier for JFK is B6 total 2,951,853 passengers

#Result: JFK > MIA > LAX > ATL > SFO (passenger departures)
#Result: No arrivals for any of these airports!


#Q2)For each of these airports, determine the airport that the largest number of departures went to.
from pandas import Categorical
sfo_status=Categorical(sfoDF.DestApt)  
sfo_status.describe()# ICN and YVR each have most arrivals (50 counts) from SFO

lax_status=Categorical(laxDF.DestApt)  
lax_status.describe()# YVR has most arrivals (67 counts) from LAX

atl_status=Categorical(atlDF.DestApt)  
atl_status.describe()# YUL has most arrivals (30 counts) from ATL

mia_status=Categorical(miaDF.DestApt)  
mia_status.describe()# SNU has most arrivals (60 counts) from MIA

jfk_status=Categorical(jfkDF.DestApt)  
jfk_status.describe()# YYZ has most arrivals (63 counts) from JFK

#Q3)Accidents and deaths
accidentsData=pd.read_table('A2010_14.txt')
len(accidentsData)
sfo1 = accidentsData[accidentsData['c143'].str.strip()=='SFO']
len(sfo1)#4 incidents
#'c143'=aptCode; 'c6'=Year;'c76'=total fatalities
sfoKilled = sfo1[['c143','c6','c76']]
sfoKilled.columns = ['AptCode','Year','TotFatalities']#3 deaths

lax1 = accidentsData[accidentsData['c143'].str.strip()=='LAX']
len(lax1)#13 incidents
laxKilled = lax1[['c143','c6','c76']]
laxKilled.columns = ['AptCode','Year','TotFatalities']#0 deaths

atl1 = accidentsData[accidentsData['c143'].str.strip()=='ATL']
len(atl1)#24 incidents
atlKilled = atl1[['c143','c6','c76']]
atlKilled.columns = ['AptCode','Year','TotFatalities']#0 deaths

mia1 = accidentsData[accidentsData['c143'].str.strip()=='MIA']
len(mia1)#9 incidents
miaKilled = mia1[['c143','c6','c76']]
miaKilled.columns = ['AptCode','Year','TotFatalities']#0 deaths

jfk1 = accidentsData[accidentsData['c143'].str.strip()=='JFK']
len(jfk1)#10 incidents
jfkKilled = jfk1[['c143','c6','c76']]
jfkKilled.columns = ['AptCode','Year','TotFatalities']#0 deaths

#Q4)More on fatalities...
allKilled = accidentsData[['c143','c6','c76', 'c77']]#extract fatality data to a new df
allKilled.columns = ['AptCode','Year','TotFatalities','PrimaryCause']
len(allKilled)#11501 entries

fatalitiesDF = allKilled.loc[allKilled['TotFatalities'] > 0.0]#extract incidents with >= 1 fatality
len(fatalitiesDF)#1096 instances of > 0 deaths
fatalitiesDF.dropna(subset=['PrimaryCause'], inplace=True)#remove NaN instances (15) 
len(fatalitiesDF)#1081 
    
sortFatalities = fatalitiesDF.sort_values(['TotFatalities','PrimaryCause'], ascending=False)
sortFatalities.to_csv("Fatalities.csv")#Couldn't find way to remove empty cells, so exported to Excel to do so
sortFilterFatalities=pd.read_csv("Fatalities-filtered.csv", sep=',')
len(sortFilterFatalities)#41 instances sorted by freq of occurrence of fatalities
sortFilterFatalities[0:13]#to display top 10 different ATA codes sorted by no. of fatalities

