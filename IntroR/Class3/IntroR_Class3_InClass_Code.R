# Class 3, In Class Demonstration and Instruction Code

# Install if necessary and load dplyr package
library(dplyr)
library(stringr)

# Citation: The data below was retrieved from gapminder and merged into one data set
# Link for the source: https://www.gapminder.org/data/

# Read in world data
world.df <- read.csv("~/Documents/R_Class_Meetup/Class3/Data/world_data_merged.csv", stringsAsFactors = F)

# Use head() and tail() functions to get a view of your data set
head(world.df)
tail(world.df, n = 8L)

# Print the unique values in corrupt.perc.score variable
unique(world.df$corrupt.perc.score)

# Find the length of the corrupt.perc.score variable
length(world.df$corrupt.perc.score)

# Find the length of your corrupt.perc.score variable
length(unique(world.df$corrupt.perc.score))

# Find number of columns in world.df
ncol(world.df)
# Find number of rows in world.df
nrow(world.df)

# Find frequencies of pop.growth.rating variable
table(world.df$pop.growth.rating)
# Find frequencies of pop.growth.rating and development variable
table(world.df$pop.growth.rating, world.df$development)

# Finding median of human.develop.index.2011 variable and setting it to median.hdi
# Remember to remove missing values or your median will return as NA!
median.hdi <- median(world.df$human.develop.index.2011, na.rm = TRUE)

# Now I am using an if/else statement to set values above the median to "High"
# and values below the median as "Low"
world.df$hdi.level <- ifelse(world.df$human.develop.index.2011 > median.hdi, 
                             "High", "Low")

# With hard coded numbers
world.df$hdi.level.test <- ifelse(world.df$human.develop.index.2011 > 0.522, 
                             "High", "Low")

# Use the table function to check the frequencies for hdi.level variable
table(world.df$hdi.level)
table(world.df$hdi.level.test)

# You can also nest ifelse() statements inside one another
# Pulling the 33rd and 66th percentiles so I can split the HDI group into 3 equal high, medium, and low groups
perc.hdi <- quantile(world.df$human.develop.index.2011, probs = c(0.333, 0.666), na.rm = T)

# Can use a case_when statement to set make a 3-level conditional
world.df$hdi.level3 <- case_when(world.df$human.develop.index.2011 < perc.hdi[1] ~ "Low",
                                 world.df$human.develop.index.2011 >= perc.hdi[1] & 
                                   world.df$human.develop.index.2011 < perc.hdi[2] ~ "Middle",
                                 world.df$human.develop.index.2011 >= perc.hdi[2] ~ "High")

# Use the table function to check the frequencies for hdi.level3 variable
table(world.df$hdi.level3)

# Subset the data to just those values where hdi.level = "Low"
# NOTE: In this data set lower corruption scores mean more perceived corruption
high.corrupt <- subset(world.df, hdi.level == "Low")
# Find mean of life.expectancy.at.birth.2016 variable for high corruption countries
mean(high.corrupt$life.expectacy.at.birth.2016)

# Using multiple rules with subset()
high.corr.high.devel <- subset(world.df, hdi.level == "High" | corrupt.perc.rank > 50)
nrow(high.corr.high.devel)

# Subset the data to just those values where hdi.level = "High"
low.corrupt <- subset(world.df, hdi.level != "Low")
# Find mean of life.expectancy.at.birth.2016 variable for low corruption countries
mean(low.corrupt$life.expectacy.at.birth.2016, na.rm = T)

# Subset variables to just country, corrupt.perc.score, corrupt.perc.rank, human.devel.index.2011
devel.data <- subset(world.df, select = c(country, corrupt.perc.score, corrupt.perc.rank))
# Check number of columns in devel.data
ncol(devel.data)

#### Demonstrating 4 types of joins ####
# Reading in data to demonstrate joins, this is
median.age.df <- read.csv("~/Documents/R_Class_Meetup/Class3/Data/median_age_wProjections.csv", stringsAsFactors = F)

# Below is an inner join
# This keeps only those rows that have matches in both data sets
inner.join.ex <- merge(world.df, median.age.df, by = "country")
nrow(world.df)
nrow(median.age.df)
nrow(inner.join.ex)

# Below is an example of a left join
# This will keep the number of rows constant from the first data frame listed if there are no duplicate values
# NOTE: If you see the number of rows increase, THERE ARE DUPLICATES
left.join.ex <- merge(world.df, median.age.df, by = "country", all.x = TRUE)
nrow(world.df)
nrow(median.age.df)
nrow(left.join.ex)

# Below is an example of a right join
# This will keep the number of rows constant from the second data frame listed if there are no duplicate values
# NOTE: If you see the number of rows increase, THERE ARE DUPLICATES
right.join.ex <- merge(world.df, median.age.df, by = "country", all.y = TRUE)
nrow(world.df)
nrow(median.age.df)
nrow(right.join.ex)

# Below is an example of a full join
# This will keep all rows in the merged data set whether they match or not
full.join.ex <- merge(world.df, median.age.df, by = "country", all = TRUE)
nrow(world.df)
nrow(median.age.df)
nrow(full.join.ex)
