# Statistics in R Class 2 In-Class Code
library(ggplot2)
library(stringr)

setwd("~/Documents/R_Class_Meetup/Statistics/Class2")

# Read in  state_prescribe_overdose_data.csv
opioid.df <- read.csv("state_prescribe_overdose_data.csv", stringsAsFactors = F)

# Subsetting data to just the southern region
opioid.south <- subset(opioid.df, region == "South")

# Printing summary statistics of the prescribing.rate and overdose.rate variables for south data frame
summary(opioid.south$prescribing.rate)
summary(opioid.south$overdose.rate)

# Review from last week: Z-Score Exercise
# Using the above example, find the zscore of a prescribing.rate of 105 in opioid.south
mean.prescribe.south <- mean(opioid.south$prescribing.rate, na.rm = T)
sd.prescribe.south <- sd(opioid.south$prescribing.rate, na.rm = T)

zscore.south.105 <- (105 - mean.prescribe.south)/sd.prescribe.south
zscore.south.105

# Demonstrating confidence interval
# Checking for missing values in overdose.rate
table(is.na(opioid.df$overdose.rate))
# Removing missing values
# Finding approximate population mean of all states' overdose rates (not true population mean due to missing values but will be close)
opioid.noNA.overdose <- subset(opioid.df, !is.na(overdose.rate))
pop.mean.od = mean(opioid.noNA.overdose$overdose.rate)
pop.mean.od

# Makes it so we will all get the same answer every time we run it
set.seed(47)

# Pulling random sample of 450 observations from entire list of overdose rates
sample.values.od <- sample(opioid.noNA.overdose$overdose.rate, 450, replace = FALSE)

# Finding mean of sample values
mean.sample.od <- mean(sample.values.od)
mean.sample.od

n.sample.od <- length(sample.values.od)

# Calculating standard error
se.sample.od <- sd(sample.values.od)/sqrt(n.sample.od)
se.sample.od

# Find 95% confidence interval of the mean
ci.lower.bound.od <- mean.sample.od - 1.96*se.sample.od
ci.lower.bound.od
ci.upper.bound.od <- mean.sample.od + 1.96*se.sample.od
ci.upper.bound.od
pop.mean.od

# Creating a sample of prescribing rates
# First find population mean (true population mean because no NA values)
pop.mean.prescribe = mean(opioid.noNA.overdose$prescribing.rate)
pop.mean.prescribe

# NOTE: There are no NA or missing values in prescribing rates
sample.prescribe <- sample(opioid.df$prescribing.rate, 450, replace = F)

# Now finding the confidence interval of the prescribing.rate like we did with overdose.rate
# Finding mean of sample values
mean.prescribe <- mean(sample.prescribe)
mean.prescribe

# Pulls number of values in sample
n.prescribe = length(sample.prescribe)
n.prescribe

# Calculating standard error
se.prescribe <- sd(sample.prescribe)/sqrt(n.prescribe)
se.prescribe

# Find 95% confidence interval of the mean
ci.lower.bound.pres <- mean.prescribe - 1.96*se.prescribe
ci.lower.bound.pres
ci.upper.bound.pres <- mean.prescribe + 1.96*se.prescribe
ci.upper.bound.pres
pop.mean.prescribe

# Calculate the 95% confidence intervals as I did above for the south.df data frame
# Do it for both prescribing.rate and overdose.rate
# Now I will subset to just the south, and you should try again
south.df <- subset(opioid.df, (region == "South"))
# Checking for missing values
table(is.na(south.df$overdose.rate))
# Calculating population mean
population.mean <- mean(south.df$overdose.rate)
population.mean

population.mean.pres <- mean(south.df$prescribing.rate)
population.mean.pres

set.seed(47)
# Creating random sample of South overdose values
sample.south.od <- sample(south.df$overdose.rate, 150, replace = F)

# Exercise: Now repeat calculating 95% confidence intervals for sample of southern state overdose rates
mean.south.od <- mean(sample.south.od)
mean.south.od

n.od.south <- length(sample.south.od)

se.od.south <- sd(sample.south.od)/sqrt(n.od.south)

lb.od.south <- mean.south.od - 1.96*se.od.south
up.od.south <- mean.south.od + 1.96*se.od.south

# Creating random sample of South prescribing rates
set.seed(47)
sample.south.pres <- sample(south.df$prescribing.rate, 150, replace = F)

# Now repeat with south prescribing rates
mean.pres.south <- mean(sample.south.pres)

n.pres.south <- length(sample.south.pres)

se.pres.south <- sd(sample.south.pres)/sqrt(n.pres.south)

lb.pres.south <- mean.pres.south - 1.96*se.pres.south
ub.pres.south <- mean.pres.south + 1.96*se.pres.south
