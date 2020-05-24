# Intro R: Optional supplemental practice code for Class 4

# Citation: Data from:
## Kaiser Family Foundation, Health Insurance Data: https://www.kff.org/other/state-indicator/nonelderly-up-to-100-fpl/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
## Kaiser Family Founcation, Demographic Data: https://www.kff.org/state-category/demographics-and-the-economy/

# Set working directory
setwd("~/Documents/R_Class_Meetup/Class2/Results")

# Read in data from Github called health_insurance_demographic_data.csv
# Name it health.demo
health.demo <- read.csv("~/Documents/R_Class_Meetup/Class4/Data/health_insurance_demographic_data.csv", stringsAsFactors = F)
na.demo <- read.csv("~/Documents/R_Class_Meetup/Class4/Data/factor_demonstration_data.csv", stringsAsFactors = F)

# Creating boys.names vector
names <- c("Bob", "Alex", "Adam", "Patrick", "Matthew")
# Print 3rd name
names[3]
# Print 2nd through 4th names
names[2:4]

# Look at the first 6 rows in the health.demo data frame
head(health.demo)

# Create a logical vector with the perc.uninsure that will mark TRUE if the
## uninsured percent is above 0.10 and FALSE if it is less than or equal to 0.10
# Name the logical vector bool.unins
bool.unins <- health.demo$perc.uninsured > 0.10

# Use the table() function on the bool.unins variable to find out how many 
## values are above 0.10
table(bool.unins)

# Subset the data using this logical vector to just those states with uninsured
## percents greater than 0.10, return all rows
# Name the data frame unins.gt.10
unins.gt.10 <- health.demo[bool.unins, ]
# Make sure your data has 18 rows by printing number of rows (18 states)
nrow(unins.gt.10)

# Find mean unemployment percent
mean.unemp.pct <- mean(health.demo$unemp.perc)

# Pulling rows with unemployment above mean
high.unemp <- health.demo[health.demo$unemp.perc > mean.unemp.pct, ]

# Use the indexing to subset the health.demo data frame to the first 6 columns
## (health insurance variables)
health.ins <- health.demo[, 1:6]

# Check to make sure there are 6 columns in the data frame
ncol(health.ins)

# Find the number of NA values in the na.demo data
table(is.na(na.demo$temp))

# Replace the NA values
na.demo$temp[is.na(na.demo$temp)] <- 60
na.demo$temp.group[is.na(na.demo$temp.group)] <- "Low"
