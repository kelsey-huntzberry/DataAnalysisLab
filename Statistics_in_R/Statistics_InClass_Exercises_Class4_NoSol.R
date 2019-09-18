# Class 4 Basic Statistics in R

# Uncomment and install both of the packages below if you haven't already
#install.packages("car")
#install.packages("dplyr")

# Load packages
library(car)
library(dplyr)

# Turning off scientific notation
options(scipen=999)

# County-level medicaid enrollment and whether states have expanded medicaid
medicaid.exp.df <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class4/health_ins_expansion_data.csv", stringsAsFactors = F)
# Lady bird lake water quality tests, dissoved oxygen
water.qual <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class4/ladybirdlake_water_quality_2018.csv", stringsAsFactors = F)
# Import drinking/reaction time data
drinking <- read.csv("~/Documents/R_Class_Meetup/Statistics/Class4/beers_reaction_time.csv", stringsAsFactors = F)

################ Testing Assumptions for Medicaid Data ####################
# Change medicaid.expand to a factor variable
medicaid.exp.df$medicaid.expand <- as.factor(medicaid.exp.df$medicaid.expand)

# Below examining medicaid.exp.df percent on Medicaid that are less than 19 years old
qqPlot(medicaid.exp.df$pct.public.ins.lt.19, group = medicaid.exp.df$medicaid.expand)
qqPlot(medicaid.exp.df$pct.public.ins.19.to.64, group = medicaid.exp.df$medicaid.expand)
# Data is normal

# Checking for homogeneity of variances
leveneTest(pct.public.ins.lt.19 ~ medicaid.expand, data = medicaid.exp.df)
# Shows above that there are equal variances because the p-value is greater than 0.05
leveneTest(pct.public.ins.19.to.64 ~ medicaid.expand, data = medicaid.exp.df)
# Shows above that there are not equal variances because the p-value is less than 0.05

################# T-Test for Medicaid Child Enrollment ###############
# Running t-test on health insurance coverage data
# Two-tailed test
t.test.medicaid.exp.child.95 <- t.test(pct.public.ins.lt.19 ~ medicaid.expand, 
                                       data = medicaid.exp.df, var.equal = TRUE)
t.test.medicaid.exp.child.95
# Print 95% confidence intervals
t.test.medicaid.exp.child.95$conf.int

# Change confidence interval to 90%
t.test.medicaid.exp.child.90 <- t.test(pct.public.ins.lt.19 ~ medicaid.expand, 
                                 data = medicaid.exp.df, conf.level = 0.90)
t.test.medicaid.exp.child.90
# Print 90% confidence intervals
t.test.medicaid.exp.child.90$conf.int

# CONCLUSION: The mean child medicaid enrollment percent in non-expansion states is significantly
# highter than in expansion states. Why?
medicaid.exp.df %>% 
  group_by(medicaid.expand) %>% 
  summarize(mean.below.pov = mean(pct.lt.poverty))
# Also, Medicaid eligibility levels were always high for children everywhere

################ T-Test for Adult Enrollment ##################
# Adult enrollment did not show equal variances so need to adjust the code
# NOTE: Have var.equal equal to FALSE because variances are not equal with this data
t.test.medicaid.exp.adult.95 <- t.test(pct.public.ins.19.to.64 ~ medicaid.expand, 
                                       data = medicaid.exp.df, var.equal = FALSE)
t.test.medicaid.exp.adult.95
# Print 95% confidence intervals
t.test.medicaid.exp.adult.95$conf.int
# Medicaid enrollment for adults is significantly higher than in expansion states than non-expansion states

# Change confidence interval to 90%
t.test.medicaid.exp.adult.90 <- t.test(pct.public.ins.19.to.64 ~ medicaid.expand, 
                                       data = medicaid.exp.df, conf.level = 0.90,
                                       var.equal = FALSE)
t.test.medicaid.exp.adult.90
# Print 90% confidence intervals
t.test.medicaid.exp.adult.90$conf.int

############# Paired t-test ###################
# Calculate difference between groups
drinking$difference <- drinking$Before - drinking$After
# Plot a qqplot of the differences
qqPlot(drinking$difference)

drinking.t.test <- t.test(x = drinking$Before, y = drinking$After, paired = TRUE)
drinking.t.test

############# Exercise with Water Quality Data ################
# Changing year to a factor variable in water quality data
water.qual$WATERSHED <- as.factor(water.qual$WATERSHED)

# Below finding the sample size for the water.qual data set
nrow(water.qual)

# Check for normality with the WATERSHED variable as the grouping variable and RESULT as the dependent variable
# This will compare Barton Creek to Lady Bird Lake dissolved oxygen levels
# Is it normal? Do we need to use a non-parametric test for non-normal data?

# Not normal but could do the analysis because the sample is greater than 30 observations

# Now check for homogeneity of variance

# Homogeneity of variances is marginally significant, would have to proceed with caution
# Best to do a mark var.equal as FALSE

# Run appropriate t-test for the above data based on the sample size, qq-plot, and Levene's Test


# Mean dissolved oxygen is significantly higher in Lady Bird Lake than Barton Creek

# Print confidence intervals

