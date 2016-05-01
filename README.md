
---
title: "README"
author: "Chemba Ranganathan"
date: "April 30, 2016"
output: html_document
---

### Project Description
The purpose of this project is to demonstrate one's ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. The project does the following

    * 1. Creates a tidy data set 
    
    * 2. Provides a link to a Github repository with your script for performing the analysis
    
    * 3. Provides a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md. 
    
    * 4. Provides a README.md in the repo with  scripts. This repo explains how all of the scripts work and how they are connected.
    
The script transforms the raw data into tidy data by doing the following steps

    * 1. Merges the training and the test sets to create one data set.
    
    * 2. Extracts only the measurements on the mean and standard deviation for each measurement.
    
    * 3. Uses descriptive activity names to name the activities in the data set
    
    * 4. Appropriately labels the data set with descriptive variable names.
    
    * 5.Creates an independent tidy data set with the average of each variable for each activity and each subject.

### Repository

    The repository consists of four files

    * run_analysis.R - R sript that analyzes the raw data and transforms it into tidy data
    
    * CodeBook.md - Explains the raw and tidy data set and specifies the variables that are present in the data set and a summary of the tidy data
    
    * README.md - This file 
    
    * TidyData.txt - Output file that has the tidy data

### Requirements

    reshape2 package is required for the execution of the R script. This can be installed using 
        install.packages("reshape2")
    
### Execution

    * Download the R script to the directory of your choice
    
    * In the R console set the directory to this directory using setwd() command
    
    * Source the R script using source("run_analysis.R")
    
    * Execute using runAnalysis()
    
    * The script downloads the raw  data into "data" directory 
    


### Result

    * Result of the execution is written into "result" directory
    
    * Output is a tab seperated "TidyData.txt"" file
    
### Analyising the result

    * Read the result into a tidyData set using
    
      tidyData <- read.csv("result/TidyData.txt", sep = "\\t")
    
    * str(tidyData) - Gives an overview/ summary of the tidy data set
    
    * names(tidyData) - Gives the variable names in the tidy data set
    
