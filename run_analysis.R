
## An R Script that analyzes the data from a  "Human Activity Recognition"
## database built from the recordings of 30 subjects performing activities
## of daily living (ADL) while carrying a waist-mounted smartphone with 
## embedded inertial sensors.

## In the analysis the R Script does the following
## 1. Merges the training and the test sets to create a single data set.
## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.

runAnalysis <- function() {
    
    ## Load the library for data.table, melt and dcast
    library(reshape2)
    
    ## File/ URLs in which the data is stored
    dataURL <-
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    datadir <- "./data"
    resultdir <- "./result"
    dataFileDir <- paste0(datadir, "/UCI HAR Dataset")
    zipFile <- paste0(datadir, "/getdata-projectfiles-UCI HAR Dataset.zip")
    
    trainXFile <- paste0(dataFileDir, "/train/X_train.txt")
    trainYFile <- paste0(dataFileDir,"/train/y_train.txt")
    trainSubjectFile <- paste0(dataFileDir,"/train/subject_train.txt")
    
    testXFile <- paste0(dataFileDir,"/test/X_test.txt")
    testYFile <- paste0(dataFileDir,"/test/y_test.txt")
    testSubjectFile <- paste0(dataFileDir,"/test/subject_test.txt")
    
    featureFile <- paste0(dataFileDir,"/features.txt")
    activitiesFile <- paste0(dataFileDir, "/activity_labels.txt")
    
    ## Create data and result directories
    
    if (!file.exists(datadir)) {
        dir.create(datadir)
    }
    if (!file.exists(resultdir)) {
        dir.create(resultdir)
    }
    
    ## Download and unzip file
    if (!file.exists(zipFile)) {
        download.file(dataURL, zipFile, method = "curl")
    }

    if (!file.exists(dataFileDir)) {
        unzip(zipFile, exdir = datadir)
    }
    
    ## Get data from files 
    ## Convert the factor variable to character for later manipulation
    
    activities <- read.table(activitiesFile,
                             col.names = c("ActivityId", "ActivityLabel"))

    ## Uses descriptive activity names to name the activities in the data set
    activities$ActivityLabel <- as.character(activities$ActivityLabel)
    
    features <- read.table(featureFile,
                           col.names = c("FeatureId", "FeatureLabel"))
    
    features$FeatureLabel <- as.character(features$FeatureLabel)
    
    ## Extracts only the measurements on the mean and standard deviation 
    ## for each measurement.
    reqdFeatures <- 
        features[grep(".*mean.*|.*std.*", features$FeatureLabel),]$FeatureId
    
    reqdFeatureLabels <- 
        features[grep(".*mean.*|.*std.*", features$FeatureLabel),]$FeatureLabel
    
    ## Assign meaningful names to the features/measurements
    reqdFeatureLabels <- gsub("\\(|\\)", "", reqdFeatureLabels)
    reqdFeatureLabels <- gsub('Acc',"Acceleration",reqdFeatureLabels)
    reqdFeatureLabels <- gsub('Mag',"Magnitude",reqdFeatureLabels)
    reqdFeatureLabels <- gsub('^t',"TimeDomain.",reqdFeatureLabels)
    reqdFeatureLabels <- gsub('^f',"FrequencyDomain.",reqdFeatureLabels)
    reqdFeatureLabels <- gsub("mean","Mean",reqdFeatureLabels)
    reqdFeatureLabels <- gsub('std',"StandardDeviation",reqdFeatureLabels)
    reqdFeatureLabels <- gsub('Freq$',"Frequency",reqdFeatureLabels)
    

    ## Get testing and training data for the required features
    trainXData <- read.table(trainXFile)[reqdFeatures]
    trainYData <- read.table(trainYFile)
    trainSubject <- read.table(trainSubjectFile)
    
    
    testXData <- read.table(testXFile)[reqdFeatures]
    testYData <- read.table(testYFile)
    testSubject <- read.table(testSubjectFile)
    
    ## Combine and make a single train data and test data
    trainData <- cbind(trainSubject, trainYData, trainXData)
    
    testData <- cbind(testSubject, testYData, testXData)
 
    ##  Merges the training and the test sets to create a single data set.
    combinedData <- rbind(trainData, testData)
    colnames(combinedData) <- c("Subject", "Activity", reqdFeatureLabels)

    ##  Creates a second, independent tidy data set with the average of
    ##  each variable for each activity and each subject.
    
    combinedData$Activity <- factor(combinedData$Activity,
                                    levels = activities$ActivityId,
                                    labels = activities$ActivityLabel)
    
    combinedData$Subject <- as.factor(combinedData$Subject)
    
    meltedData <- melt(combinedData, id = c("Subject", "Activity"))
    
    ## Final data (the tidy data set)
    meanData <-
        dcast(meltedData, Subject + Activity ~ variable, mean)
    
    ## Change Subject name to Subject1 Subject2 instead of integer values
    meanData$Subject <- paste0("Subject", meanData$Subject)
    
    ## Write the tidy data set
    write.table(meanData,"./result/TidyData.txt",
                row.names = FALSE,
                quote = FALSE,sep = "\t")
    
    
}