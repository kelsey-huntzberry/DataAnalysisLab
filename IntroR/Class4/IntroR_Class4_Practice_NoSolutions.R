# Intro R: Optional supplemental practice code for Class 4

# Citation: Data from:
## Kaiser Family Foundation, Health Insurance Data: https://www.kff.org/other/state-indicator/nonelderly-up-to-100-fpl/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
## Kaiser Family Founcation, Demographic Data: https://www.kff.org/state-category/demographics-and-the-economy/

# Set working directory


# Read in data called health_insurance_demographic_data.csv and factor_demonstration_data.csv
# Call the first health.demo, call the second na.demo



# Creating boys.names vector
names <- c("Bob", "Alex", "Adam", "Patrick", "Matthew")
# Print 3rd name

# Print 2nd through 4th names


# Look at the first 6 rows in the health.demo data frame


# Create a logical vector with the perc.uninsure that will mark TRUE if the
## uninsured percent is above 0.10 and FALSE if it is less than or equal to 0.10
# Name the logical vector bool.unins


# Use the table() function on the bool.unins variable to find out how many 
## values are above 0.10


# Subset the data using this logical vector to just those states with uninsured
## percents greater than 0.10, return all rows
# Name the data frame unins.gt.10

# Make sure your data has 18 rows by printing number of rows (18 states)


# Find mean unemployment percent


# Pulling rows with unemployment above mean


# Use the indexing to subset the health.demo data frame to the first 6 columns
## (health insurance variables)


# Check to make sure there are 6 columns in the data frame


# Find the number of NA values in the na.demo data


# Replace the NA values in temp and temp.group


