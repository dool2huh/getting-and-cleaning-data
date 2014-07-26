library(reshape)

# 1. Merges the training and the test sets to create one data set.

tmp1 <- read.table("train/X_train.txt")
tmp2 <- read.table("test/X_test.txt")
X <- rbind(tmp1, tmp2)


tmp1 <- read.table("train/y_train.txt")
tmp2 <- read.table("test/y_test.txt")
Y <- rbind(tmp1, tmp2)

tmp1 <- read.table("train/subject_train.txt")
tmp2 <- read.table("test/subject_test.txt")
S <- rbind(tmp1, tmp2)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features = read.table("features.txt", sep="", header=FALSE)
good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

# assign cleaner name
X <- X[, good_features]
names(X) <- features[good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X)) 


# 3. Uses descriptive activity names to name the activities in the data set
activityLabels = read.table("activity_labels.txt", sep="", header=FALSE)
Y[,2] = activityLabels[Y[,1], 2]
names(Y) <- c("activity_id", "activity_name")

# 4.Appropriately labels the data set with descriptive variable names. 

names(S) <- "subject"
combined <- cbind(S, Y, X)

combined$activity_id <- as.factor(combined$activity_id)
combined$activity_name <- as.factor(combined$activity_name)
combined$subject <- as.factor(combined$subject)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy = aggregate(combined, by=list(activity_id = combined$activity_id, activity_name = combined$activity_name, subject=combined$subject), mean)

tidy[,6]=NULL
tidy[,5]=NULL
tidy[,4]=NULL


write.table(tidy, file = "./tidy_data.txt")