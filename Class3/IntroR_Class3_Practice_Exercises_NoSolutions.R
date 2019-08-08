# Intro R: Optional supplemental practice code for Class 2

# Citation: Data from:
## Kaiser Family Foundation, Health Insurance Data: https://www.kff.org/other/state-indicator/nonelderly-up-to-100-fpl/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
## Kaiser Family Founcation, Demographic Data: https://www.kff.org/state-category/demographics-and-the-economy/

# Set working directory


# Read in data from Github called health_insurance_demographic_data.csv
# Name it health.demo


# State is currently a factor variable. Change it to a character variable
# Overwrite old variable with new character variable


# Create a logical vector with the perc.uninsure that will mark TRUE if the
## uninsured percent is above 0.10 and FALSE if it is less than or equal to 0.10
# Name the logical vector bool.unins


# Run the code below to see how many states are in each group
table(bool.unins)

# Subset the data using this logical vector to just those states with uninsured
## percents greater than 0.10, return all rows
# Name the data frame unins.gt.10

# Use the code below to make sure your data has 18 rows (18 states)
nrow(unins.gt.10)

# Find the mean of the original data set (health.demo) of the fpl.100_199 variable
# Set this mean value to equal a variable called fpl.100.avg


# Using the unins.gt.10 data frame, create another boolean vector that returns
## TRUE for those states with fpl.100_199 greater than the mean and FALSE if
## is less than or equal to the mean
# Name this logical vector bool.fpl


# Run the code below to see how many states are above and below the mean percent
## of the population below 100 FPL
table(bool.fpl)

# Now, create another logical vector on the original health.demo data set
## to see how many of all states have fpl.100_199 greater than the mean
# Name the logical vector bool.fpl.all


# Run code and compare to the high uninsured states
table(bool.fpl.all)

# Multiply the perc.medicaid variable by 100 and change it to an integer in health.demo
## HINT: Use as.integer()
# Set new variable name to be perc.medicaid.whole
# This can be done in one line or code or two, either is fine


# Use bool.fpl.all to subset the health.demo data set to those states
## with FPL below the mean value (HINT: Put ! before the logical vector you created)
# Set the new data frame to be called gt.mean.fpl


# Use the following code to make sure your result has 22 rows
nrow(gt.mean.fpl)

# Export the unins.gt.10 variable to your working directory

