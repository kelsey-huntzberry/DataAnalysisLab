# Intro R, Practicd Exercises
# Please finish what you did not finish in class for homework!

# Citation: The data below was retrieved from gapminder and merged into one data set
# Link for the source: https://www.gapminder.org/data/

# Install if needed and load dplyr package
library(dplyr)

# Set your working directory
setwd("~/Documents/R_Class_Meetup/Class4/Results")

# Read in world_data_merged.csv and adult_literacy_percent_2011.csv downloaded from Github
world.df <- read.csv("~/Documents/R_Class_Meetup/Class3/Data/world_data_merged.csv", stringsAsFactors = F)
adult.lit <- read.csv("~/Documents/R_Class_Meetup/Class3/Data/adult_literacy_percent_2011.csv", stringsAsFactors = F)

# Print the beginning of the adult.lit data set
head(adult.lit)
# Now print the end
tail(adult.lit)

# Find the number of rows and columns in adult.lit
nrow(adult.lit)
ncol(adult.lit)

# Print unique values in pop.growth.rating variable in world.df
unique(world.df$pop.growth.rating)
# Find the length of the pop.growth.rating variable in world.df
length(world.df$pop.growth.rating)
# Use unique() inside of length() to find the number of unique values in 
## mean.years.school.women.25plus.2009 in world.df
length(unique(world.df$mean.years.school.women.25plus.2009))

# Print frequencies in world.df of development variable
table(world.df$development)

# Find median of the variable mean.years.school.women.25plus.2009
# Set value equal to median.ed
# Remember to use the argument na.rm = TRUE
median.ed <- median(world.df$mean.years.school.women.25plus.2009, na.rm = TRUE)

# Subset the data to mean.years.school.women.25plus.2009 above the median
# Set data set to be named high.educ.women
high.educ.women <- subset(world.df, mean.years.school.women.25plus.2009 > median.ed)

# Print frequencies of development variable in high.educ.women
table(high.educ.women$development)

# Merge in the adult literacy percent data
# Run a full join for further analysis but also run a inner join with the literacy data 
## data frame as the driver to see the difference
# Merge by or using the country variable
world.wlit <- merge(world.df, adult.lit, by = "country", all = TRUE)
world.wlit.inner <- merge(adult.lit, world.df, by = "country")

# Print the number of rows from the original data sets you used for the merge
# Also print the number of rows from the resulting data frames from both the 
## full and inner joins to see the difference
nrow(world.df)
nrow(adult.lit)
nrow(world.wlit)
nrow(world.wlit.inner)

# Calculate the median of the adult.literacy.pct.2011 variable (don't forget about missing values!)
# Then use the ifelse() command to set values greater than the median to be "High Literacy"
## and set the values less than or equal to the median to equal "Low Literacy"
median.lit.16 <- median(world.wlit$adult.literacy.pct.2011, na.rm = TRUE)
world.wlit$lit.level <- ifelse(world.wlit$adult.literacy.pct.2011 > median.lit.16,
                               "High Literacy", "Low Literacy")

# Print using the table() function to show a frequency table of your new lit.level variable
table(world.wlit$lit.level)

# Subset the data set to just the country, human.develop.index.2011,
## and corrupt.perc.score
### IMPORTANT NOTE: corrput.perc.score is lower when HIGHER corruption is perceived
# Call the subsetted data corr.devel.df
corr.devel.df <- subset(world.wlit, select = c(country, corrupt.perc.score, human.develop.index.2011))

# Just for fun run these three lines of code to see a scatterplot of the corrupt.perc.score
## by human.develop.index.2011 with a line showing the relationship
# ggplot2 plots look MUCH nicer than this but this should get you in the mood for graphing next week!
corr.by.devel <- lm(corrupt.perc.score~human.develop.index.2011,data=corr.devel.df) 
with(corr.devel.df,plot(human.develop.index.2011, corrupt.perc.score))
abline(corr.by.devel)
# There is a clear relationship between higher development and lower
## perceptions of corruption (remember higher is better)

