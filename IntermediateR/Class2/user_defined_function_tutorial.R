# User-defined function introduction

#install.packages("data.table")
#install.packages("dplyr")
#install.packages("parallel")
#install.packages("purrr")
library(data.table)
library(dplyr)
library(purrr)
library(parallel)

# Obtain TEDS data at this link: https://www.datafiles.samhsa.gov/study-series/treatment-episode-data-set-admissions-teds-nid13518
teds <- as.data.frame(fread("~/Documents/R_Class_Meetup/Class7/tedsa_puf_2017.csv"), stringsAsFactors = F)
illicit.drug <- read.csv("~/Documents/R_Class_Meetup/Class7/illicit_drug_use_by_state.csv", stringsAsFactors = F)

# Recoding data to show labels instead of numbers for select variables
# Avoids need to search through the code book
teds.recode <- teds %>%
  mutate(marstat = case_when(MARSTAT == 1 ~ "Never Married",
                             MARSTAT == 2 ~ "Now Married",
                             MARSTAT == 3 | MARSTAT == 4 ~ "Divorced, Separated, Widowed",
                             MARSTAT == -9 ~ as.character(NA)),
         educ = case_when(EDUC <= 2 ~ "Less than high school",
                          EDUC == 3 ~ "High school or GED",
                          EDUC == 4 ~ "Some college",
                          EDUC == 5 ~ "Bachelors or higher",
                          EDUC == -9 ~ as.character(NA)),
         employ = case_when(EMPLOY == 1 ~ "Full-time",
                            EMPLOY == 2 ~ "Part-time",
                            EMPLOY == 3 | EMPLOY == 4 ~ "Unemployed, not in labor force",
                            EMPLOY == -9 ~ as.character(NA)),
         vet = case_when(VET == 1 ~ "Yes",
                         VET == 2 ~ "No",
                         VET == -9 ~ as.character(NA)),
         livarag = case_when(LIVARAG == 1 ~ "Homeless",
                             LIVARAG == 2 ~ "Dependent living",
                             LIVARAG == 3 ~ "Independent living",
                             LIVARAG == -9 ~ as.character(NA)),
         noprior = case_when(NOPRIOR == 0 ~ "No prior treatment episodes",
                             NOPRIOR == 1 ~ "One prior treatment episode",
                             NOPRIOR >= 2 ~ "More than one prior treatment episode",
                             NOPRIOR == -9 ~ as.character(NA)),
         sub1 = case_when(SUB1 == 1 ~ "None",
                          SUB1 == 2 ~ "Alcohol",
                          SUB1 == 3 ~ "Cocaine/crack",
                          SUB1 == 4 ~ "Marijuana/hashish",
                          SUB1 == 5 ~ "Heroin",
                          SUB1 == 6 ~ "Non-prescription methadone",
                          SUB1 == 7 ~ "Other opiates and synthetics",
                          SUB1 == 8 ~ "PCP",
                          SUB1 == 9 ~ "Other hallucinogens",
                          SUB1 == 10 ~ "Methamphetamine",
                          SUB1 == 11 ~ "Other amphetamine",
                          SUB1 == 12 ~ "Other stimulants",
                          SUB1 == 13 ~ "Benzodiazepines",
                          SUB1 == 14 ~ "Other non-benzodiazepine tranquilizers",
                          SUB1 == 15 ~ "Barbituates",
                          SUB1 == 16 ~ "Other non-barbituate sedatives or hypnotics",
                          SUB1 == 17 ~ "Inhalants",
                          SUB1 == 18 ~ "Over-the-counter medications",
                          SUB1 == 19 ~ "Other",
                          SUB1 == -9 ~ as.character(NA)),
         sub2 = case_when(SUB2 == 1 ~ "None",
                          SUB2 == 2 ~ "Alcohol",
                          SUB2 == 3 ~ "Cocaine/crack",
                          SUB2 == 4 ~ "Marijuana/hashish",
                          SUB2 == 5 ~ "Heroin",
                          SUB2 == 6 ~ "Non-prescription methadone",
                          SUB2 == 7 ~ "Other opiates and synthetics",
                          SUB2 == 8 ~ "PCP",
                          SUB2 == 9 ~ "Other hallucinogens",
                          SUB2 == 10 ~ "Methamphetamine",
                          SUB2 == 11 ~ "Other amphetamine",
                          SUB2 == 12 ~ "Other stimulants",
                          SUB2 == 13 ~ "Benzodiazepines",
                          SUB2 == 14 ~ "Other non-benzodiazepine tranquilizers",
                          SUB2 == 15 ~ "Barbituates",
                          SUB2 == 16 ~ "Other non-barbituate sedatives or hypnotics",
                          SUB2 == 17 ~ "Inhalants",
                          SUB2 == 18 ~ "Over-the-counter medications",
                          SUB2 == 19 ~ "Other",
                          SUB2 == -9 ~ as.character(NA)),
         childfirst = if_else(FRSTUSE1 <= 3, "Child", "Adult"),
         freq1 = case_when(FREQ1 == 1 ~ "No use in the past month",
                           FREQ1 == 2 ~ "Some use",
                           FREQ1 == 3 ~ "Daily use",
                           FREQ1 == -9 ~ as.character(NA)))

# Creating a user-defined fucntion for calculating the mode (most common value)


