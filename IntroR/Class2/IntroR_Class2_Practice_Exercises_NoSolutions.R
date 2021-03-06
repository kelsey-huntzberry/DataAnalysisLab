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


# Change ins.df$states to a factor variable
# Overwrite old variable


# Now will repeat the above with cbind()
perc.medicaid <- c(0.11, 0.13, 0.14, 0.14, 0.16, 0.18, 0.19, 0.20, 
                   0.20, 0.22, 0.23, 0.25)
fpl.lt.100 <- c(0.08, 0.09, 0.10, 0.10,
                0.11, 0.09, 0.08, 0.11, 0.08, 0.11, 0.11, 0.12)

# Use cbind() to combine the vectors: states, perc.medicaid, fpl.lt.100
# Wrap the data.frame() function around the cbind() command
# Add stringsAsFactors = F to the data.frame() command


# Change perc.medicaid and fpl.lt.100 to numeric variables from character variables



# Read in world_data_gapminder.csv as world.data
# Do NOT add stringsAsFactors = F to your read.csv() function


# Change country and human.devel.level to character variables



# Change corrupt.level to an ordered factor
# Put Low Corruption as the lowest level and High Corruption as the highest level



# Below should not throw an error if you did the above correctly
world.data$corrupt.level[1] > world.data$corrupt.level[89]
