# Intro R, Practicd Exercises
# Please finish what you did not finish in class for homework!

# Citation: The data below was retrieved from gapminder and merged into one data set
# Link for the source: https://www.gapminder.org/data/

# Install if needed and load dplyr package


# Set your working directory


# Read in world_data_merged.csv and adult_literacy_percent_2011.csv downloaded from Github


# Print the beginning of the adult.lit data set

# Now print the end


# Find the number of rows and columns in adult.lit



# Print unique values in pop.growth.rating variable in world.df

# Find the length of the pop.growth.rating variable in world.df

# Use unique() inside of length() to find the number of unique values in 
## mean.years.school.women.25plus.2009 in world.df


# Print frequencies in world.df of development variable


# Find median of the variable mean.years.school.women.25plus.2009
# Set value equal to median.ed
# Remember to use the argument na.rm = TRUE


# Subset the data to mean.years.school.women.25plus.2009 above the median
# Set data set to be named high.educ.women


# Print frequencies of development variable in high.educ.women


# Merge in the adult literacy percent data
# Run a full join for further analysis but also run a inner join with the literacy data 
## data frame as the driver to see the difference
# Merge by or using the country variable



# Print the number of rows from the original data sets you used for the merge
# Also print the number of rows from the resulting data frames from both the 
## full and inner joins to see the difference





# Calculate the median of the adult.literacy.pct.2011 variable (don't forget about missing values!)
# Then use the ifelse() command to set values greater than the median to be "High Literacy"
## and set the values less than or equal to the median to equal "Low Literacy"



# Print using the table() function to show a frequency table of your new lit.level variable


# Subset the data set to just the country, human.develop.index.2011,
## and corrupt.perc.score
### IMPORTANT NOTE: corrput.perc.score is lower when HIGHER corruption is perceived
# Call the subsetted data corr.devel.df


# Just for fun run these three lines of code to see a scatterplot of the corrupt.perc.score
## by human.develop.index.2011 with a line showing the relationship
# ggplot2 plots look MUCH nicer than this but this should get you in the mood for graphing next week!
corr.by.devel <- lm(corrupt.perc.score~human.develop.index.2011,data=corr.devel.df) 
with(corr.devel.df,plot(human.develop.index.2011, corrupt.perc.score))
abline(corr.by.devel)
# There is a clear relationship between higher development and lower
## perceptions of corruption (remember higher is better)

