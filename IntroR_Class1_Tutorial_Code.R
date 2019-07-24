# Introduction to R Programming
# Class 1 Tutorial Code
library(psych)

# Set working directory so exported files will be dumped to this folder
setwd("~/Documents/Website/Class1/Results")

# Read in county-level opioid prescribing data
# stringsAsFactors = F changes your string variables into character variables not factor variables
opioid.df <- read.csv("~/Documents/Website/Class1/state_prescribe_overdose_data.csv", stringsAsFactors = F)

# Find and print mean prescribing rate
mean(opioid.df$prescribing.rate)
mean(opioid.df$overdose.rate, na.rm = TRUE)

# Assign mean values to a variable
mean.prescribing <- mean(opioid.df$prescribing.rate)
mean.overdose <- mean(opioid.df$overdose.rate, na.rm = TRUE)

# It is not necessary to understand what correlation is, this is an example function
cor.test(opioid.df$prescribing.rate, opioid.df$overdose.rate, na.rm = TRUE)

# Install packages command, install psych package
#install.packages("psych")

# Load psych package
library(psych)

# Creating summary data frames to demonstrate how to export files
mean.prescribe.by.year <- describeBy(opioid.df$prescribing.rate, group = opioid.df$year, mat = TRUE)
mean.overdose.by.year <- describeBy(opioid.df$overdose.rate, group = opioid.df$year, mat = TRUE)

# Export summary statistics as .csv files to your working directory
write.csv(mean.prescribe.by.year, "mean_prescribing_by_year.csv")
write.csv(mean.overdose.by.year, "mean_overdose_by_year.csv")

