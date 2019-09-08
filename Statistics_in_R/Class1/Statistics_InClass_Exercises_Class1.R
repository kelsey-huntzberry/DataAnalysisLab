
# install.packages("stats")
# install.packages("ggplot2")
# install.packages("stinrgr")
library(stats)
library(ggplot2)
library(stringr)

# Load in data to run code below
world.df <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class1/world_data_merged.csv", stringsAsFactors = F)
schooling.bp.data <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class1/schooling_boxplot_data.csv")

############# Exercise #1 ############
# Find the mean and median years of school attended by men age 25 years and older
mean(world.df$mean.years.school.men.25plus.2009, na.rm = TRUE)
median(world.df$mean.years.school.men.25plus.2009, na.rm = TRUE)

# Find the mean and median years of school attended by women age 25 years and older
mean(world.df$mean.years.school.women.25plus.2009, na.rm = TRUE)
median(world.df$mean.years.school.women.25plus.2009, na.rm = TRUE)
# What in the data explains why there is a larger difference between these two measures for women than men?

########### Exercise #2 ###############
# Find the standard deviation and IQR for both men below
IQR(world.df$mean.years.school.men.25plus.2009, na.rm = TRUE)
sd(world.df$mean.years.school.men.25plus.2009, na.rm = TRUE)

# Find the standard deviation and IQR for both women below
IQR(world.df$mean.years.school.women.25plus.2009, na.rm = TRUE)
sd(world.df$mean.years.school.women.25plus.2009, na.rm = TRUE)
# What do these two values mean? What would explain the difference?

################ Exercise #3 #################
# Below this code creates a box plot to see a visualization of the numbers above
ggplot(data = schooling.bp.data, aes(x = gender, y = mean.yr.school)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  theme_minimal()
# Task: Does what you see makes sense given the numbers you saw above? Are you surprised?

############# Exercise #4 ##############
# Creating a histogram by gender below showing counts of mean years in school
ggplot(data = schooling.bp.data, aes(mean.yr.school)) +
  geom_histogram(color = "blue", fill = "lightblue", bins = 40) +
  theme_minimal() +
  facet_wrap(~ gender, ncol = 1)

# Task: Describe the skew of each graph (i.e. right, left, symmetric)

######### Probability demonstration below ###########
# Start by setting num.flips to a small number and run it a few times
# How different are the results when the num.flips is small?
# Now try increasing the number to something large like 100,000
# Run several times, how do these results differ from when a small number was inserted?

# Change this number
num.flips <- 100000

# Run two chunks of code below to run coin flip simulation
coin.flip <- function(num.flips) {
  choices <- c("heads", "tails")
  results <- sample(choices, num.flips, replace = T)
  perc.heads <- sum(results == "heads")/num.flips
  return(perc.heads)
}

# Will return the percentage of times it came up heads
coin.flip(num.flips)

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
