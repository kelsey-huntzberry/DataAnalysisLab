# Optional R Supplemental Exercises for after Class 1 Material
# NOTE: To see help files type ? and then the function name into the Console (Example: ?mean)

# Go to the class Github: https://github.com/kelsey-huntzberry/DataAnalysisLab-RCode

# Place the data set in the Class1 folder called county_prescribing_rates_data.csv 
# into a folder of your choice

# Set your working directory to that folder


# Use the read.csv() command to load the data into R and assign it to prescribe.df variable


# Use the mean() function to find the mean of the prescribing.rate variable inside prescribe.df
# Remember use this format to refer to a variable inside a data frame: data.frame$variable


# Use summary() function by putting the prescribing.rate variable inside the function
# This will tell you the minimum, mean, maximum, and several other statistics


# Use install.packages() command to install the psych package


# Use library() function to load the psych package


# Now place the prescribe.df inside describe() function to get summary statistics
# for continuous variables (categorical variables will show as NaN)


# Now run the code below pulling summary statistics by year and region
prescribe.by.year.region <- describeBy(prescribe.df$prescribing.rate, 
                                group = list(prescribe.df$year, prescribe.df$region),
                                mat = TRUE)


# Now run the code below pulling summary statistics by year and rural/metropolitan
prescribe.by.year.rural <- describeBy(prescribe.df$prescribing.rate, 
                                       group = list(prescribe.df$year, prescribe.df$rural.metro),
                                       mat = TRUE)


# Now export both data sets to .csv format in your working directory with the file
# names of your choice



# Examine the data in R or Excel
## Which region had the highest prescribing rate in the data set? What year did it occur?
## In 2017, did metropolitan or rural areas have a higher average prescribing rate? In 2006?

