#import all the needed data
X_test <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/test/X_test.txt", quote="\"")
X_train <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/train/X_train.txt", quote="\"")
subject_train <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject_test <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/test/subject_test.txt", quote="\"")
y_test <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/test/y_test.txt", quote="\"")
y_train <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/train/y_train.txt", quote="\"")
features <- read.table("~/Rcoursera/Proyecto data cleaning/UCI HAR Dataset/features.txt", quote="\"")
#load packages to work with the data
library("dplyr", lib.loc="~/R/win-library/3.1")
library("reshape2", lib.loc="~/R/win-library/3.1")
#create a laber to label each observation as a training observation or testing observation
treatment<-c(rep("train",times=7352),rep("test",times=2947))
#get the subject code of the train and test treatment toghether
subject<- rbind(subject_train,subject_test)
#get the activity code of train and test together
activity<-rbind(y_train, y_test)
#get the data from train and test treatment together
database<-rbind(X_train, X_test)
#Change the name of the columns so that they are more understandable and put those names to the database
features<-as.character(features[,2])
features<-gsub("Acc","Accelerometer",features)
features<-gsub("Gyro","Gyroscope",features)
features<-gsub("f","Fourier",features)
colnames(database)<-(features)
#extract from the database only the columns that are means or standard deviations
database.2 <- database[,c(1,2,3,4,5,6,41,41,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543)]
#indicate if each observation is for training or testing
database.3<-cbind(treatment,database.2)
#indicate the subject for each observbation
database.4<-cbind(subject,database.3)
#change the name of V1 to subject in order to keep the variables readable
database.5<-rename(database.4, Subject=V1)
database.6<-cbind(activity,database.5)
#change the name of V1 to Activity in order to keep the variables readable
database.7<-rename(database.6, Activity=V1)
#change the activity variable to a factor variable and change the levels to the actual name of the activity
database.7$Activity <-as.factor(database.7$Activity)
levels(database.7$Activity)<-c("Walking", "Walking upstairs", "Walking downstairs", "Sitting", "Standing", "Laying")
#Transform dataset to "smaller" dataset
melt.database <- melt (database.7, id=c("Activity", "Subject", "treatment"),measure.vars=colnames(database.7[,4:69]))
melt.database3<-dcast (melt.database, Activity+Subject~variable, mean)
write.table(melt.database3, file="excercise5.txt", row.names=FALSE)