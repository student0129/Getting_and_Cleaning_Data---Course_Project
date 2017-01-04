# r script for performing the following analyses:
# 0. extracting data collected from the accelerometers from the Samsung Galaxy S smartphone
# 1. merging the training and the test sets to create one data set
# 2. extracting only the measurements on the mean and standard deviation for each measurement
# 3. using descriptive activity names to name the activities in the data set
# 4. labeling the data set with descriptive variable names
# 5. creating a tidy data set with the average of each variable for each activity and each subject

# set working directory
setwd("~/MOOC - Data Science/Part 3/Course Project")

# 0.
# read features and activity-labels
features = read.table('./UCI HAR Dataset/features.txt', header = FALSE)
activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)

# read train data
x_train = read.table('./UCI HAR Dataset/train/X_train.txt', header = FALSE)
subject_train = read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE)
y_train = read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE)

# read test data
x_test = read.table('./UCI HAR Dataset/test/X_test.txt', header = FALSE)
subject_test = read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE)
y_test = read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE)

# assign column names to datasets
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]
colnames(subject_train) <- "SubjectID"
colnames(subject_test) <- "SubjectID"
colnames(y_train) <- "ActivityID"
colnames(y_test) <- "ActivityID"

# 1.
# combining all train data
train_data <- cbind(x_train, subject_train, y_train)

#combining all test data
test_data <- cbind(x_test, subject_test, y_test)

# combining train data and test data
data <- rbind(train_data, test_data)

# 2.
# extracting only the measurements on the mean and standard deviation
condition <- (grepl("mean\\(" , names(data)) | 
                      grepl("std\\(" , names(data)) |
                      grepl("ActivityID" , names(data)) | 
                      grepl("SubjectID" , names(data))
              )

newdata <- data[condition == TRUE]

# 3.
# adding descriptive activity names to the data set
newdata <- merge(newdata, activity_labels, by.x = "ActivityID", by.y = "V1", all.x = TRUE)
newdata <- newdata[,-1]
colnames(newdata)[colnames(newdata) == "V2"] <- "ActivityType"

# 4.
# cleaning variable names
colnames(newdata) <- gsub("mean\\(\\)", "Mean", names(newdata))
colnames(newdata) <- gsub("std\\(\\)", "StandardDeviation", names(newdata))
colnames(newdata) <- gsub("^t", "Time", names(newdata))
colnames(newdata) <- gsub("^f", "Frequency", names(newdata))
colnames(newdata) <- gsub("BodyAcc", "BodyLinearAcceleration", names(newdata))
colnames(newdata) <- gsub("BodyGyro", "BodyAngularVelocity", names(newdata))
colnames(newdata) <- gsub("GravityAcc", "GravityAcceleration", names(newdata))
colnames(newdata) <- gsub("Mag", "Magnitude", names(newdata))
colnames(newdata) <- gsub("(Body)\\1+", "\\1", names(newdata))
colnames(newdata)

# 5.
# creating a new tidy dataset with the average of each variable for each activity and each subject
secondtidydata <- aggregate(newdata[, colnames(newdata) != c("SubjectID", "ActivityType")],
          by = list(SubjectID = newdata$SubjectID, ActivityType = newdata$ActivityType), mean)

write.table(secondtidydata, './secondtidydata.txt', sep='\t', row.names = FALSE)
