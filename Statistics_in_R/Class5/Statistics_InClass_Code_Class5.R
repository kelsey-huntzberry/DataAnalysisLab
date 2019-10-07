# Statistics in R Class #5, Chi Square

# Set working directory
setwd("~/Documents/R_Class_Meetup/Statistics/Class5")

# Read kin tuberculosis data
tuberculosis <- read.csv("tuberculosis_results.csv", stringsAsFactors = F)

# View the first 6 rows of the tuberculosis data
head(tuberculosis)

# Create a frequency table that can then be put into the chisq.test() function
tub.table <- table(tuberculosis$gender, tuberculosis$results)

# Calculating chi square value by hand
chi.sq.value <- (70-67.21)^2/67.21 + (66-68.79)^2/68.79 + (15-17.79)^2/17.79 + (21-18.21)^2/18.21
chi.sq.value

# Using function to calculate chi square
tub.chi.sq <- chisq.test(tub.table, correct = F)
# Printing expected values
tub.chi.sq$expected
# Printing chi square results
tub.chi.sq

# Creating table for A/B testing example
ab.test.table <- matrix(c(18, 202, 6, 209), byrow = TRUE, ncol = 2, 
                        dimnames = list(c("Website 1", "Website 2"), 
                                        c("Click", "No Click")))

# Calculating chi square value by hand
ab.chi.sq.value <- (18-12.14)^2/12.14 + (6-11.86)^2/11.86 + (202-207.86)^2/207.86 + (209-203.14)^2/203.14
ab.chi.sq.value

# Using function to calculate chi square
ab.chi.sq <- chisq.test(ab.test.table, correct = F)
# Printing expected values
ab.chi.sq$expected
# Printing chi square results
ab.chi.sq
