library(plyr)

if(!file.exists("./cleandata")){dir.create("./cleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./cleandata/project.zip")

unzip(zipfile = "./cleandata/project.zip", exdir = "./cleandata")

x_train <- read.table("./cleandata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./cleandata/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./cleandata/UCI HAR Dataset/train/subject_train.txt")

x_test <-read.table("./cleandata/UCI HAR Dataset/test/X_test.txt")
y_test <-read.table("./cleandata/UCI HAR Dataset/test/Y_test.txt")
subject_test <-read.table("./cleandata/UCI HAR Dataset/test/subject_test.txt")

features <-read.table("./cleandata/UCI HAR Dataset/features.txt")

activity_labels =read.table("./cleandata/UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activity_labels) <- c("activityID", "activityType")

alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

colNames <- colnames(finaldataset)

mean_std <- (grepl("activityID", colNames)|
             grepl("subjectID", colNames)|
             grepl("mean..", colNames)|
             grepl("std...", colNames)
  )

setMeanandStd <-finaldataset[,mean_std == TRUE]

setwithActivityNames <- merge(setMeanandStd, activity_labels,by = "activityID", all.x = TRUE)

tidySet <- aggregate(. ~subjectID + activityID, setwithActivityNames,mean)
tidySet <- tidySet[order(tidySet$subjectID,tidySet$activityID),]

write.table(tidySet, "tidySet.txt", row.names = FALSE)




