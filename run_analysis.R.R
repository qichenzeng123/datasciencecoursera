## Qichen Zeng
## Getting and Cleaning data course project
## Week 4 final project
## Merge the training and the test sets
## label the data set
## export a tidy data set tidy_data.txt

library(data.table)
library(reshape2)

## read in activity labels
activitylabels <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/activity_labels.txt")[,2]

## read in data columns/features 
featuretables <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/features.txt")[,2]

## Extract only the measurements on the mean and standard deviation for each measurement.
stdevfeatures <- grepl("mean|std", featuretables)

## reading in x and y tables
xtable<- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/test/X_test.txt")
ytable <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/test/y_test.txt")
subjectable <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/test/subject_test.txt")

names(xtable) = featuretables

# Extract only the measurements on the mean and standard deviation for each measurement.
xtable = xtable[,stdevfeatures]

# Load activity labels
ytable[,2] = activitylabels[ytable[,1]]
names(ytable) = c("Activity_ID", "Activity_Label")
names(subjectable) = "subject"

# Bind data
testingset <- cbind(as.data.table(subjectable), ytable, xtable)

# Load and process X_train & y_train data.
Xtrain <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/train/y_train.txt")

trainingsubject <- read.table("C:/Users/qiche/Desktop/R/UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = featuretables

# Exact the features
Xtrain = Xtrain[,stdevfeatures]

# input the activity data 
ytrain[,2] = activitylabels[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(trainingsubject) = "subject"

## combine the data set
trainingset <- cbind(as.data.table(trainingsubject), ytrain, Xtrain)

## combine the testing set and training set
finaldata = rbind(testingset, trainingset)

id1  = c("subject", "Activity_ID", "Activity_Label")
datalabels = setdiff(colnames(finaldata), id1)
melteddata     = melt(finaldata, id = id1, measure.vars = datalabels)

# Mean function
tidy_data   = dcast(melteddata , subject + Activity_Label ~ variable, mean)

## write the final text file to C drive
write.table(tidy_data, file = "C:/Users/qiche/Desktop/R/UCI HAR Dataset/tidy_data.txt")