# Intro R: Optional supplemental practice code for Class 2

# Set working directory


# Adding in vectors that you will be working with
# These are vectors showing the percent of people on medicaid
states <- c("North Dakota", "Nebraska", "Kansas", "South Dakota", 
            "Missouri", "Wisconsin", "Minnesota", "Indiana", "Iowa", 
            "Illinois", "Ohio", "Michigan" )
ins.values <- c(0.11, 0.13, 0.14, 0.14, 0.16, 0.18, 0.19, 0.20, 
                0.20, 0.22, 0.23, 0.25, 0.08, 0.09, 0.10, 0.10,
                0.11, 0.09, 0.08, 0.11, 0.08, 0.11, 0.11, 0.12)

# Create a matrix with the ins.values values and name it ins.mat
# Make sure there is two columns
# You want the values to fill up the entire column and move onto second column
# Set the row names as the states vector above
# Set the first column as perc.medicaid and the second column as fpl.lt.100



# Multiply entire matrix by 100 so percents will be in whole numbers
# Set new matrix to ins.whole


# Convert ins.whole to a data frame called ins.df


# Run the following code. This will turn the states labels into a column
# Call the new variable to be named states
ins.df$states <- rownames(ins.df)

# Change ins.df$states to a factor variable
# Overwrite old variable


# Read in world_data_gapminder.csv as world.data


# Print how many rows are in world.data


# Print how many columns are in world.data


# Print the top values of the world.data data frame


# Print the bottom values of the world.data data frame


# Create a frequency table showing the frequencies of each value in the growth.direction variable


# Create a frequency table showing the frequencies of corrupt.level and human.devel.level variables


# Find and print the length of the country variable


# Print the unique values in the country variable


# Find and print the number of unique values in the country variable by combining the two functions you used above

