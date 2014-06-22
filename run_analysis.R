rm(list=ls(all=TRUE))


# download file

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="UCI HAR Dataset.zip",method="curl")
unzip("UCI HAR Dataset.zip", overwrite=TRUE)

setwd("UCI HAR Dataset")



#Step 1: "Merges the training and the test sets to create one data set."

# read data

# featurefiles
name_feat = read.table('features.txt')["V2"]
#name_feat<-name_feat$V2
activity_labels = read.table('activity_labels.txt')["V2"]
#activity_labels<-activity_labels$V2

mean_std_idx = grepl( '(-mean\\(\\)|-std\\(\\))', name_feat$V2)


# datasets
X_train<- read.table("train/X_train.txt")
Y_train<- read.table("train/Y_train.txt")
subject_train<- read.table("train/subject_train.txt")

X_test<- read.table("test/X_test.txt")
Y_test<- read.table("test/Y_test.txt")
subject_test<- read.table("test/subject_test.txt")


# name the headers

names(X_train) = name_feat$V2
names(X_test) = name_feat$V2
names(Y_train)<-"labels"
names(Y_test)<-"labels"
names(subject_test)<-"subjects"
names(subject_train)<-"subjects"



# Extract only the std and mean measures
means_and_std_colnames<-colnames(X_test)[mean_std_idx]

X_test_std_mean<-cbind(subject_test,Y_test,subset(X_test,select=means_and_std_colnames))

X_train_std_mean<-cbind(subject_train,Y_train,subset(X_train,select=means_and_std_colnames))

# Merge the training and the test sets to create one data set.

ALL_data<-rbind(X_test_std_mean, X_train_std_mean)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject

tidy_data<-aggregate(ALL_data[,3:ncol(ALL_data)],list(Subject=ALL_data$subjects, Activity=ALL_data$labels), mean)

tidy_data<-tidy_data[order(tidy_data$Subject),]

# Use activity names instead of numbers

tidy_data$Activity<-activity_labels[tidy_data$Activity,]

write.table(tidy_data, file="./tidy_samsung_data.txt", sep="\t", row.names=FALSE)




