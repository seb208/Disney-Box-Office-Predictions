#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  7 15:57:02 2022

@author: sebastianchinen
"""
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
import pandas as pd
import matplotlib.pyplot as plt

#------Data Consolidation------

df_plus = pd.read_csv(r'disney_plus_titles.csv')
df_box = pd.read_csv(r'DisneyMoviesDataset.csv')
disney = pd.merge(df_box,
                 df_plus[['title', 'rating']],
                 on='title')
disney.to_csv(r'Disney_data.csv', index=False)
#---------Data Manipulation Methods ------------

#Read the name of columns of dataframe
def read_col(df):
    for col in df.columns:
        print(col)

#----------------Loading Data-----------------
disney = pd.read_csv(r'Disney_data.csv')
disney = disney.set_index('title')
#-----------------Cleaning Data------------------

# Drop unnecessary columns
disney = disney[["Running time (int)","Budget (float)","Box office (float)","Release date (datetime)","imdb","metascore","rotten_tomatoes","Directed by","Starring","Music by","Distributed by","rating"]]

#Remove row with empty cells
disney = disney.dropna()
print(disney)

#Formating data correctly (Removing brackets and dashes)

#Directed by
disney['Directed by']= disney['Directed by'].str.replace('[',"").str.split(",").str[0]
disney['Directed by'] = disney ['Directed by'].str.replace('\'',"")
#Starring
disney['Starring']= disney['Starring'].str.replace('[',"").str.split(",").str[0]
disney['Starring'] = disney ['Starring'].str.replace('\'',"")
#Music by
disney['Music by']= disney['Music by'].str.replace('[',"").str.split(",").str[0]
disney['Music by'] = disney ['Music by'].str.replace('\'',"")
#Distributed by
disney['Distributed by']= disney['Distributed by'].str.replace('[',"").str.split(",").str[0]
disney['Distributed by'] = disney ['Distributed by'].str.replace('\'',"")


#Seperating Months and year as two variables
disney_append = disney[['Release Year','Release Month','Release Day']] = disney['Release date (datetime)'].str.split('-', expand=True)
disney.join(disney_append)
disney = disney.drop(['Release date (datetime)','Release Day'], axis=1)              
disney.to_csv(r'New_Disney_data.csv', index=True)


#Drop films made before 1968
disney.drop(disney[disney['Release Year'].astype(int) < 1968].index, inplace = True)

print("--------Dataset information--------")
print(disney)
read_col(disney)

#Save CSV file 
disney.to_csv(r'Clean_Disney_data.csv', index=True)

#-----------------Data Analysis--------------

#Frequency of top directors
import random

color = [] #creating colors
for i in range(10):
    rgb = random.uniform(0,0.3),random.uniform(0,0.5),random.uniform(0,0.5)
    color.append(rgb)
explode = [] #create explosion size
for i in range (10):
    explode.append(0.03)
explode[0]= 0.2
'''
#Figure creation
fig,axes = plt.subplots(1,2,figsize = (15,5)) 
pie = disney["Directed by"].value_counts()[:10].plot(ax = axes[0],kind = "pie",autopct = "%1.0f%%",colors = color,explode = explode,counterclock = False,ylabel = "")
disney["Directed by"].value_counts()[:10].plot(kind = "bar",color = color)
pie.legend(bbox_to_anchor =( 1,0,0.7,1),loc = "upper right")
plt.subplots_adjust(wspace = 0.6)
'''
#Which month had most releases?
'''
fig,axes = plt.subplots(1,2,figsize = (15,5)) 
pie = disney["Release Month"].value_counts()[:10].plot(ax = axes[0],kind = "pie",autopct = "%1.0f%%",colors = color,counterclock = True,ylabel = "")
disney["Release Month"].value_counts()[:10].plot(kind = "bar",color = color)
pie.legend(bbox_to_anchor =( 1,0,0.44,1),loc = "upper right")
plt.subplots_adjust(wspace = 0.25)
plt.show()
disney["Release Month"].value_counts()
'''
#Rating Count & Releases Per Year

import seaborn as sns
import numpy as np

'''
fig,axes = plt.subplots(1,2,figsize = (10,5))
release = sns.histplot(disney,x = "Release Year",kde = True,palette = "tab10")
cat = sns.histplot(disney,x = "rating",kde = True,palette = "tab10",ax = axes[0])
#cat short for categories
cat.tick_params(axis = "x",rotation = (90))
release.tick_params(axis = "x",rotation = (1000))
plt.xticks(np.arange(1930,2022,100))
plt.show()
disney["Release Year"].value_counts()[:10]
'''

#------Model Creation----------

#Removing dummy variables
df = disney[["Running time (int)","Budget (float)","Box office (float)","imdb","metascore","Release Year","Release Month"]]

#Version 1
from mpl_toolkits.mplot3d import Axes3D
from sklearn import linear_model
np.random.seed(19680801)


#3D graph Variables (budget,boxoffice,runningtime)
'''
fig=plt.figure()
ax=fig.add_subplot(111,projection='3d')
n=100
ax.scatter(disney["Budget (float)"],disney["Running time (int)"],disney["Box office (float)"],color="red")
ax.set_xlabel("Budget")
ax.set_ylabel("Running time")
ax.set_zlabel("Box office")
plt.show()
'''
#Budget vs Box

import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, linear_model, metrics
  
# load the boston dataset
boston = datasets.load_boston(return_X_y=False)
  
# defining feature matrix(X) and response vector(y)
X = df.drop(['Box office (float)'], axis=1)
y = df.values[:,3]

# splitting X and y into training and testing sets
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4,
                                                    random_state=1)
  
# create linear regression object
reg = linear_model.LinearRegression()
  
# train the model using the training sets
reg.fit(X_train, y_train)
  
# regression coefficients
print('Coefficients: ', reg.coef_)
  
# variance score: 1 means perfect prediction
print('Variance score: {}'.format(reg.score(X_test, y_test)))
  
# plot for residual error
  
## setting plot style
plt.style.use('fivethirtyeight')
  
## plotting residual errors in training data
plt.scatter(reg.predict(X_train), reg.predict(X_train) - y_train,
            color = "green", s = 10, label = 'Train data')
  
## plotting residual errors in test data
plt.scatter(reg.predict(X_test), reg.predict(X_test) - y_test,
            color = "blue", s = 10, label = 'Test data')
  
## plotting line for zero residual error
plt.hlines(y = 0, xmin = 0, xmax = 50, linewidth = 2)
  
## plotting legend
plt.legend(loc = 'upper right')
  
## plot title
plt.title("Residual errors")
  
## method call for showing the plot
plt.show()

#------Explaination-------
# importing the required module
import matplotlib.pyplot as plt

# x axis values
x = [1,2,3]
# corresponding y axis values
y = [2,4,1]

# Month Graph
disney = disney.sort_values(by=['Release Month'])

print("---------")
print(disney[['Box office (float)','Release Month']])
print(disney["Release Month"])

#read_col(months)
# plotting the points
plt.scatter(disney["Release Month"], disney["Box office (float)"])

# naming the x axis
plt.xlabel('Month')
# naming the y axis
plt.ylabel('Box Office (Dollars)')

# giving a title to my graph
plt.title('Month of the Year vs Box Office')

# function to show the plot
plt.show()

# Budget Graph
disney = disney.sort_values(by=['Budget (float)'])


# plotting the points
plt.scatter(disney["Budget (float)"], disney["Box office (float)"])

# naming the x axis
plt.xlabel('Budget')
# naming the y axis
plt.ylabel('Box Office (Dollars)')

# giving a title to my graph
plt.title('Budget vs Box Office')

# function to show the plot
plt.show()

