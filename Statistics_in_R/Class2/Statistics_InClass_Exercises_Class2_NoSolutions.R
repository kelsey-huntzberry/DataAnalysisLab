# Statistics in R Class 2 In-Class Code
library(ggplot2)

setwd("~/Documents/R_Class_Meetup/Statistics/Class2")

# Read in  state_prescribe_overdose_data.csv
opioid.df <- read.csv("state_prescribe_overdose_data.csv", stringsAsFactors = F)

######## Review last week's code, coin flips and pulling random cards ######
# IMPORTANT NOTE: RUN FULL FUNCTION CODE WHEN RUNNING

# Demonstrating random sampling functions
# Demonstrating the runif() function
runif(4, 0, 10)

# Demonstrating sample() function
choices <- c("heads", "tails")

######### Probability demonstration below ###########
# Start by setting num.flips to a small number and run it a few times
# How different are the results when the num.flips is small?
# Now try increasing the number to something large like 100,000
# Run several times, how do these results differ from when a small number was inserted?

# Change this number
num.flips <- 10

# IMPORTANT NOTE: RUN LINES 17-22 ALL AT ONCE
# Run two chunks of code below to run coin flip simulation
coin.flip <- function(num.flips) {
  choices <- c("heads", "tails")
  results <- sample(choices, num.flips, replace = T)
  perc.heads <- sum(results == "heads")/num.flips
  return(perc.heads)
}

# Will return the percentage of times it came up heads
coin.flip(num.flips)

# IMPORTANT NOTE: RUN LINES 51-56 ALL AT ONCE
# Now simulating choosing from a deck of cards. We will simulate how often we
# choose a face card or an ace twice in a row. Keep in mind we are NOT replacing
# a card once its chosen so this the two drawing of cards are not independent

# Change this number to see how the numbers change, start small and then go big
num.repeat <- 30

# Simulates a deck of cards, "AH" means Ace of Hearts, 10C means 10 of clubs, etc.
# Run the next 4 code chunks to run the simulation
deck.cards <- c("AH", "AD", "AC", "AS", 
                "KH", "KD", "KC", "KS",
                "QH", "QD", "QC", "QS",
                "JH", "JD", "JC", "JS",
                "10H", "10D", "10C", "10S",
                "9H", "9D", "9C", "9S",
                "8H", "8D", "8C", "8S",
                "7H", "7D", "7C", "7S",
                "6H", "6D", "6C", "6S",
                "5H", "5D", "5C", "5S",
                "4H", "4D", "4C", "4S",
                "3H", "3D", "3C", "3S",
                "2H", "2D", "2C", "2S")

pick.card <- function(y){
  sample.card <- sample(y, 2, replace = F)
  both.face <- str_detect(sample.card, "^[A-Z]{1}")
  true.value <- sum(both.face) == 2
  return(true.value)
}

# Repeats the exercise the number of times you specified
two.face.aces <- replicate(num.repeat, pick.card(y = deck.cards))
# Returns how many times both draws were an Ace or a face card (TRUE) and how many were not (FALSE)
table(two.face.aces)

############ Exercise 1 ###############
# Demonstrating the runif() function
runif(4, 0, 10)

# Makes it so we will all get the same answer every time we run it
set.seed(47)

# Demonstrating rnorm(), function that randomly samples values of a normal distribution
normal.values <- as.data.frame(rnorm(10000, mean = 5, sd = 1))
colnames(normal.values) <- "values"

normal.sample <- rnorm(10000, mean = 5, sd = 1)

# Creating second histogram
normal.sample <- ggplot(normal.values, aes(x = values)) +
  geom_histogram(color = "blue", fill = "lightblue", bins = 50) +
  theme_minimal() +
  labs(x = "means") +
  scale_x_continuous(breaks = c(1, 2, 3, 4, 5, 6, 7, 8))
normal.sample

# Demonstrating normal distribution
resample.function <- function(x){
  resample <- sample(x, 30, replace = F)
  return(resample)
}

# Randomly sample 30 values 10,000 times from opioid.df prescribing.rate
normal.example <- replicate(10000, sample(opioid.df$prescribing.rate, 30, replace = F), simplify = "array")

# Transpose data set so in the correct format
normal.transpose <- t(normal.example)

# Changing array to a data frame (faster to do work with it)
normal.df <- as.data.frame(normal.transpose)
# Calculate the row means of the samples of 30 values
normal.df$mean <- rowMeans(normal.df)

# Create a histogram of the resulting means
# Each bin or bar represents the freqency with that mean
# Example value after represents frequency of mean values between 70 and 71
opioid.hist <- ggplot(normal.df, aes(x = mean)) +
  geom_histogram(color = "blue", fill = "lightblue", bins = 30) +
  theme_minimal()
opioid.hist

########### Exercise #2 ##########
# Printing summary statistics of the prescribing.rate and overdose.rate variables
summary(opioid.df$prescribing.rate)
summary(opioid.df$overdose.rate)

# Find mean prescribing rate
mean.pres <- mean(opioid.df$prescribing.rate, na.rm = T)
# Find prescribing standard deviation
sd.pres <- sd(opioid.df$prescribing.rate, na.rm = T)

# Find mean overdose
mean.od <- mean(opioid.df$overdose.rate, na.rm = T)
# Find overdose standard deviation
sd.od <- sd(opioid.df$overdose.rate, na.rm = T)

# Finding the zscore of a prescribing.rate of 85 prescriptions per 100 individuals
zscore.prescribe.70 <- (70 - mean.pres)/sd.pres
zscore.prescribe.70

# Finding the zscore of a overdose.rate of 15 per 100,000 individuals
zscore.overdose.15 <- (15 - mean.od)/sd.od
zscore.overdose.15

# Subsetting data to just the southern region
opioid.south <- subset(opioid.df, region == "South")

# Printing summary statistics of the prescribing.rate and overdose.rate variables for south data frame
summary(opioid.south$prescribing.rate)
summary(opioid.south$overdose.rate)

# Exercise
# Using the above example, find the zscore of a prescribing.rate of 105 in opioid.south


# Using the above example, find the zscore of a overdose.rate of 20 in opioid.south

