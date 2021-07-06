import pandas as pd #import panda
import numpy as np
#all files are in the current working directory
import cPickle as pickle

#1) Import each of the csv files you downloaded from the SSCC into a pandas DataFrame.
customerDF=pd.read_csv("abv902customer.csv", sep=',')
mailDF=pd.read_csv("abv902mail.csv", sep=',')
itemDF=pd.read_csv("abv902item.csv", sep=',')

#2) Verify that there are no duplicate customer records in the customer data
len(customerDF)#50,000 records
customerDF.duplicated().sum()# count duplicated records = 0 (no duplicates)

#3) Check the item and mail data to determine if there are any 
#records in them for customers who are not in the customers data
len(mailDF); mailDF.duplicated().sum()#duplicates=166 
len(itemDF); itemDF.duplicated().sum()#duplicates=6325

#There are no acct numbers in mail & item that are not in customer data (use sets)
mNotc=set(mailDF.acctno)-set(customerDF.acctno)
len(mNotc)# mNotc=0 
iNotc=set(itemDF.acctno)-set(customerDF.acctno)
len(iNotc)# iNotc=0

#4)Create a sqlite database, and write the customer, item, and mail data into it as tables
import sqlite3
conn = sqlite3.connect(r"customerDB.db")#created customerDB database to hold tables

import sqlalchemy
from sqlalchemy import create_engine
eng=create_engine('sqlite:///customerDB.db')#specify db you want to use

#write customer, mail and item dataframes to new customerDB
customerDF.to_sql('customer', eng)#add customer table
mailDF.to_sql('mail', eng)#add mail table
itemDF.to_sql('item', eng)#add item table

#Look at metadata from an RDB using SQLAlchemy using the 'inspect' method:
from sqlalchemy import inspect
insp=inspect(eng)
insp.get_table_names()#three tables exist in DB (customer, mail, item)

#5)Create a target file for XYZ Company
#sum mail campaigns
df=mailDF
#Add a column 'mail_total' with customers mailed >= 5 times 
df['mail_total'] = df.sum(axis=1)
df.head()#check that col added
test = df[df.mail_total >= 5]#test contains customers mailed >= 5 times 
len(test)#so keep 11,535 customers that've been mailed >= 5 times 
(len(mailDF) - len(test))#so discard 19,411 customer records
#keep acctno and total_mail columns, delete the rest of the columns
test.drop(test.columns[[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]], axis=1, inplace=True)
#keep customerDF columns defined in specs in a new df called 'df2'
df2 = customerDF[['acctno','ytd_transactions_2009','ytd_sales_2009', 'zhomeent', 'zmobav']]
#Make additional column copies of zhomeent and zmobav
df2['zhomeent2']=df2['zhomeent']
df2['zmobav2']=df2['zmobav']

#Use numpy to convert 'Y' or not 'Y' in these cols to '1' or '0' in-place, respectively
df2['zhomeent2'] = np.where(df2['zhomeent2'] == 'Y', 1, 0)
df2['zmobav2'] = np.where(df2['zmobav2'] == 'Y', 1, 0)
df2.head()#check columns add to specification

#Merge test and df2 dataframes to show all records from both frames
mergedDF1=pd.merge(test, df2, on='acctno', how='outer')    

#Then just delete the excess indices from customerDF in range 11535-50142 (end)
mergedDF1.drop(mergedDF1.index[11535::], inplace=True)
len(mergedDF1)#size = 11,535 i.e. customers mailed >= 5 times
mergedDF1.head()

#Create csv file of mergedDF1 (Deliverable)
mergedDF1.to_csv("xyz_directMail.csv")

#6) Pickle the direct mail list (mergedDF1)
import cPickle as pickle
pickle.dump(mergedDF1,open('xyz_directmail.p', 'wb'))
pickle.dump(mailDF,open('xyz_maildf.p', 'wb'))
pickle.dump(itemDF,open('xyz_itemdf.p', 'wb'))
pickle.dump(customerDF,open('xyz_customerdf.p', 'wb'))

