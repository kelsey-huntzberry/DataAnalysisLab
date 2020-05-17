# Statistics in R: Class #6, ANOVA
library(ggpubr)
library(dplyr)
library(car)
library(ggplot2)

############ One-Way ANOVA, Corn Yield ###############
# Read in data
yield.df <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class6/corn_yield_by_growing_season.csv")

# Changing the factor variable to be ordered from smallest to largest
yield.df$growing.season.length <- factor(yield.df$growing.season.length, 
                        levels = c("short", "middle", "long"))

# Overview of our data structure
str(yield.df)

# Looking at sample sizes of our groups
table(yield.df$growing.season.length)

summary(yield.df$yield)

# Visualizing the data
ggboxplot(yield.df, x = "growing.season.length", y = "yield", 
          color = "growing.season.length",
          palette = c("blue", "darkgreen", "darkred"))

# One data point is way high, too high for yield to be in practice, will remove it
yield.df <- filter(yield.df, yield < 270)

# Showing summary statistics by group
group_by(yield.df, growing.season.length) %>%
  summarise(
    count = n(),
    mean = mean(yield, na.rm = TRUE),
    median = median(yield, na.rm = TRUE),
    sd = sd(yield, na.rm = TRUE),
    min = min(yield, na.rm = TRUE),
    max = max(yield, na.rm = TRUE)
  )

###### Run One-Way ANOVA ######
# Run one-way ANOVA
yield.aov <- aov(yield ~ growing.season.length, data = yield.df)
summary(yield.aov)
# Significant difference in yield between at least 2 growing seasons

# Finding which levels are significantly different from one another
# Only run after you find your ANOVA independent variable p-values are < p-value cut off
TukeyHSD(yield.aov, which = "growing.season.length")
# Shows middle is significantly different from short, long is significantly different from short,
## and long is significantly different from middle

######## Check assumptions #######
# Look for outliers
plot(yield.aov, 1)
# Points 77, 25, and 17 outliers but likely not substantial enough to be removed, judgement call

# Using a numeric test to check for homogeneity of variances
leveneTest(yield ~ growing.season.length, data = yield.df)
# The p-value is not less than 0.05 so here is no evidence to suggest that the variance across groups is 
## statistically significantly different

# Check normality assumption by checking normality plot of the residuals
plot(yield.aov, 2)
# Points approximately follow the reference line so we can assume normality

# Checks normality of the residuals numerically
# Extract the residuals
aov.residuals.yield <- residuals(object = yield.aov)
# Run Shapiro-Wilk test
shapiro.test(x = aov.residuals.yield)
# p-value greater than 0.05 so this confirms our assumption from above

# Large outlier is 295, likely a data entry error because that isn't realistic!
summary(yield.df$yield)

######### Two-Way ANOVA, Tooth Growth ########
# This example is taken from this link: http://www.sthda.com/english/wiki/two-way-anova-test-in-r
# The built-in data set in R called Toothgrowth compares the effect of Vitamin C on
# tooth growth in guinea pigs
# Given one of 3 doses of Vitamin C: 0.5, 1.0, 2.0
# Givcen in the form of absorbic acid (AA) or orange juice (OJ)
tooth.df <- ToothGrowth

# Examining structure of data
str(tooth.df)

# Changing the numeric dose variable into a categorical variable for analysis
tooth.df$dose <- factor(tooth.df$dose, 
                       levels = c(0.5, 1, 2),
                       labels = c("D0.5", "D1", "D2"))

# ANOVA works well with balanced data or when our groups are of the same size
# Checking frequency in 3 dose groups
table(tooth.df$supp, tooth.df$dose)
# Have equivalent groups

# Visualize the data
ggboxplot(tooth.df, x = "dose", y = "len", color = "supp",
          palette = c("#00AFBB", "#E7B800"))

ggline(tooth.df, x = "dose", y = "len", color = "supp",
       add = c("mean_se", "dotplot"),
       palette = c("#00AFBB", "#E7B800"))

######### Run Two-Way ANOVA #########
# Run two-way ANOVA
tooth.aov <- aov(len ~ supp + dose, data = tooth.df)
summary(tooth.aov)
# Significant difference between type of Vitamin C and at least 2 levels of the dose

# Run two-way ANOVA with an interaction effect
tooth.aov.wInt <- aov(len ~ supp * dose, data = tooth.df)
summary(tooth.aov.wInt)

# Calculate summary statistics
group_by(tooth.df, supp, dose) %>%
  summarize(
    count = n(),
    mean = mean(len, na.rm = TRUE),
    median = median(len, na.rm = TRUE),
    sd = sd(len, na.rm = TRUE), 
    min = min(len, na.rm = TRUE),
    max = max(len, na.rm = TRUE)
  )

# Finding which levels are significantly different from one another
# Only run after you find your ANOVA independent variable p-values are < p-value cut off
# Do not need to run the code below for supp because there are only two levels, we know they are significantly different
TukeyHSD(tooth.aov.wInt, which = "dose")
# Shows all 3 pairwise comparisons are significant
# Means simply: D1 & D0.5 are significantly different than one another,
## D2 & D0.5 are significantly different from one another,
## D2 & D1 are significantly different from one another
# Shows estimated mean difference, lower confidence interval level, upper confidence interval level

######## Check assumptions #######
# Look for outliers
plot(tooth.aov.wInt, 1)
# Points 32 and 23 are outliers and removing them may be warranted because they will bias the results

# Using a numeric test to check for homogeneity of variances
leveneTest(len ~ supp*dose, data = tooth.df)
# The p-value is not less than 0.05 so here is no evidence to suggest that the variance across groups is 
## statistically significantly different

# Check normality assumption by checking normality plot of the residuals
plot(tooth.aov.wInt, 2)
# Points approximately follow the reference line so we can assume normality

# Checks normality of the residuals numerically
# Extract the residuals
aov_residuals <- residuals(object = tooth.aov.wInt)
# Run Shapiro-Wilk test
shapiro.test(x = aov_residuals)
# p-value greater than 0.05 so this confirms our assumption from above

