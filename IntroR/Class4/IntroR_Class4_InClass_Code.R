# Introduction to R, Class 4: Indexing

# Install rvest package if needed and load the rvest package
library(rvest)

# Read in world data
world.df <- read.csv("~/Documents/R_Class_Meetup/Class4/Data/world_data_merged.csv", stringsAsFactors = F)

######### Indexing Vectors ############
# Indexing with a vector examples below
states <- c("Alabama", "Texas", "Arkansas", "New Jersey")
# Pulling one value
states[2]
states[4]
# Pulling more than one value
states[2:4]
states[1:2]

# Indexing based on value
# Create vector
fruit.prices <- c(0.35, 0.42, 0.55, 0.30, 0.40, 0.60)
# Create logical vector pulling all values greater than or equal to 0.40
bool <- fruit.prices >= 0.40
# Print resulting logical vector
bool
# Use logical vector to index and subset fruit.prices
fruit.prices[bool]

################ Indexing Data Frames ################
# Create a data frame with rainfall values
rainfall.vect <- c("Austin", 1, "San Antonio", 0.7, "Houston",
                   0.5, "Dallas", 0)
rainfall.df <- data.frame(matrix(rainfall.vect, byrow = TRUE, ncol = 2,
                                 dimnames = list(c(1,2,3,4), c("city", "rainfall"))))

# Changing city to a character vector
rainfall.df$city <- as.character(rainfall.df$city)
rainfall.df$rainfall <- as.numeric(as.character(rainfall.df$rainfall))

# Indexing using data frames example below
# Print rainfall.df
rainfall.df
# Pulling one data point
rainfall.df[3, 2]
# Pulling multiple data points
rainfall.df[2:4, 1:2]
# Pulling a whole row
rainfall.df[ , 2]
# Pulling a whole column
rainfall.df[3, ]

# Create a logical vector based on rainfall value
bool.df <- rainfall.df$rainfall > 0.5
# Print resulting logical vector
bool.df
# Subset data frame to rows with rainfall greater than 0.5
rainfall.sm <- rainfall.df[bool.df, ]
# Can be done in one step
rainfall.test <- rainfall.df[rainfall.df$rainfall > 0.5, ]
rainfall.test
# Print result
rainfall.sm

################# Indexing Lists ################
# Creating a list
## Notice there is more than one data type in this list, which you can not do with a vector
tkm.list <- list("To Kill a Mockingbird", "Harper Lee", 1960)

# Can also create nested list, or lists inside of lists
classic.books <- list(list("To Kill a Mockingbird", "Harper Lee", 1960),
                      list("Pride and Prejudice", "Jane Austen", 1813),
                      list("Gone with the Wind", "Margaret Mitchell", 1936))

# To refer to the first list within classic.books use single brackets
classic.books[1]
# Third list
classic.books[3]

# To access a single value within the first list use double brackets to
# refer to the first list and single brackets to refer to a value within
# the first list
# 1st list, second item
classic.books[[1]][2]
# 3rd list, 3rd item
classic.books[[3]][3]

# How would this be used in real life? Common uses: API pulls/JSON and Web Scraping
# Web scraping example is below

# Below pulls the website data
webpage <- read_html("https://www.cdc.gov/drugoverdose/maps/rxrate-maps.html")
tbls <- html_nodes(webpage, "table")

str(tbls)

# Let's explore the tables
tbls[[1]]
tbls[[2]]

# We want the first data table on prescribing
prescribing <- html_table(tbls, header = TRUE, fill = TRUE)[[1]]

# Missing value demo
# NA divided by 10 returns NA
NA/10
# Dividing by zero returns Inf
9/0
# NULL has no length
length(NULL)
# NA has a length
length(NA)

# Find the number of missing values in perc.tobacco.use.adults.2005
nrow(world.df)
# Print logical vector for missing values
is.na(world.df$perc.tobacco.use.adults.2005)
# Find out how many missing values are in the column
table(is.na(world.df$perc.tobacco.use.adults.2005))

# Print column names from world.df
colnames(world.df)

# I purposefully made a typo in column 17, let's fix it!
# Replacing this column name with the correct name
colnames(world.df)[17] <- "poverty.lt.dollar.quarter.percent.2010"

# Can change specific values in a column that meet specific criteria
# Change "Virgin Islands (U.S.)" to U.S. Virgin Islands in country column
world.df$country[world.df$country == "Virgin Islands (U.S.)"] <- "U.S. Virgin Islands"

# Sometimes when you are looping over a data frame, you need missing values
# to be blanks so code will not error out
# I will change all the NA values in perc.tobacco.use.adults.2005 to blank values
world.df$perc.tobacco.use.adults.2005[is.na(world.df$perc.tobacco.use.adults.2005)] <- ""

# is.na() produces a logical vector
is.na(world.df$perc.tobacco.use.adults.2005)
# Find the number of missing values in perc.tobacco.use.adults.2005
table(is.na(world.df$perc.tobacco.use.adults.2005))
# See the number of NAs is now zero
