# Solution to Programming assignment for Coursera Data Cleaning Course
# The soulution is implemented as a function run_analysis
# To execute the solution, 'source(run_analysis.R)' and execute run_analysis()
# No parameters are passed to the function
#
# The solution is implemented in 5 parts, as described in the problem description
# though not in the same order

# The soulution assumes that the data files in in 'test' and 'train' 
# folders/directories in the current working directory where the script is
# executed

run_analysis <- function() {
    # Part 1. - Merges the training and the test sets to create one data set
    # This part reads in training and test subjects, labels, observations and merges 
    # them together
    
    # Read in the subjects into data frame
    print("Reading subjects....")
    trainSubjects <- read.table("./train/subject_train.txt", header = FALSE)
    testSubjects <- read.table("./test/subject_test.txt", header = FALSE)
    
    # Merge the training and test Subjects data
    print('Merging training and test Subjects....')
    mergedSubjects <- rbind(trainSubjects, testSubjects)
    
    # Read in the labels into data fram
    print("Reading labels...")
    trainLabels <- read.table("./train//y_train.txt", header = FALSE)
    testLabels <- read.table("./test/y_test.txt", header = FALSE)
    
    # Merge training and test Labels 
    print("Merging labels...")
    mergedLabels <- rbind(trainLabels, testLabels)

    # Read in the training and test observations and merge it
    print("Reading training observations...")
    trainMeasure <- read.table("./train/X_train.txt", header = FALSE)
    print("Reading test observations...")
    testMeasure <- read.table("./test/X_test.txt", header = FALSE)
    mergedMeasure <- rbind(trainMeasure, testMeasure)
    
    # Merge all 3 datasets together
    mergedData <- cbind(mergedSubjects, mergedLabels, mergedMeasure)
    
    # Part 2. Appropriately labels the data set with descriptive variable names.
    # andxtract only relevant indicators
    #
    colnames(mergedData)[1] <- "Subject"
    colnames(mergedData)[2] <- "Label"
    
    # Read in Features and store it in a vector
    print("Reading and merging features... ")
    features <- read.table('./features.txt', header = FALSE)
    featureVector <- features[["V2"]]
    
    ## According to features_info.txt, mean and starndard deviation
    ## are indiated in the set of variables with mean() and std()
    ##
    ## Filter the featureVector so that only column names
    ## that contain "mean()" & "std()" are included
    featureFilter <- featureVector[grep("mean\\(\\)|std\\(\\)", featureVector)]
    featureFilter <- c("Subject", "Label", as.character(featureFilter))
    
    # Assign column names to mergedData
    colnames(mergedData)[3:563] <- as.character(featureVector)
    
    # Retain only those columns relating to mean and standard deviation indicators
    mergedData <- mergedData[, as.character(featureFilter)]
    
    # Part 3. Uses descriptive activity names to name the activities in the data set
    
    # Read in the activity file
    print("Reading activity file...")
    activity <- read.table("./activity_labels.txt", header = FALSE)
    colnames(activity) <- c("Label", "Activity")
    
    # Merge in the activity file and remove duplicate column
    print("Merging activity file...")
    mergedData <- merge(activity, mergedData, x.by = "Label", y.by = "Label")
    mergedData <- mergedData[-1]
    
    # Part 4. - Cleanup the variable names.
    
    # Remove hypens and parenthesis from the 
    colnames(mergedData) <- gsub("\\-std\\(\\)\\-", "Std", colnames(mergedData))
    colnames(mergedData) <- gsub("\\-std\\(\\)", "Std", colnames(mergedData))
    colnames(mergedData) <- gsub("\\-mean\\(\\)\\-", "Mean", colnames(mergedData))
    colnames(mergedData) <- gsub("\\-mean\\(\\)", "Mean", colnames(mergedData))
    
    ## Part 5. - Prepare summarized data which calculates mean of all columns by
    ## Subject, Activity
    print("Preparing summary data...")
    summData <- aggregate(mergedData, 
                          by=list(mergedData$Subject, mergedData$Activity), 
                          FUN=mean, na.action = na.omit)
    summData[-c(1, 3)]
    names(summData[, 1]) <- "Subject"
    
    write.table(summData, file = 'summData.txt', row.names = FALSE)
}