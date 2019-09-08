# Introduction to R Programming
# Class 2 Tutorial Code

##################### Data Types and Structures Tutorial ######################
# Below is an example of how to create a basic matrix from a vector with numeric values
# Create vector
fruit.prices <- c(0.24, 0.50, 0.87, 0.30, 0.40, 0.60)
# Turn vector into a matrix
fruit.matrix.basic <- matrix(fruit.prices, byrow = FALSE, nrow = 3) 
# Print matrix
fruit.matrix.basic

# Below shows how to create a matrix with character values
states.vector <- c("TX", "PA", "MO", "AK", "MA", "CA")
# Below I show both the byrow = TRUE and byrow = FALSE options
# Study the results to understand the difference
states.matrix <- matrix(states.vector, nrow = 2, ncol = 3,
                        byrow = TRUE)
states.matrix.byrow.F <- matrix(states.vector, nrow = 2, ncol = 3,
                        byrow = FALSE)

# Below shows how to create a matrix and add labels
fruit.matrix <- matrix(fruit.prices, byrow = FALSE, nrow = 3, 
                       dimnames = list(c(1,2,3), c("apples", "bananas"))) 
# Print new matrix with labels
fruit.matrix

# Below showing how to make a data frame with a matrix
## Notice that the two chunks of code create the same output. In R you can combined and nest functions within one another
## Also notice that the numbers are automatically changed to character values because a matrix can only have one type of values
## We can convert them back to numeric when we turn it into a data frame

# Create vector
rainfall.vect <- c("Austin", "High", "San Antonio", 0.7, "Houston",
                   0.5, "Dallas", 0)
# Turn a vector into a matrix with 2 columns and labels
rainfall.matrix <- matrix(rainfall.vect, byrow = TRUE, ncol = 2,
                          dimnames = list(c(1,2,3,4),
                                          c("city", "rainfall")))
# Turn matrix into a data frame
rainfall.df <- data.frame(rainfall.matrix)
# Prints result
rainfall.df

# Produces the same output as the chunk above just with nested functions & fewer steps
# Creates matrix and nests that code inside the data.frame() function
rainfall.df <- data.frame(matrix(rainfall.vect, byrow = TRUE, ncol = 2,
                                 dimnames = list(c(1,2,3,4), c("city", "rainfall"))))
# Prints resulting rainfall data frame
rainfall.df

# What data structure is rainfall.df?
class(rainfall.df)
# What data structure is the city variable within rainfall.df?
## Examine the variable by clicking the blue carrot next to rainfall.df in the Global Environment
class(rainfall.df$city)
# Change rainfall$city to a character variable
rainfall.df$city <- as.character(rainfall.df$city)
## Examine the variable again by clicking the blue carrot next to rainfall.df in the Global Environment
## How is it different this time?

# Create a vector of cities and states
city.state <- c("Austin", "Philadelphia", "Charleston", "San Francisco", 
                "Texas", "Pennsylvania", "South Carolina", "California")
# Create a matrix with the cities and states
location.df <- data.frame(matrix(city.state, ncol = 2, byrow = F,
                          dimnames = list(c(1,2,3,4), c("city", "state"))))

# Change city to character variable
location.df$city <- as.character(location.df$city)

# Uncomment to see how a factor variable will change to stored value not actual value when using as.numeric alone
#rainfall.df$rainfall <- as.numeric(rainfall.df$rainfall)

# Show how changing it to a character first solves this problem
rainfall.df$rainfall <- as.numeric(as.character(rainfall.df$rainfall))
# Changing city variable to a character variable
rainfall.df$city <- as.character(rainfall.df$city)

# Creating a list
## Notice there is more than one data type in this list, which you can not do with a vector
tkm.list <- list("To Kill a Mockingbird", "Harper Lee", 1960)

# Demonstrating how lists can be nested within one another
tkm.char <- list("Atticus Finch", "Boo Radley", "Scout Finch")
tkm.author <- c("Harper Lee")
tkm.pub.yr <- c(1960)

tkm <- list(tkm.char,
            tkm.author,
            tkm.pub.yr)

########################### Basic Data Exploration #############################
# Set working directory
setwd("~/Documents/Website/Class3")

# Read in opioid data
opioid.df <- read.csv("~/Documents/Website/Class2/county_prescribing_rates_data.csv", stringsAsFactors = F)

# Showing frequency of values within the rural.metro variable
table(opioid.df$rural.metro)

# Showing frequency of values within the rural.metro and prescribe.level variables
table(opioid.df$rural.metro, opioid.df$prescribe.level)

# Showing first 6 rows of opioid.df
head(opioid.df)
# Then the last 6 rows
tail(opioid.df)

# Listing the unique values in the year variable
unique(opioid.df$year)

# Find the length (number of values) in th year variable
length(opioid.df$year)

# Finding the number of unique values in the year variable
length(unique(opioid.df$year))

# Find the number of rows and columns in the opioid.df
nrow(opioid.df)
ncol(opioid.df)

# Read in example data for factors
state.df <- read.csv("~/Documents/R_Class_Meetup/Class4/Data/factor_demonstration_data.csv", stringsAsFactors = F)

# Creating a factor variable with state column, placing full state name as the labe
# NOTE: This is an unordered factor, that is the default with this function
state.df$states <- factor(state.df$states, 
                          levels = c("AL", "AK", "DE", "TX"),
                          labels = c("Alabama", "Alaska", "Delaware", "Texas"))

# Creating a factor variable with temp.group column
# NOTE: I created this factor as an ordered factor with ordered = TRUE
state.df$temp.group <- factor(state.df$temp.group,
                              levels = c("Low", "Medium", "High"),
                              ordered = TRUE)

# Notice when you compare values in the temp.group column, you get a value because its ordered
state.df[1,3] > state.df[3,3]

# You will get an error with this code because the states variable is NOT ordered 
## so the values cannot be compared
state.df[1,1] > state.df[3,1]
