# Intermediate R Webinar: Data Manipulation with dplyr

# Install if necessary and load dplyr
#install.packages("dplyr)
library(dplyr)

# Set working directory
setwd("~/Documents/R_Class_Meetup/Class6")

# Read in data
census <- read.csv("~/Documents/R_Class_Meetup/Class6/Data/US_census_data.csv", stringsAsFactors = F)
medicaid.exp <- read.csv("~/Documents/R_Class_Meetup/Class6/Data/medicaid_expansion_status.csv", stringsAsFactors = F)
rural.codes <- read.csv("~/Documents/Opioid_Research/Data/Other_Data/ruralurbancodes2013.csv", header = T, stringsAsFactors = F)

# Print column names of census
ncol(census)

# Subset large data set to just county, pct_lt_poverty, unemployment_pct, pct_gt_high_school
census.sm <- census %>%
  select(county, pct_lt_poverty, unemployment_pct, pct_gt_high_school)

# Checking result
colnames(census.sm)

# Drop unemployment_pct from census.sm
census.demo <- census.sm %>% 
  select(-unemployment_pct)

# Checking result
colnames(census.demo)

# Select county, state, FIPS, all variables containing "total"
# and all variables containing gt_65
retire.df <- census %>%
  select(county, state, FIPS, contains("total"), contains("gt_65"))

# Check by printing column names
colnames(retire.df)

# Finding the 75th percentile of pct_lt_poverty
pov.75 <- quantile(census$pct_lt_poverty, probs = 0.75)

# Subset to only those states with pct_lt_poverty greater than the 75th percentile
high.poverty <- census %>% filter(pct_lt_poverty > pov.75)

summary(high.poverty$pct_lt_poverty)

# Sort census.sm by 
sorted.df <- census.sm %>%
  arrange(pct_lt_poverty, -unemployment_pct, pct_gt_high_school)

# Show first 6 rows to check data
head(sorted.df)

# Chained dplyr functions example
# First select these variables: county, state, FIPS, unemployment_pct, pct_govt_cash_asst, pct_food_stamps, pct_public_ins_lt_65
# Second filter to those counties with unemployment above the national average of 4.1
high.unemploy <- census %>%
  select(county, state, FIPS, unemployment_pct, pct_govt_cash_asst,
         pct_food_stamps, pct_public_ins_lt_65) %>%
  filter(unemployment_pct > 4.1)

# Check new data frame for accuracy
colnames(high.unemploy)
min(high.unemploy$unemployment_pct)

# Subset retire.df from above to only those variables including 2017, county, and state
retire.sm <- retire.df %>%
  select(county, state, ends_with("2017")) %>%
  mutate(perc.gt.65 = pop_gt_65_2017/pop_total_2017*100)

head(retire.sm, n = 3L)

# Pull median pct_food_stamps
median.food.stmp <- median(census$pct_food_stamps)
# Pull 33rd percentile and 66th percentile for unemployment_pct
perc.unemp <- quantile(census$unemployment_pct, probs = c(0.333, 0.666), na.rm = T)

unemploy.foodst <- census %>%
  # Select to county, state, FIPS, pct_food_stamps, pct_public_ins_19_to_64, pct_public_ins_lt_19, and unemployment_pct
  select(county, state, FIPS, pct_food_stamps, pct_public_ins_19_to_64, 
         pct_public_ins_lt_19, unemployment_pct) %>%
  # Create high/low group for pct_food_stamps with median value
  mutate(food_stamps_hl = if_else(pct_food_stamps > median.food.stmp, "High", "Low"),
         # Create high, medium, low groups with 33rd and 66th percentiles on census unemployment_pct with case_when=
         unemp.hml = case_when(unemployment_pct < perc.unemp[1] ~ "Low",
                               between(unemployment_pct, perc.unemp[1], perc.unemp[2]) ~ "Medium",
                               unemployment_pct > perc.unemp[2] ~ "High",
                               TRUE ~ as.character(NA)))

# Check results
table(unemploy.foodst$unemp.hml)
table(unemploy.foodst$food_stamps_hl)

# Create summary statistics of unemploy.foodst grouped by unemp.hml
pub.health.ins.summ <- unemploy.foodst %>%
  group_by(unemp.hml) %>%
  # Calculate mean adult and child public health insurance percents
  summarize(adult.pub.ins.pct = mean(pct_public_ins_19_to_64),
            child.pub.ins.pct = mean(pct_public_ins_lt_19))

# To use group_by() and retain the original structure of the data frame use mutate() instead of summarize()
pub.health.ins <- unemploy.foodst %>%
  group_by(unemp.hml) %>%
  # Calculate mean adult and child public health insurance percents
  mutate(adult.pub.ins.pct = mean(pct_public_ins_19_to_64),
            child.pub.ins.pct = mean(pct_public_ins_lt_19))

# Use if/else to make anything between 1-3 Metropolitan
# Everything else should be Rural
rural.codes.grp <- rural.codes %>%
  mutate(rural.metro = if_else(between(RUCC_2013,1,3), "Metropolitan", "Rural")) %>%
  # Removing RUCC_2013 rural code variable
  select(-RUCC_2013)

# Join in Medicaid expansion status with an inner join (keeping only matches)
# Chain another join in with left join to maintain the number of rows in the left data frame
pub.health.ins.exp <- inner_join(unemploy.foodst, medicaid.exp) %>%
  left_join(., rural.codes.grp)
# See that the above left join brings in 2 NA values for the 2 states where FIPS has been changed

# The joins above are equivalent to the code below
pub.health.ins.exp <- inner_join(unemploy.foodst, medicaid.exp, by = "state") %>%
  left_join(., rural.codes.grp, by = "FIPS")

# Summarize public health insurance by rural.metro and medcaid expansion status
med.exp.rur.summ <- pub.health.ins.exp %>%
  group_by(rural.metro, medicaid.expand) %>%
  summarize(adult.pub.ins.pct = mean(pct_public_ins_19_to_64),
            child.pub.ins.pct = mean(pct_public_ins_lt_19))

# Create a small data frame with duplicates
duplicate.df <- data.frame(cbind(c(1, 2, 3, 1),
                                 c(4, 5, 6, 4),
                                 c(7, 8, 9, 7)))
colnames(duplicate.df) <- c("var1", "var2", "var3")

# Show how dplyr can remove duplicates
no.dup <- duplicate.df %>%
  distinct(.)
no.dup
