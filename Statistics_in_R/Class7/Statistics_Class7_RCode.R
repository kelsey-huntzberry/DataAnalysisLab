# Statistics in R: Class 7, Correlation and Simple Linear Regression

# Install any packages you don't already have!
library(dplyr)
library(ggplot2)
library(ggpubr)
library(car)

# Set working directory
setwd("~/Documents/R_Class_Meetup/Statistics/Class7")

# Read in data
lm.data <- read.csv("linear_model_data.csv", stringsAsFactors = F)

######## Correlation Example: Life Expectancy #########

# Correlation between life expectancy in 2014 and percent with a bachelor's degree
cor.test(lm.data$life.exp.2014, lm.data$pct.bach.higher.2014)
# Graph data
ggplot(data = lm.data, aes(x = life.exp.2014, y = pct.bach.higher.2014)) +
  geom_point(size = 0.6) +
  theme_minimal() +
  labs(x = "Average Life Expectancy, 2014",
       y = "Percent with a Bachelor's Degree, 2014")
# A 0.4 correlation coefficient is a moderate positive correlation
# As life expectancy goes up, on average the percent with a bachelors degree also goes up

# Calculate correlation
cor.test(lm.data$life.exp.2014, lm.data$pct.married.2014)
# Graph data
ggplot(data = lm.data, aes(x = life.exp.2014, y = pct.married.2014)) +
  geom_point(size = 0.6) +
  theme_minimal() +
  labs(x = "Average Life Expectancy, 2014",
       y = "Percent Married, 2014")
# Also a 0.4 correlation coefficient
# As life expectancy goes up, on average the percent percent married goes up

# Calculate correlation
cor.test(lm.data$life.exp.2014, lm.data$pct.below.poverty.2014)
# Graph data
ggplot(data = lm.data, aes(x = life.exp.2014, y = pct.below.poverty.2014)) +
  geom_point(size = 0.6) +
  theme_minimal() +
  labs(x = "Average Life Expectancy, 2014",
       y = "Percent Below Poverty Line, 2014")
# The correlatipon coefficient is -0.67
# This relationship is a moderately strong negative correlation
# As life expectancy goes up, on average the percent below the poverty level goes down

# Calculate correlation
cor.test(lm.data$life.exp.2014, lm.data$pct.uninsured.2014)
# Graph
ggplot(data = lm.data, aes(x = life.exp.2014, y = pct.uninsured.2014)) +
  geom_point(size = 0.6) +
  theme_minimal() +
  labs(x = "Average Life Expectancy, 2014",
       y = "Percent Uninsured, 2014")
# The correlatipon coefficient is -0.44 moderate positive correlation
# As the life expectancy goes up, on average the percent uninsured goes down

########### heart disease mortality rate ###########

# Look for extreme outliers
ggplot(data = lm.data, aes(x = "", y = hd.mortality.rate.2014)) +
  geom_boxplot() + 
  theme_minimal() +
  labs(y = "Average Heart Disease Mortality Rate, 2014")

ggplot(data = lm.data, aes(x = "", y = pct.hs.grad.higher.2014)) +
  geom_boxplot() +
  theme_minimal() +
  labs(y = "Percent Below Poverty, 2014")

# Remove extreme outliers
lm.data <- filter(lm.data, pct.hs.grad.higher.2014 < 90 &
                  hd.mortality.rate.2014 > 100 &
                  hd.mortality.rate.2014 < 530)

# Examine data
ggplot(data = lm.data, aes(x = pct.hs.grad.higher.2014, y = hd.mortality.rate.2014)) +
  geom_point(size = 0.6) +
  theme_minimal() + 
  labs(y = "Percent Below Poverty, 2014", 
       x ="Average Heart Disease Mortality Rate, 2014")

pov.hd <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014, 
             data = lm.data)

summary(pov.hd)

# Look for influential points
cutoff <- 4/((nrow(lm.data)-length(pov.hd$coefficients)-2))
plot(pov.hd, which=4, cook.levels=cutoff)

# Remove very influential point
lm.sm <- filter(lm.data, county != "Storey County, Nevada")

pov.hd.noOut <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014, 
             data = lm.sm)

summary(pov.hd.noOut)

# Plot graphs for assumption diagnositics
par(mfrow=c(2,2)) # init 4 charts in 1 panel
plot(pov.hd.noOut)

# Top right qq-plot shows residuals are normally distributed
# Top and bottom left have relatively flat lines and data is evenly distributed over the x-axis
# Shows the data demonstrates homoskedasticity (equal variances)

# Check for linearity
plot(pov.hd.noOut, 1)
# No pattern in scatter plot above and line is close to the perfectly linear line
