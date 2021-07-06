#Assignment 4
import pandas as pd #import panda
import numpy as np
#all files are in the current working directory
from pandas import DataFrame
from pandas import Series

import json
#Load 100506.json into a dictionary of dictionaries 
with open('100506.json') as input_file:
    jsondat=json.load(input_file)
jsondat.keys() 

#Parse data from 'Reviews' dictionary
reviews = []#create an empty reviews list
Reviews = jsondat["Reviews"]

for review in Reviews:
    review_dict = {}#create empty review_dict 
    review_dict['Author'] = review['Author']
    review_dict['Date'] = review['Date']
    review_dict['Ratings'] = review['Ratings']
    reviews.append(review_dict) 

len(reviews)#48 line entries 

#import reviews list into a dataframe (Author, Date, Ratings)
df = pd.DataFrame(reviews)
df.shape#df has the right size (48 x 3)


#Parse comments from Reviews and add to new dataframe, comments
comments=[]
for review in Reviews:
    comment_dict = {}#create empty comment_dict
    comment_dict['Author'] = review['Author']
    comment_dict['Date'] = review['Date']     
    comment_dict['Content'] = review['Content']
    comments.append(comment_dict)
    
len(comments)#48 line entries, two columns Author and Content 
#import comments list into a dataframe
df1 = pd.DataFrame(comments)
df1.shape#df has the right size (48 x 3)

#Archiving data: pickle and text files                                      
#Pickle the dataframes created
import cPickle as pickle
pickle.dump(df,open('reviewslist.p', 'wb'))
pickle.dump(df1,open('commentslist.p', 'wb'))                                   
#Create csv file for df1 (comments)
df1.to_csv("commentslist.csv")                                                                            