# Introduction to R Programming
# Class 3 Tutorial Code

### Citation: Prescribing rates from Center for Disease Control & Prevention: https://www.cdc.gov/drugoverdose/maps/rxrate-maps.html 
### Citation: World data from Gapminder: https://www.gapminder.org/data/

###### Indexing Vectors ###########
# Indexing with a vector examples below
states <- c("Alabama", "Texas", "Arkansas", "New Jersey")
# Pulling one value
states[2]
states[4]
# Pulling more than one value
states[2:4]
states[1:2]

######### Missing Values ########
# Below is a vector with fruit prices
fruit.prices <- c(0.35, 0.42, 0.55, 0.30, 0.40, 0.60)

# Create logical vector (will evaluate to TRUE or FALSE) based on how you want to subset the data
# Removing values that are below 0.40
bool <- fruit.prices >= 0.40
bool

# Use indexing to remove values below 0.40
fruit.prices[bool]

####### Indexing Data Frames #########
# Read in county_prescribing_rates_data.csv data
opioid.df <- read.csv("~/Documents/Website/Class3/county_prescribing_rates_data.csv", stringsAsFactors = F)

# Find the number of rows and columns in the opioid.df
nrow(opioid.df)

# Find the median of the prescribe.rate column
med.prescribe <- median(opioid.df$prescribing.rate)
med.prescribe

# Subset to only those values above the median prescribing rate into a data set with indexing
high.prescribing <- opioid.df[opioid.df$prescribing.rate > med.prescribe, ]
nrow(high.prescribing)

# Put those values from Texas counties into a data set
texas.prescribe <- opioid.df[opioid.df$state == "Texas", ]
nrow(texas.prescribe)

# Subset to just the first 4 columns
prescribe.sm <- opioid.df[ , 1:4]
ncol(prescribe.sm)

# Subset to the first 50 rows
first.50 <- opioid.df[1:50, ]
nrow(first.50)

# Find and print Travis County values
opioid.df[opioid.df$county == "Travis", 4]

####### Replacing Column Names & Values #########
# Read in world data
world.df <- read.csv("~/Documents/Website/Class3//world_data_merged.csv", stringsAsFactors = F)

# Below I am showing how to change values within a column
# Currently Virgin Islands has (U.S.) after the name, I am going to change this value
world.df$country[world.df$country == "Virgin Islands (U.S.)"] <- "U.S. Virgin Islands"

# Use the colnames() and head() functions to print the first 6 column names of world.df
head(colnames(world.df))

# I purposefully made a typo in the povery.lt.dollar.quarter.percent.2010
# I left out the t in poverty
# This is the 17th variable in the data frame
# Knowing that we can change the column name to poverty.lt.dollar.quarter.percent.2010
colnames(world.df)[17] <- "poverty.lt.dollar.quarter.percent.2010"
# Check to make sure it was changed correctly
colnames(world.df)[17]

# Read in example data for factors
state.df <- read.csv("~/Documents/Website/Class3/na_demonstration_data.csv", stringsAsFactors = F)

# We will replace all the column names in the state.df data frame
colnames(state.df) <- c("state", "temperature", "temperature.group")

colnames(state.df)[2] <- "temperature"

###### Replacing Missing Values ########
# You can use the is.na() function to locate the missing values
# This will print TRUE when a missing or NA value exists and FALSE when there is no missing value
is.na(state.df$temperature)

# Below replaces the NA value in temperature with a blank value
state.df$temperature[is.na(state.df$temperature)] <- ""



