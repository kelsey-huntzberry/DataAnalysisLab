# Statistics in R: Class 8, Evaluating Linear Regression Models

# Install any packages you don't already have!
library(dplyr)
library(ggplot2)
library(ggpubr)
library(car)
library(ggeffects)
library(sjPlot)

options(scipen=999)

# Set working directory
setwd("~/Documents/R_Class_Meetup/Statistics/Class7")

# Read in data
lm.data <- read.csv("linear_model_data.csv", stringsAsFactors = F)

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
par(mfrow=c(1,1)) 
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

############ Multiple Regression ############
# Now we will try to model with more than one predictor variable
ggplot(data = lm.sm, aes(x = "", y = pct.married.2014)) +
  geom_boxplot() +
  theme_minimal() +
  labs(y = "Percent Married, 2014")

ggplot(data = lm.sm, aes(x = "", y = pct.uninsured.2014)) +
  geom_boxplot() +
  theme_minimal() +
  labs(y = "Percent Married, 2014")

### Run Preliminary Models for Outlier Detection 
# Run preliminary models to find influential data points to remove
# Same as model above
mlr1 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014, 
           data = lm.sm)

mlr2 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014 + pct.married.2014, 
           data = lm.sm)

par(mfrow=c(1,1)) 
cutoff <- 4/((nrow(lm.sm)-length(mlr2$coefficients)-2))
plot(mlr2, which=4, cook.levels=cutoff)

mlr3 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014 + pct.married.2014 + pct.uninsured.2014, 
             data = lm.sm)

par(mfrow=c(1,1)) 
cutoff <- 4/((nrow(lm.sm)-length(mlr3$coefficients)-2))
plot(mlr3, which=4, cook.levels=cutoff)
# Outliers: 2946, 2927, 299, 2365, 68
lm.sm[2946,1]
lm.sm[2927,1]
lm.sm[299,1]
lm.sm[2365,1]
lm.sm[68,1]

# Removing outliers
mlr.data.noOut <- filter(lm.sm, !county %in% c("Buffalo County, South Dakota",
                                               "Aleutians East Borough, Alaska",
                                               "San Juan County, Colorado",
                                               "Williamsburg city, Virginia",
                                               "Lexington city, Virginia"))

### Now re-model with no outliers
# Just percent with high school degree or higher
mlr1 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014, 
           data = mlr.data.noOut)

summary(mlr1)

# Percent with high school degree or higher and percent married
mlr2 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014 + pct.married.2014, 
           data = mlr.data.noOut)

# Print model summary
summary(mlr2)

# Assess multicollinearity with VIF
vif(mlr2)
# Close to 1 so little multicollinearity

# Plot for other assumption diagnostics
par(mfrow=c(2,2))
plot(mlr2)
# Overall looks good
# qq-plot indicates normally distributed residuals
# 2 left graphs show homoskedasticity

# Percent with high school degree, higher and percent married, and percent uninsured
mlr3 <- lm(hd.mortality.rate.2014 ~ pct.hs.grad.higher.2014 + pct.married.2014 + pct.uninsured.2014, 
           data = mlr.data.noOut)

# Print model summary
summary(mlr3)

# Assess multicollinearity with VIF
vif(mlr3)
# Close to 1 so little multicollinearity

# Plot for other assumption diagnostics
plot(mlr3)
# Overall looks good
# qq-plot indicates normally distributed residuals
# 2 left graphs show more issues with heteroskedasticity but likely not severe enough for caution

# Compare 3 models to see if new variables add value using ANOVA
anova(mlr1, mlr2, mlr3)
# Model 2 with all 3 predictors is best, which we would expect given the coefficient p-values

# Notice if I try to run anova with models having a different number of data points this happens...
# Remember we removed two more outliers after original modeling
anova(pov.hd.noOut, mlr2, mlr3)
# If you have NA values or your data frames are not the same size, anova() will error out as seen above

########### Interaction Effect ################
# Does the effect of being uninsured impact the mortality rate differently based on income?
mlr.inter <- lm(life.exp.2014 ~ pct.below.poverty.2014 + pct.married.2014 + pct.uninsured.2014 + pct.below.poverty.2014*pct.uninsured.2014, 
                data = lm.data)

par(mfrow=c(1,1)) 
cutoff <- 4/((nrow(lm.data)-length(mlr.inter$coefficients)-2))
plot(mlr.inter, which=4, cook.levels=cutoff)
# 68, 2366, 2409
lm.data[68,1]
lm.data[2409,1]
lm.data[2366,1]

inter.data <- filter(lm.data, !county %in% c("Aleutians East Borough, Alaska",
                                             "Shannon County, South Dakota",
                                             "Buffalo County, South Dakota"))


mlr.inter.noOut <- lm(life.exp.2014 ~ pct.below.poverty.2014 + pct.married.2014 + pct.uninsured.2014 + pct.below.poverty.2014*pct.uninsured.2014, 
                      data = inter.data)

summary(mlr.inter.noOut)

# Assess multicollinearity with VIF
vif(mlr.inter.noOut)
# Use results with caution! Multicollinearity problem
# When assessing an interaction variable, high multicollinearity with all models, this one was the best I could do

# Plot for other assumption diagnostics
par(mfrow=c(2,2))
plot(mlr.inter.noOut)
# Other than multicollinearity, look okay

# Plotting visualization of the interaction effect
plot_model(mlr.inter.noOut, type = "int") +
  labs(title = "Predicted Life Expectancy, 2014",
       x = "Percent Below Poverty Level",
       y = "Life Expectancy",
       color = "Percent Uninsured") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

