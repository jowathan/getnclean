---
title: "README"
author: "Jo Wathan"
date: "19 June 2016"
output: html_document
---
Jo Wathan 
19 June 2016

# README.txt
## Human Activity Recognition Using Smartphones Summary Analysis Datasets
### Content of the project files

The project consists of:   
* This README  
* Two data files suitable for analysis: mainanalysis.txt and meandata.txt  
* Codebook.md which contains a list of the variable   
* gacda.R which contains the R script which reads the data in, manipulates it and writes out both data files  
* mainanalysis.txt contains summarised observations of accelerometry and gyrometry data in three dimensions x,y and z for 30 subjects undertaking 6 activities
* meandata.txt is an aggregation of mainanalysis, which provides means of observations in mainanalysis grouped by subject and activity


### The origin of the data
The data were sourced from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%Dataset.zip  
The data were unzipped prior to running the script

These data were not drawn from their original source which is:  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
more information about the meaning of the data can be found in the codebook

### The script is not completely context free and would require minor edits to run on another machine
*While virtually all data manipulation can be run as is, there are a couple of references to the authors own file path structure.  These should be edited as appropriate    
* As already mentioned, the data are assumed to have already been unzipped to a subfolder 

##Relationship of the files to each other
1.Unzip the data to a subdirectory of the working directory - use the preexisting folder name.  The folder will contain a number of text data documents as well as information about the labels.  
2. Run gacda.R to generate the two clean(ish!) datasets: mainanalysis.txt and meandata.txt.  meandata.txt is an aggregation of mainanalysis.txt and cannot be produced without it.  



