## Getting and Cleaning Data Assessment.
## Scriptname = "gacda"
## Date (ddmmyy) = 17/06/16
## Author = Jo Wathan
## File structure 
##   - assumes .r file in working directory
##   - assumes data already unzipped as a directory called URI HAR dataset

## start by assessing the structure of each file and reading it in
## having had a look at the structure of the data, am assuming that there are only txt files and dirs

## work out what to do with the inertial thingies

setwd("C:/Users/Jo/R/getnclean")
if(!file.exists("./data")) {dir.create("./data")}

## go shopping for packages we're going to need (assumes already installed)
library(dplyr)
library(reshape2)

## read all of the files in from the upper directory and get some info about thier structure
lsdown1 <- dir("UCI HAR Dataset")
txtdatatop = dir("UCI HAR Dataset", pattern=".txt")
n <- length(txtdatatop)

mydatatop <- vector("list", n)

for(i in 1:n) {
     fp <- file.path("UCI HAR Dataset", txtdatatop[i])
     mydatatop[[i]] <- read.table(fp, fill=TRUE)
     str(mydatatop[[i]])
     head(mydatatop[[i]])
}

##note to self - useful page: http://stackoverflow.com/questions/9982269/applying-r-script-prepared-for-single-file-to-multiple-files-in-the-directory?rq=1

#for 1 to n, get name from txtdata top. write the data.table as that name

for(i in 1:n) {
     nowdata <- data.frame(mydatatop[[i]])
     assign(txtdatatop[i],nowdata)
}

# repeat this for the files from the test subdirectory
lstest <- dir("UCI HAR Dataset/test")
txtdatatest = dir("UCI HAR Dataset/test", pattern=".txt")
ten <- length(txtdatatest)

mydatatest <- vector("list", ten)

for(i in 1:ten) {
     fpten <- file.path("UCI HAR Dataset", "test", txtdatatest[i])
     mydatatest[[i]] <- read.table(fpten, fill=TRUE)
     str(mydatatest[[i]])
     head(mydatatest[[i]])
}

for(i in 1:ten) {
     nowdata <- data.frame(mydatatest[[i]])
     assign(txtdatatest[i],nowdata)
}

#and again for the train subdirectory
lstrain <- dir("UCI HAR Dataset/train")
txtdatatrain = dir("UCI HAR Dataset/train", pattern=".txt")
trn <- length(txtdatatrain)

mydatatrain <- vector("list", trn)

for(i in 1:trn) {
     fptrn <- file.path("UCI HAR Dataset","train", txtdatatrain[i])
     mydatatrain[[i]] <- read.table(fptrn, fill=TRUE)
     str(mydatatrain[[i]])
     head(mydatatrain[[i]])
}

for(i in 1:trn) {
     nowdata <- data.frame(mydatatrain[[i]])
     assign(txtdatatrain[i],nowdata)
}

#get rid of temp file to avoid confusion
rm(nowdata)
     
#now have a bunch of data frames with ugly names!

##REQUIREMENT 1 - COMBINING TEST AND TRAIN TO FORM ONE DATASET
##start work on putting it together.
##label cols as I go
allsubj <- rbind(subject_test.txt, subject_train.txt)
names(allsubj)<-"subjectid"
allX <- rbind(X_test.txt, X_train.txt)
names(allX) <-(features.txt[,2])
allsubjX <- cbind(allsubj, allX)
ally <- rbind(y_test.txt, y_train.txt)
names(ally) <-"activity"
allsubjxy <-cbind(allsubjX, ally)

##REQUIREMENT 4 - APPROPRIATE LABELS 
##time to start pulling out the vars with Mean or mean or std
##inelegant but haven't found a way to do it in one go, so doing 3 substitutions and rematching names
allsubjxy1 <- gsub("())","",names(allsubjxy))
allsubjxy2 <- gsub("\\(","", allsubjxy1)
allsubjxy3 <- gsub("-", "", allsubjxy2)
allsubjxy4 <- gsub(",", "", allsubjxy3)
allsubjxy5 <- tolower(allsubjxy4)
allsubjxy6 <- gsub("\\.","", allsubjxy5)
#remove duplications in cols without eradicating data
#this is a subjective decision - others may have dropped the columns
allsubjxy7 <-make.unique(allsubjxy6, sep="ver")
#apply names to df
names(allsubjxy) <-(allsubjxy7)

##REQUIREMENT 2 - EXTRACTS ONLY MEANS AND STANDARD DEVIATIONS
## select just those cols labelled mean/std
## include subjectid and activity to permit requirement 5
selectcols <-(grep("mean|std|subject|activity",names(allsubjxy)))
mainanalysis <- select(allsubjxy, selectcols)

##REQUIREMENT 3 - USES DESCRIPTIVE NAMES TO NAME ACTIVITIES
##turn activity to factor and label, tidy the labels first
activitylabels1 <- gsub("_","",activity_labels.txt[,2])
activitylabels2 <- tolower(activitylabels1)
mainanalysis$activity <- factor(mainanalysis$activity, labels = activitylabels2)
mainanalysis$subjectid <- factor(mainanalysis$subjectid)

##FINALLY THE FIRST ANALYSIS DATASET
write.table(mainanalysis, "C:/Users/Jo/R/getnclean/data/mainanalysis.txt")

##REQUIREMENT 5 - CREATES SEPARATE FILE BY SUBJECTS AND ACTIVITY
meltdata <- melt(mainanalysis, id=c("subjectid", "activity"), na.rm=TRUE)
meandata <-dcast(meltdata,...~variable, mean)
write.table(meandata, "C:/Users/Jo/R/getnclean/data/meandata.txt")

##codebook generation
cbmain <-codebook(mainanalysis)
cbmean <-codebook(meandata)

Write(cbmain,file="C:/Users/Jo/R/getnclean/data/cbmain.txt")
Write(cbmean,file="C:/Users/Jo/R/getnclean/data/cbmean.txt")
     