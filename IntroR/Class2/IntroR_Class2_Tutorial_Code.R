# Introduction to R Programming
# Class 2 Tutorial Code

##################### Vectors and Matrices ######################
# Below is an example of how to create a basic matrix from a vector with numeric values
# Create vector
fruit.prices <- c(0.24, 0.50, 0.87, 0.30, 0.40, 0.60)
# Turn vector into a matrix
fruit.matrix.basic <- matrix(fruit.prices, byrow = FALSE, nrow = 3) 
fruit.matrix.byrow.T <- matrix(fruit.prices, byrow = TRUE, nrow = 3) 
# Print matrix
fruit.matrix.basic

# Demonstrating data frame
fruit.names <- c("Apple", "Banana", "Orange", "Strawberries", "Raspberries", "Blueberries")

fruit.df <- cbind(fruit.names, fruit.prices)
fruit.df.final <- data.frame(fruit.df)

# Below shows how to create a matrix with character values
states.vector <- c("TX", "PA", "MO", "AK", "MA", "CA")
# Below I show both the byrow = TRUE and byrow = FALSE options
# Study the results to understand the difference
states.matrix <- matrix(states.vector, ncol = 3,
                        byrow = TRUE)
states.matrix.byrow.F <- matrix(states.vector, ncol = 3,
                        byrow = FALSE)

# Below shows how to create a matrix and add labels
fruit.matrix <- matrix(fruit.prices, byrow = FALSE, nrow = 3, 
                       dimnames = list(c(1,2,3), c("apples", "bananas"))) 
# Print new matrix with labels
fruit.matrix

fruit.matrix*3

# Create a vector of cities and states
city.state <- c("Austin", "Philadelphia", "Charleston", "San Francisco", 
                "Texas", "Pennsylvania", "South Carolina", "California")
# Create a matrix with the cities and states
location.df <- data.frame(matrix(city.state, ncol = 2, byrow = F,
                          dimnames = list(c(1,2,3,4), c("city", "state"))))

class(location.df)

# Checking data type of variables in location.df$city
class(location.df$city)
# Converting the variable to a character variable
location.df$city <- as.character(location.df$city)
# Check class again
class(location.df$city)

# Checking data type of variables in location.df$state
class(location.df$state)
# Converting the variable to a character variable
location.df$state <- as.character(location.df$state)
# Check class again
class(location.df$state)

# NOTE: Could use data.frame() with argument stringsAsFactors = F instead of converting types
location.df <- data.frame(matrix(city.state, ncol = 2, byrow = F,
                                 dimnames = list(c(1,2,3,4), c("city", "state"))), stringsAsFactors = F)

######## Detour into Factors ###########
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

# NOTE: Below I show indexing, which is next week's topic
# For now, the first number value stands for the row, the second number value stands for the column

# Notice when you compare values in the temp.group column, you get a value because its ordered
state.df[1,3] > state.df[3,3]

# You will get an error with this code because the states variable is NOT ordered 
## so the values cannot be compared
state.df[1,1] > state.df[3,1]

########### Creating Data Frames with cbind() and rbind() ##############
# Showing how to use cbind() and rbind() to bind rows and columns
# Also showing how these can be used to create a data frame
# Setting up vectors to demonstrate row and column binding
female.names <- c("Erin", "Alexa", "Joyce", "Lauren")
female.accuracy <- c(0.9, 0.6, 0.74, 0.8)

male.names <- c("Mike", "Aaron", "Ted", "Adam")
male.accuracy <- c(0.55, 0.95, 0.8, 0.6)

# If I want to create a male and female data frame with names and accuracy
## I use cbind() and data.frame() to create the the data frame
female.data <- data.frame(cbind(female.names, female.accuracy))
# I can do the same for male data
male.data <- data.frame(cbind(male.names, male.accuracy))

# Now if I name the columns the same I can append the two data frames 
## into an accuracy data frame for both genders
names.data <- c("names", "accuracy")
colnames(female.data) <- names.data
colnames(male.data) <- names.data

# Now I can use rbind() to bind rows
accuracy.data <- rbind(female.data, male.data)

# What data structure is accuracy.data?
class(accuracy.data)

## Can examine variables by clicking the blue carrot next to accuracy.data in the Global Environment
## Can click on data frame name to open it in R to view

# Now check class of accuracy.data$accuracy inside R
class(accuracy.data$accuracy)

# Changing data type for accuracy from factor to numeric
# Always change factor variables that are numeric to a character variable first when converting them to numeric data type!!!
# Why? I'll show below
accuracy.data$accuracy <- as.numeric(accuracy.data$accuracy)
# Changed our values to meaningless background values from factor variable

# How do I fix this? Rerun rbind() code from above to remove mistake
accuracy.data <- rbind(female.data, male.data)
# Now use as.character() inside of as.numeric() to change it to its true value first
accuracy.data$accuracy <- as.numeric(as.character(accuracy.data$accuracy))

# Another example
# What data structure is the accuracy variable within accuracy.data?
class(accuracy.data$names)
# Change rainfall$city to a character variable
accuracy.data$names <- as.character(accuracy.data$names)

# Can remove some of these intermediate variable type changes by using stringsAsFactors = F inside of data.frame()
# Repeating code from above with stringsAsFactors = F included
female.data <- data.frame(cbind(female.names, female.accuracy), stringsAsFactors = F)
male.data <- data.frame(cbind(male.names, male.accuracy), stringsAsFactors = F)
names.data <- c("names", "accuracy")
colnames(female.data) <- names.data
colnames(male.data) <- names.data
accuracy.data <- rbind(female.data, male.data)
class(accuracy.data$names)
# Now character instead of factor
class(accuracy.data$accuracy)
# Now character so can just change to numeric as follows, 1 step instead of 3
accuracy.data$accuracy <- as.numeric(accuracy.data$accuracy)

############## Lists ###############
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
