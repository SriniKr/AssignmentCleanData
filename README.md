---
title: "run_analysis.R"
output: html_document
---

run_analysis.R consists of a single function:
**run_analysis()
- no parameters are needed to be passed to the function
- the run_analysis.R has to be sourced before the call to the function
- it is assumed that the data files are available in the same tree structure
  as the zip file.

The function is used to clean the samsung data for the Course Assignment

The function performs the following steps:
- Step 1. - Merges the training and the test sets to create one data set
- Step 2. - Appropriately labels the data set with descriptive variable names
- Step 3. - Uses descriptive activity names to name the activities in the data set
- Step 4. - Cleanup the variable names
- Step 5. - Prepare summarized data