# mode.func is the function name
# function(x) means that x will be an argument within mode.func
# Wrap {} around the entire body of your function
mode.func <- function(x){
  # Creating a frequency table and converting it to a data frame
  freq.table <- data.frame(table(x))
  # Returning the drug from freq.table where the Freq variable is largest
  mode.val <- freq.table[freq.table$Freq == max(freq.table$Freq), ][1]
  # Removing the names from the value
  names(mode.val) <- NULL
  # Specify that I want to return the mode.val object from this function
  return(mode.val)
}

##### Demonstrating how to use a user-defined function #####
# Finding the most common primary substance in the system of those admitted to substance abuse treatment centers
drug1.mode <- mode.func(x = teds.recode$sub1)
# Now finding the most common secondary substance in their system
drug2.mode <- mode.func(teds.recode$sub2)
# Finding the most common marital status of those admitted to substance abuse facilities
marstat.mode <- mode.func(teds.recode$marstat)

# Next will live code an example for removing outliers from a data frame
# Will show the process of how to build complex user-defined functions
min.quantile <- 0.10
max.quantile <- 0.90

outlier.removal <- function(data, min, max){
  lower.cutoff <- quantile(data$illicit.drug.12.17, probs = min)
  upper.cutoff <- quantile(data$illicit.drug.12.17, probs = max)
  
  data.no.outliers <- dplyr::filter(data, between(illicit.drug.12.17, 
                                                  lower.cutoff, upper.cutoff))
  
  return(data.no.outliers)
  
}

illicit.no.out <- outlier.removal(data = illicit.drug, min = min.quantile, max = max.quantile)

removed <- anti_join(illicit.drug, illicit.no.out)

# Subsetting teds data to 5 drugs
# We will run a more complex user-defined function on these drugs individually
teds.sm <- filter(teds.recode, 
                  sub1 %in% c("Heroin", "Alcohol", "Marijuana/hashish", 
                              "Cocaine/crack", "Other opiates and synthetics"))
teds.recode$livarag <- as.factor(teds.recode$livarag)
# More complex user-defined function, more realistic to use in data science field
# Runs a logistic regression function, will subset data by groups and run for each drug individually
log.reg.function <- function(x){
  
  # When function is used the data will be subsetted
  # Need to defined factors in the subsetted data or empty factors will be included and error out model
  x$marstat <- factor(x$marstat, levels = c("Never Married", "Now Married", "Divorced, Separated, Widowed"))
  x$educ <- factor(x$educ, levels = c("High school or GED", "Less than high school", "Some college", "Bachelors or higher"))
  x$employ <- factor(x$employ, levels = c("Full-time", "Part-time", "Unemployed, not in labor force"))
  x$livarag <- factor(x$livarag, levels = c("Independent living", "Dependent living", "Homeless"))
  x$noprior <- factor(x$noprior, levels = c("No prior treatment episodes", "One prior treatment episode", "More than one prior treatment episode"))
  x$freq1 <- factor(x$freq1, levels = c("No use in the past month", "Some use", "Daily use"))
  x$childfirst <- factor(x$childfirst, levels = c("Adult", "Child"))
  
  # Running logistic regression model
  # Dependent variable: When they first tried the primary drug in their system, as an adult or as a child
  ## The dependent variable is what we are trying to explain
  # Independent variables: marstat (maritial status), employ (employment status),
  ## noprior (how many prior admissions to treatment facilities, 
  ## livarag (independent, dependent, homeless), freq1 (how often primary drug used)
  # Measuring the relationship between independent variables and dependent variable
  log.reg.model <- glm(data = x, childfirst ~ marstat + educ + employ + 
                         noprior + livarag + freq1, family = binomial)
  
  # Outputting the coefficients (magnitude of the relationship) from model
  coef <- log.reg.model$coefficients
  # Outputting the significance (measures how sure we are of results
  ## p value < 0.05 is considered significant/unlikely to have happened by chance
  pvalues <- round((coef(summary(log.reg.model))[,4]), digits = 5)
  
  # Formatting data frame that I will return
  results <- data.frame(cbind(coef, pvalues))[2:14, ] %>%
    tibble::rownames_to_column(var = "variable")
  
  # Specifying that the results object should be returned
  return(results)
  
}

run1 <- Sys.time()
# Below I am running the user-defined function from above grouped by primary substance
log.reg.results <- teds.sm %>%
  # Subsets data one by one to each individual drug
  group_by(sub1) %>%
  # Specifies to run the logistic regression function created above
  # keep = TRUE tells it to keep in the grouping level labels as a column
  group_modify(~log.reg.function(.), keep = TRUE) 

run2 <- Sys.time()
run2 - run1

# Subsetting the data to just the FLG variables
# These variables have a 1 if the drug is present and 0 if not present
teds.flags <- teds.recode %>%
  dplyr::select(contains("FLG"))

# Starting a parallel processing instance
# Runs more than 1 core on your computer and runs the functions in parallel
numCores <- detectCores() - 1
cl <- makeCluster(numCores)

# parSapply is the parallel version of sapply()
# Below I am summing all the columns to return the number of FLG == 1 for each drug
column.count <- parSapply(cl, teds.flags, FUN = sum)
column.count
# Below I am counting up all of the FLG == 1 values in each row
row.count <- parRapply(cl, teds.flags, FUN = sum)
# Showing the first 10 observations
head(row.count, n = 10L)
# Showing the max number of drugs one individual had in their system at the same time
max(row.count)

# Stopping the cluster used for the parallel processing
stopCluster(cl)

# packages for parallel processing: ff, bigmemory, parallel

