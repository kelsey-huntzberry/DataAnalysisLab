# Databricks notebook source
# # #Mount Azure Blob storage to Databricks
# storage_account_key = "accountkey"

# dbutils.fs.mount(
#   source = "wasbs://databricks-practice-container@kepracticestorage.blob.core.windows.net",
#   mount_point = "/mnt/opioid_data",
#   extra_configs = {"fs.azure.account.key.kepracticestorage.blob.core.windows.net": storage_account_key})

# teds1517 = spark.read.csv('dbfs:/mnt/opioid_data/tedsa_puf_2015_2017.csv',header="true", inferSchema="true")
# teds18 = spark.read.csv('dbfs:/mnt/opioid_data/tedsa_puf_2018.csv',header="true", inferSchema="true")

# # Converting Spark DataFrame to Delta Table
# deltaPath = "dbfs:/delta/opioid_data"
# dbutils.fs.rm(deltaPath, True)
# teds1517.write.format("delta").mode("overwrite").save(deltaPath + '/data201517')
# teds18.write.format("delta").mode("overwrite").save(deltaPath + '/data2018')

# display(dbutils.fs.ls(deltaPath))

# COMMAND ----------

# MAGIC %md
# MAGIC ### Transformers vs. Estimators Review
# MAGIC 
# MAGIC #### Transformers
# MAGIC - Transformers are used in preprocessing and feature generation
# MAGIC - The transformer will not change based on input data
# MAGIC - It does not need to be initialized by input data
# MAGIC - Example: Transforming predictor columns into a vector
# MAGIC 
# MAGIC #### Estimators
# MAGIC - Must be initialized with data or information from an input column
# MAGIC - Used before and fed into transformers
# MAGIC - Example: Min/Max Scaler needs the minimum and maximum value from a columns before use

# COMMAND ----------

# MAGIC %md
# MAGIC ### Read in data

# COMMAND ----------

#### USE BELOW FOR BIG DATA PRACTICE
deltaPath = "dbfs:/delta/opioid_data"
teds1517 = spark.read.format("delta").load(deltaPath + '/data201517')
teds18 = spark.read.format("delta").load(deltaPath + '/data2018')

column_order = teds1517.columns
teds18 = teds18.select(column_order)
teds_all = teds1517.union(teds18)

#### Also run the code below if you want faster run times and/or cheaper cluster
teds_all = teds_all.sample(False, 0.025, seed=0)

# COMMAND ----------

# Count number of substances in the person's system when they entered treatment
condition = lambda col: 'FLG' in col
col = teds_all.select(*filter(condition, teds_all.columns)).columns
teds_all = teds_all.withColumn('NUMSUBS', sum(teds_all[col]))

# COMMAND ----------

# Subset to columns without a lot of missing data
teds_sm = teds_all.select('CASEID','ADMYR','AGE','GENDER','RACE','ETHNIC','EDUC','EMPLOY','VET','LIVARAG',\
                          'STFIPS','CBSA2010','DIVISION','REGION','SERVICES','PSOURCE','NOPRIOR','ARRESTS','ROUTE1','FRSTUSE1','FREQ1', \
                          'ROUTE2','FRSTUSE2', 'FREQ2','ROUTE3','FRSTUSE3','FREQ3','NUMSUBS','METHUSE','ALCFLG','PSYPROB', \
                          'COKEFLG','MARFLG','HERFLG','METHFLG','OPSYNFLG','PCPFLG','HALLFLG','MTHAMFLG','AMPHFLG','STIMFLG', \
                          'BENZFLG','TRNQFLG','BARBFLG','SEDHPFLG','INHFLG','OTCFLG','OTHERFLG')

# COMMAND ----------

# MAGIC %md
# MAGIC ### Recoding variables

# COMMAND ----------

from pyspark.sql.functions import udf
from pyspark.sql.types import StringType
from pyspark.sql.types import DoubleType
from pyspark.sql.functions import col, when

def freq_recode(column1, column2, column3):
    if column1 == 1 and column2 == 1 and column3 == 1:
        return 0.0
    if (column1 == 3 or column2 == 3 or column3 == 3):
        return 2.0
    if (column1 == 2 or column2 == 2 or column3 == 2):
        return 1.0
    if (column1 == 1 or column2 == 1 or column3 == 1):
        return 0.0
    else:
        return None
      
freq_recode_udf = udf(freq_recode, DoubleType())

teds_sm = teds_sm.withColumn('FREQ', freq_recode_udf('FREQ1','FREQ2','FREQ3'))

# COMMAND ----------

from pyspark.sql.types import IntegerType

def age_recode(column1, column2, column3):
    if column1 == 1 or column2 == 1 or column3 == 1:
        return 1.0
    if column1 == 2 or column2 == 2 or column3 == 2:
        return 2.0
    if column1 == 3 or column2 == 3 or column3 == 3:
        return 3.0
    if column1 == 4 or column2 == 4 or column3 == 4:
        return 4.0
    if column1 == 5 or column2 == 5 or column3 == 5:
        return 5.0
    if column1 == 6 or column2 == 6 or column3 == 6:
        return 6.0
    if column1 == 7 or column2 == 7 or column3 == 7:
        return 7.0
    else:
       return None
      
age_recode_udf = udf(age_recode, DoubleType())

teds_sm = teds_sm.withColumn('FRSTUSE', age_recode_udf('FRSTUSE1','FRSTUSE2','FRSTUSE3'))

# COMMAND ----------

def oral_recode(column1, column2, column3):
    if (column1 == 1 and column1 != None) or (column2 == 1 and column2 != None) or (column3 == 1 and column3 != None):
        return 'Admin_Orally'
    elif (column1 > 1 and column1 != None) or (column2 > 1 and column2 != None) or (column3 > 1 and column3 != None):
        return 'Not_Admin_Orally'
    else:
        return None

oral_rc_udf = udf(oral_recode, StringType())
teds_sm = teds_sm.withColumn('ORAL_DRUG_USE', oral_rc_udf('ROUTE1','ROUTE2','ROUTE3'))

def smoking_recode(column1, column2, column3):
    if (column1 == 2 and column1 != None) or (column2 == 2 and column2 != None) or (column3 == 2 and column3 != None):
        return 'Admin_Smoking'
    elif (column1 > 0 and column1 != None) or (column2 > 0 and column2 != None) or (column3 > 0 and column3 != None):
        return 'Not_Admin_Smoking'
    else:
        return None

smoke_rc_udf = udf(smoking_recode, StringType())
teds_sm = teds_sm.withColumn('SMOKING_DRUG_USE', smoke_rc_udf('ROUTE1','ROUTE2','ROUTE3'))

def inhalation_recode(column1, column2, column3):
    if (column1 == 3 and column1 != None) or (column2 == 3 and column2 != None) or (column3 == 3 and column3 != None):
        return 'Admin_Inhale'
    elif (column1 > 0 and column1 != None) or (column2 > 0 and column2 != None) or (column3 > 0 and column3 != None):
        return 'Not_Admin_Inhale'
    else:
        return None

inhale_rc_udf = udf(inhalation_recode, StringType())
teds_sm = teds_sm.withColumn('INHALE_DRUG_USE', inhale_rc_udf('ROUTE1','ROUTE2','ROUTE3'))

def injection_recode(column1, column2, column3):
    if (column1 == 4 and column1 != None) or (column2 == 4 and column2 != None) or (column3 == 4 and column3 != None):
        return 'Admin_Injection'
    elif (column1 > 0 and column1 != None) or (column2 > 0 and column2 != None) or (column3 > 0 and column3 != None):
        return 'Not_Admin_Injection'
    else:
        return None
      
inject_rc_udf = udf(injection_recode, StringType())
teds_sm = teds_sm.withColumn('INJECT_DRUG_USE', inject_rc_udf('ROUTE1','ROUTE2','ROUTE3'))

def dich_flag_recode(column):
    if column == 0:
        return 'Not_Reported'
    if column == 1:
        return 'Reported'
    else:
        return None

flg_columns = ['ALCFLG','COKEFLG','MARFLG','HERFLG','METHFLG','OPSYNFLG','PCPFLG','HALLFLG','MTHAMFLG','AMPHFLG','STIMFLG','BENZFLG','TRNQFLG',
               'BARBFLG','SEDHPFLG','INHFLG','OTCFLG','OTHERFLG']    
      
dich_flag_udf = udf(dich_flag_recode, StringType())

from functools import reduce

teds_sm  = (reduce(
    lambda recode_df, col_name: recode_df.withColumn(col_name, dich_flag_udf(col(col_name))),
    flg_columns,
    teds_sm
))

# COMMAND ----------

# Male is zero, female is 1
teds_sm = teds_sm.withColumn("GENDER", when(col("GENDER") == 1, 'Male') \
                               .when(col("GENDER") == 2, 'Female'))

teds_sm = teds_sm.withColumn("METHUSE", when(col("METHUSE") == 1, 'Yes')\
                            .when(col("METHUSE") == 2, 'No'))

teds_sm = teds_sm.withColumn("RACE", when(col("RACE") == 1, "Alaska_Native") \
                             .when(col("RACE") == 2, "American_Indian") \
                             .when(col("RACE") == 3, "Asian_Pacific_Islander") \
                             .when(col("RACE") == 4, "Black") \
                             .when(col("RACE") == 5, "White") \
                             .when(col("RACE") == 6, "Asian") \
                             .when(col("RACE") == 7, "Other_Single_Race") \
                             .when(col("RACE") == 8, "Two_or_More_Races") \
                             .when(col("RACE") == 9, "Hawaiian_Pacific_Islander"))

teds_sm = teds_sm.withColumn("ETHNIC", when(col("ETHNIC") == 4, 'Hispanic') \
                             .when(col("ETHNIC") > 0, 'Not_Hispanic'))   
                               
teds_sm = teds_sm.withColumn("EDUC", when(col("EDUC") > 0, col("EDUC")).otherwise(None))

teds_sm = teds_sm.withColumn("EMPLOY", when(col("EMPLOY") == 1, "Full_Time") \
                             .when(col("EMPLOY") == 2, "Part_Time") \
                             .when(col("EMPLOY") == 3, "Unemployed") \
                             .when(col("EMPLOY") == 4, "Not_in_Labor_Force"))

teds_sm = teds_sm.withColumn("VET", when(col("VET") == 1, 'Yes') \
                             .when(col("VET") == 2, "No"))

teds_sm = teds_sm.withColumn("LIVARAG", when(col("LIVARAG") == 1, "Homeless") \
                             .when(col("LIVARAG") == 2, "Dependent_Living") \
                             .when(col("LIVARAG") == 3, "Independent_Living"))

teds_sm = teds_sm.withColumn("ARRESTS", when(col("ARRESTS") >= 0, col("ARRESTS")).otherwise(None))

teds_sm = teds_sm.withColumn("CBSA2010", when(col("CBSA2010") >= 0, col("CBSA2010")).otherwise(None))

teds_sm = teds_sm.withColumn("SERVICES", when(col("SERVICES") == 1, "Detox_Hospital_Inpatient") \
                             .when(col("SERVICES") == 2, "Detox_Residential") \
                             .when(col("SERVICES") == 3, "Rehab_Resid_Inpatient") \
                             .when(col("SERVICES") == 4, "Rehab_Resid_Short_Term") \
                             .when(col("SERVICES") == 5, "Rehab_Resid_Long_Term") \
                             .when(col("SERVICES") == 6, "Ambulatory_Intensive") \
                             .when(col("SERVICES") == 7, "Ambulatory_NonIntensive") \
                             .when(col("SERVICES") == 8, "Ambulatory_Detox"))

teds_sm = teds_sm.withColumn("PSOURCE", when(col("PSOURCE") == 1, "Self") \
                            .when(col("PSOURCE") == 2, "Alcohol_Drug_Prof") \
                            .when(col("PSOURCE") == 3, "Health_Care_Prof") \
                            .when(col("PSOURCE") == 4, "School") \
                            .when(col("PSOURCE") == 5, "Employer")
                            .when(col("PSOURCE") == 6, "Community") \
                            .when(col("PSOURCE") == 7, "Court"))

teds_sm = teds_sm.withColumn("NOPRIOR", when(col("NOPRIOR") == 0, 0) \
                            .when(col("NOPRIOR") > 0, 1))

teds_sm = teds_sm.withColumn("PSYPROB", when(col("PSYPROB") == 1, 'Yes') \
                            .when(col("PSYPROB") == 2, 'No'))

teds_sm = teds_sm.withColumn("DIVISION", when(col("DIVISION") == 0, "US_Territories") \
                            .when(col("DIVISION") == 1, "New_England") \
                            .when(col("DIVISION") == 2, "Middle_Atlantic") \
                            .when(col("DIVISION") == 3, "East_North_Central") \
                            .when(col("DIVISION") == 4, "West_North_Central") \
                            .when(col("DIVISION") == 5, "South_Atlantic")
                            .when(col("DIVISION") == 6, "East_South_Central") \
                            .when(col("DIVISION") == 7, "West_South_Central") \
                            .when(col("DIVISION") == 8, "Mountain") \
                            .when(col("DIVISION") == 9, "Pacific"))

teds_sm = teds_sm.withColumn("REGION", when(col("REGION") == 0, "US_Territories") \
                            .when(col("REGION") == 1, "Northeast") \
                            .when(col("REGION") == 2, "Midwest") \
                            .when(col("REGION") == 3, "South") \
                            .when(col("REGION") == 4, "West"))

teds_sm = teds_sm.withColumn("STFIPS", when(col("STFIPS") == 1, "Alabama") \
                            .when(col("STFIPS") == 2, "Alaska") \
                            .when(col("STFIPS") == 4, "Arizona") \
                            .when(col("STFIPS") == 5, "Arkansas")
                            .when(col("STFIPS") == 6, "California") \
                            .when(col("STFIPS") == 8, "Colorado") \
                            .when(col("STFIPS") == 9, "Connecticut") \
                            .when(col("STFIPS") == 10, "Delaware") \
                            .when(col("STFIPS") == 11, "DC") \
                            .when(col("STFIPS") == 12, "Florida") \
                            .when(col("STFIPS") == 15, "Hawaii") \
                            .when(col("STFIPS") == 16, "Idaho") \
                            .when(col("STFIPS") == 17, "Illinois") \
                            .when(col("STFIPS") == 18, "Indiana") \
                            .when(col("STFIPS") == 19, "Iowa") \
                            .when(col("STFIPS") == 20, "Kansas") \
                            .when(col("STFIPS") == 21, "Kentucky") \
                            .when(col("STFIPS") == 22, "Louisiana") \
                            .when(col("STFIPS") == 23, "Maine") \
                            .when(col("STFIPS") == 24, "Maryland") \
                            .when(col("STFIPS") == 25, "Massachusetts") \
                            .when(col("STFIPS") == 26, "Michigan") \
                            .when(col("STFIPS") == 27, "Minnesota") \
                            .when(col("STFIPS") == 28, "Mississippi") \
                            .when(col("STFIPS") == 29, "Missouri") \
                            .when(col("STFIPS") == 30, "Montana") \
                            .when(col("STFIPS") == 31, "Nebraska") \
                            .when(col("STFIPS") == 32, "Nevada") \
                            .when(col("STFIPS") == 33, "New_Hampshire") \
                            .when(col("STFIPS") == 34, "New_Jersey") \
                            .when(col("STFIPS") == 35, "New_Mexico") \
                            .when(col("STFIPS") == 36, "New_York") \
                            .when(col("STFIPS") == 37, "North_Carolina") \
                            .when(col("STFIPS") == 38, "North_Dakota") \
                            .when(col("STFIPS") == 39, "Ohio") \
                            .when(col("STFIPS") == 40, "Oklahoma") \
                            .when(col("STFIPS") == 42, "Pennsylvania") \
                            .when(col("STFIPS") == 44, "Rhode_Island") \
                            .when(col("STFIPS") == 45, "South_Carolina") \
                            .when(col("STFIPS") == 46, "South_Dakota") \
                            .when(col("STFIPS") == 47, "Tennessee") \
                            .when(col("STFIPS") == 48, "Texas") \
                            .when(col("STFIPS") == 49, "Utah") \
                            .when(col("STFIPS") == 50, "Vermont") \
                            .when(col("STFIPS") == 51, "Virginia") \
                            .when(col("STFIPS") == 53, "Washington")
                            .when(col("STFIPS") == 54, "West_Virginia") \
                            .when(col("STFIPS") == 55, "Wisconsin") \
                            .when(col("STFIPS") == 56, "Wyoming") \
                            .when(col("STFIPS") == 72, "Puerto_Rico"))

# COMMAND ----------

teds2018 = teds_sm.filter(teds_sm.ADMYR == '2018')

# COMMAND ----------

teds_recoded = teds2018.drop('FREQ1','FREQ2','FREQ3','FRSTUSE1','FRSTUSE2','FRSTUSE3','ROUTE1','ROUTE2','ROUTE3','ADMYR','CASEID','CBSA2010','STFIPS','REGION')
teds_recoded = teds_recoded.where(col('NOPRIOR').isNotNull())

# COMMAND ----------

from pyspark.sql.types import DoubleType

teds_recoded = teds_recoded.withColumn("AGE",teds_recoded["AGE"].cast(DoubleType()))
teds_recoded = teds_recoded.withColumn("NOPRIOR",teds_recoded["NOPRIOR"].cast(DoubleType()))
teds_recoded = teds_recoded.withColumn("ARRESTS",teds_recoded["ARRESTS"].cast(DoubleType()))
teds_recoded = teds_recoded.withColumn("NUMSUBS",teds_recoded["NUMSUBS"].cast(DoubleType()))
teds_recoded = teds_recoded.withColumn("EDUC",teds_recoded["EDUC"].cast(DoubleType()))

# COMMAND ----------

# To cut down run time, subsetting to fewer columns
teds_recoded = teds_recoded.select('RACE','DIVISION','LIVARAG','VET','METHUSE','ALCFLG','HERFLG','COKEFLG','EDUC','EMPLOY','SERVICES','OPSYNFLG',
                                   'FRSTUSE','PSOURCE','FREQ','NOPRIOR')

# COMMAND ----------

# MAGIC %md
# MAGIC ### Subsetting data into training, validation, and holdout data sets

# COMMAND ----------

import pyspark.sql.functions as F

(train_temp, test) = teds_recoded.randomSplit([.7, .3], seed=42)
(train, holdout) = train_temp.randomSplit([.8, .2], seed=42)

# COMMAND ----------

mode_impute_cols = [field for (field, dataType) in train.dtypes if ((dataType == "string") & (field != "NOPRIOR"))]

for col_name in mode_impute_cols:
    mode_counts = train.groupBy(col_name).count().toPandas()
    mode_value = list(mode_counts.sort_values('count', ascending=False).loc[:, col_name])[0]
    train = train.withColumn(col_name, when(col(col_name).isNull(), mode_value).otherwise(col(col_name)))
    test = test.withColumn(col_name, when(col(col_name).isNull(), mode_value).otherwise(col(col_name)))
    holdout = holdout.withColumn(col_name, when(col(col_name).isNull(), mode_value).otherwise(col(col_name)))

# COMMAND ----------

display(holdout)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Data Pre-Processing
# MAGIC #### Data Imputation
# MAGIC - The imputer function is an estimator that imputes data for numeric values
# MAGIC - Can replace missing values with the mean, median, or mode
# MAGIC - Data imputation for string values is not yet supported in Databricks. 
# MAGIC 
# MAGIC #### StringIndexer
# MAGIC - Estimator that encodes a string (categorical) column of labels to a column of label indices
# MAGIC - Your string columns will be converted to a number
# MAGIC - The numeric values can be converted back to string values using IndexToString
# MAGIC - Necessary because all categorical values must be numeric in machine learning models
# MAGIC 
# MAGIC #### One-Hot Encoder
# MAGIC - Estimator that encodes a string (categorical) column of labels to a column of label indices
# MAGIC - Your string columns will be converted to a number
# MAGIC - The numeric values can be converted back to string values using IndexToString
# MAGIC - Necessary because all categorical values must be numeric in machine learning models
# MAGIC 
# MAGIC #### VectorIndexer
# MAGIC - Decides whether a value is categorical or numeric based on the number of categories 
# MAGIC - Default maxCategories is 6, meaning columns with more than 6 distinct values will be classified as numeric
# MAGIC - Indexes categorical columns (only after StringIndexer is used)
# MAGIC - Places all columns into a sparse vector
# MAGIC - A sparse vector will place all predictors into one column
# MAGIC - It will only record non-zero values to save space and improve processing times
# MAGIC 
# MAGIC #### Other Useful Pre-Processing Steps
# MAGIC - PCA: Performs Principle Component Analysis on columns
# MAGIC - MinMaxScaler: Uses the Min-Max Scaler method to rescale your columns
# MAGIC - StandardScaler: Normalizes each column to be a mean of zero and have a standard deviation of 1
# MAGIC - Bucketizer: Transforms a column with continuous values into a feature with user-specified buckets
# MAGIC - SQL Transformer: Implements transformations that are defined by a SQL statement

# COMMAND ----------

# MAGIC %md
# MAGIC ### Machine Learning Pipelines
# MAGIC - You can create lists of estimators and transformers to perform in succession in a pipeline
# MAGIC - Creates workflows that are reproducible across training, validation, and holdout data sets
# MAGIC - Simplifies code for running a pipeline

# COMMAND ----------

# MAGIC %md
# MAGIC ### Set Experiment Name
# MAGIC Set Experiment Name by using the code below. Folder has to be one from the area where your notebooks are stored.

# COMMAND ----------

import mlflow
import mlflow.spark

experiment_name = "/Users/contact@kelseyhuntzberry.com/experiments/PySpark ML Class Experiment"
# experiment_id = mlflow.create_experiment(experiment_name)
mlflow.set_experiment(experiment_name)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Start MLFlow Run
# MAGIC Use this code below to start a run:
# MAGIC 
# MAGIC with mlflow.start_run(run_name="run_name") as run:
# MAGIC 
# MAGIC After this function all modeling code has to be indented. The run will complete after the indented code ends.

# COMMAND ----------

# MAGIC %md
# MAGIC ### Log Models and Parameters
# MAGIC - To log hyperparameters: mlflow.log_param("parameter_name", 1)
# MAGIC - To set and log a tag: mlflow.set_tag('tag_name', 'tag_value')
# MAGIC - To log a model so it can be reproduced and the model file will be saved: mlflow.spark.log_model(model_object, "model_name")
# MAGIC - To log a metric like accuracy or f-score: mlflow.log_metric("metric_name", 0.83)
# MAGIC - To log an artifact/file like a .csv file or graph: First export the file to storage then log the file using the path
# MAGIC 
# MAGIC       csv_path = "./file_name.csv"
# MAGIC       coefficient_df.to_csv(csv_path, index=False)
# MAGIC       mlflow.log_artifact(csv_path)

# COMMAND ----------

# MAGIC %md
# MAGIC ### Linear Regression Model

# COMMAND ----------

import mlflow
import mlflow.spark
import pandas as pd
from pyspark.ml.classification import LogisticRegression
from pyspark.ml.tuning import ParamGridBuilder, TrainValidationSplit
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml.feature import StringIndexer, VectorAssembler, OneHotEncoder, Imputer
from pyspark.mllib.evaluation import BinaryClassificationMetrics
from pyspark.mllib.util import MLUtils
from pyspark.ml import Pipeline

with mlflow.start_run(run_name="lasso_reg_model") as run:
  
    # Set tag for run
    mlflow.set_tag('run_type','lasso for feature selection')
  
    # Getting numeric and categorical column names
    categoricalCols = [field for (field, dataType) in train.dtypes if ((dataType == "string") & (field != "NOPRIOR"))]
    numericCols = [field for (field, dataType) in train.dtypes if ((dataType == "double") & (field != "NOPRIOR"))]

    # Adding label to columns created in each step of the modeling pipeline
    indexOutputCols = [x + "_Index" for x in categoricalCols]
    oheOutputCols = [x + "_OHE" for x in categoricalCols]
    numImputedCols = [x + "_Imputed" for x in numericCols]

    # Creating estimator and transformers for modeling pipeline
    stringIndexer = StringIndexer(inputCols=categoricalCols, outputCols=indexOutputCols, handleInvalid="skip")
    oheEncoder = OneHotEncoder(inputCols=indexOutputCols, outputCols=oheOutputCols)
    numImputer = Imputer(inputCols=numericCols, outputCols=numImputedCols, strategy='mode')

    # Create vector assembler for all columns, numeric and categorical
    assemblerInputs = oheOutputCols + numImputedCols
    vecAssembler = VectorAssembler(inputCols=assemblerInputs, outputCol="features")

    elasticNetParam=1
    mlflow.log_param("elastic_net_param", elasticNetParam)
    
    # Create model
    lr = LogisticRegression(labelCol="NOPRIOR", featuresCol="features",elasticNetParam=elasticNetParam)

    # Create modeling pipeline steps
    lr_pipeline_steps = [stringIndexer, oheEncoder, numImputer, vecAssembler, lr]
    # Run pipeline steps created above
    lr_pipeline = Pipeline(stages=lr_pipeline_steps)

    # Fit pipeline to training data
    lr_pipeline_model = lr_pipeline.fit(train)

    # Set up path to log model
    lr_pipelinePath = deltaPath + "/models/lr_baseline_pipeline_model"
    lr_pipeline_model.write().overwrite().save(lr_pipelinePath)

    # Use model to make predictions on test dataset
    lr_pipeline_trans = lr_pipeline_model.transform(test)

    # Log model
    mlflow.spark.log_model(lr_pipeline_model, "lasso_reg_model")
    
    predictionAndLabels = lr_pipeline_trans.select('NOPRIOR','probability').rdd.map(lambda row: (float(row['probability'][1]), float(row['NOPRIOR'])))
    metrics = BinaryClassificationMetrics(predictionAndLabels)
    
    # Calculate true/false positives and negatives
    TN = lr_pipeline_trans.filter('prediction = 0 AND NOPRIOR = prediction').count()
    TP = lr_pipeline_trans.filter('prediction = 1 AND NOPRIOR = prediction').count()
    FN = lr_pipeline_trans.filter('prediction = 0 AND NOPRIOR <> prediction').count()
    FP = lr_pipeline_trans.filter('prediction = 1 AND NOPRIOR <> prediction').count()

    # Calculate model evaluation metrics
    accuracy = (TN + TP) / (TN + TP + FN + FP)
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    F =  2 * (precision*recall) / (precision + recall)

    # Log evaluation metrics
    mlflow.log_metric("accuracy", accuracy)
    mlflow.log_metric("precision", precision)
    mlflow.log_metric("recall", recall)
    mlflow.log_metric("f-score", F)
    mlflow.log_metric("areaUnderROC", metrics.areaUnderROC)

    # Extract model portion of pipeline
    lr_model = lr_pipeline_model.stages[-1]
    
    # Extract coefficients into pandas dataframe
    coefficient_df = pd.DataFrame(list(zip(lr_model.coefficients, vecAssembler.getInputCols())), 
                                      columns = ['coefficient','feature']).sort_values(by="coefficient", ascending=False)

    # Log coefficients
    csv_path = "./lr_baseline_coefficients.csv"
    coefficient_df.to_csv(csv_path, index=False)
    mlflow.log_artifact(csv_path)

# COMMAND ----------

display(coefficient_df)

# COMMAND ----------

print("accuracy is: " + str(accuracy))
print("precision is: " + str(precision))
print("recall is: " + str(recall))
print("f-score is: " + str(F))
print("Area under ROC is: " + str(metrics.areaUnderROC))

# COMMAND ----------

# MAGIC %md
# MAGIC ### Random Forest Model

# COMMAND ----------

from pyspark.ml.classification import RandomForestClassifier

with mlflow.start_run(run_name="rf_base_model") as run:
    
    # Set tag for run
    mlflow.set_tag('run_type','random forest for feature selection')
    
    # Create model
    rf = RandomForestClassifier(labelCol="NOPRIOR", featuresCol="features")
    
    # Create modeling pipeline steps
    rf_pipeline_steps = [stringIndexer, oheEncoder, numImputer, vecAssembler, rf]
    # Run pipeline steps created above
    rf_pipeline = Pipeline(stages=rf_pipeline_steps)
    
    # Fit pipeline to training data
    rf_pipeline_model = rf_pipeline.fit(train)
    # Use model to make predictions on test dataset
    rf_pipeline_trans = rf_pipeline_model.transform(test)
    
    # Log model
    mlflow.spark.log_model(rf_pipeline_model, "rf_base_model")

    predictionAndLabels = lr_pipeline_trans.select('NOPRIOR','probability').rdd.map(lambda row: (float(row['probability'][1]), float(row['NOPRIOR'])))
    metrics = BinaryClassificationMetrics(predictionAndLabels)
    
    # Calculate true/false positives and negatives
    TN = rf_pipeline_trans.filter('prediction = 0 AND NOPRIOR = prediction').count()
    TP = rf_pipeline_trans.filter('prediction = 1 AND NOPRIOR = prediction').count()
    FN = rf_pipeline_trans.filter('prediction = 0 AND NOPRIOR <> prediction').count()
    FP = rf_pipeline_trans.filter('prediction = 1 AND NOPRIOR <> prediction').count()

    # Calculate model evaluation metrics
    accuracy = (TN + TP) / (TN + TP + FN + FP)
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    F =  2 * (precision*recall) / (precision + recall)
    
    # Log evaluation metrics
    mlflow.log_metric("accuracy", accuracy)
    mlflow.log_metric("precision", precision)
    mlflow.log_metric("recall", recall)
    mlflow.log_metric("f-score", F)
    mlflow.log_metric("areaUnderROC", metrics.areaUnderROC)
    
    # Extract feature importances and put them into a pandas dataframe
    rf_model = rf_pipeline_model.stages[-1]
    feature_imp_rf = pd.DataFrame(list(zip(vecAssembler.getInputCols(), rf_model.featureImportances)), 
                                  columns = ['feature','importance']).sort_values(by="importance", ascending=False)
    
    # Log feature importances
    csv_path = "./rf_feat_importances.csv"
    feature_imp_rf.to_csv(csv_path, index=False)
    mlflow.log_artifact(csv_path)

# COMMAND ----------

print("accuracy is: " + str(accuracy))
print("precision is: " + str(precision))
print("recall is: " + str(recall))
print("f-score is: " + str(F))
print("Area under ROC is: " + str(metrics.areaUnderROC))

# COMMAND ----------

display(feature_imp_rf)

# COMMAND ----------

# Subset to smaller number of important features
train_sm = train.drop('DIVISION_OHE','HERFLG_OHE','RACE_OHE','ALCFLG_OHE','VET_OHE')
test_sm = test.drop('DIVISION_OHE','HERFLG_OHE','RACE_OHE','ALCFLG_OHE','VET_OHE')
holdout_sm = holdout.drop('DIVISION_OHE','HERFLG_OHE','RACE_OHE','ALCFLG_OHE','VET_OHE')

# COMMAND ----------

# MAGIC %md
# MAGIC #### Grid Searches
# MAGIC - You can set a model to run multiple hyperparameter grid searches to perform automated parameter tuning
# MAGIC - In order to run a grid search you have to create a:
# MAGIC     - ParamGridBuilder
# MAGIC     - Evaluator
# MAGIC     - TrainValidationSplit or CrossValidator

# COMMAND ----------

# MAGIC %md
# MAGIC ### Perform a grid search with Gradient Boosted Trees

# COMMAND ----------

from pyspark.ml.tuning import ParamGridBuilder, TrainValidationSplit
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml.classification import GBTClassifier
import mlflow
import mlflow.spark
import pandas as pd
from pyspark.ml.feature import StringIndexer, VectorAssembler, OneHotEncoder
from pyspark.ml import Pipeline

with mlflow.start_run(run_name="gbt_maxDepth_stepSize_gs") as run:
    
    # Set tag for run
    mlflow.set_tag('run_type','gbt grid search')
  
    # Getting numeric and categorical column names
    categoricalCols_sm = [field for (field, dataType) in train_sm.dtypes if ((dataType == "string") & (field != "NOPRIOR"))]
    numericCols_sm = [field for (field, dataType) in train_sm.dtypes if ((dataType == "double") & (field != "NOPRIOR"))]

    # Adding label to columns created in each step of the modeling pipeline
    indexOutputCols_sm = [x + "_Index" for x in categoricalCols]
    oheOutputCols_sm = [x + "_OHE" for x in categoricalCols]
    numImputedCols_sm = [x + "_Imputed" for x in numericCols]
    
    assemblerInputs_sm = oheOutputCols_sm + numericCols_sm

    # Creating estimator and transformers for modeling pipeline
    stringIndexer_sm = StringIndexer(inputCols=categoricalCols_sm, outputCols=indexOutputCols_sm, handleInvalid="skip")
    oheEncoder_sm = OneHotEncoder(inputCols=indexOutputCols_sm, outputCols=oheOutputCols_sm)
    numImputer_sm = Imputer(inputCols=numericCols_sm, outputCols=numImputedCols_sm, strategy='mode')

    assemblerInputs_sm = oheOutputCols_sm + numImputedCols_sm
    vecAssembler_sm = VectorAssembler(inputCols=assemblerInputs_sm, outputCol="features")

    # Create model
    gbt = GBTClassifier(labelCol="NOPRIOR", featuresCol="features")

    # Create modeling pipeline steps
    gbt_pipeline_steps = [stringIndexer_sm, oheEncoder_sm, numImputer_sm, vecAssembler_sm, gbt]
    # Run pipeline steps created above
    gbt_pipeline = Pipeline(stages=gbt_pipeline_steps)

    # Build grid to perform grid search for hyperparameter tuning
    gbt_paramGrid = ParamGridBuilder()\
      .addGrid(gbt.maxDepth, [5, 10]) \
      .addGrid(gbt.stepSize, [0.1, 0.5])\
      .build()
  
    # Create model evaluator
    bin_eval_gbt = BinaryClassificationEvaluator(rawPredictionCol="prediction", labelCol="NOPRIOR", metricName="areaUnderROC")

    # Perform train test split
    gbt_tvs = TrainValidationSplit(estimator=gbt_pipeline,
                             trainRatio=0.7,
                             estimatorParamMaps=gbt_paramGrid,
                             evaluator=bin_eval_gbt)
                             # 70% of the data will be used for training, 30% for validation

    # Fit the pipeline with the steps created above
    gbt_tvs_fitted = gbt_tvs.fit(teds_recoded)
    # Retrieves only best model in the grid search according to ROC AUC to calculate full evaluation metrics on
    gbt_best_model = gbt_tvs_fitted.bestModel
    
    gbt_pred = gbt_best_model.transform(teds_recoded)

    # Evaluate model
    eval_test_metric = bin_eval_gbt.evaluate(gbt_pred)

    # Log model
    mlflow.spark.log_model(gbt_best_model, "gbt_maxDepth_stepSize_gs")

    # Log model parameters
    mlflow.log_param("maxDepth", gbt.maxDepth)
    mlflow.log_param("stepSize", gbt.stepSize)

    predictionAndLabels = gbt_pred.select('NOPRIOR','probability').rdd.map(lambda row: (float(row['probability'][1]), float(row['NOPRIOR'])))
    metrics = BinaryClassificationMetrics(predictionAndLabels)

    # Calculate model evaluation metrics
    TN = gbt_pred.filter('prediction = 0 AND NOPRIOR = prediction').count()
    TP = gbt_pred.filter('prediction = 1 AND NOPRIOR = prediction').count()
    FN = gbt_pred.filter('prediction = 0 AND NOPRIOR <> prediction').count()
    FP = gbt_pred.filter('prediction = 1 AND NOPRIOR <> prediction').count()

    # Calculate model evaluation metrics
    accuracy = (TN + TP) / (TN + TP + FN + FP)
    precision = TP / (TP + FP)
    recall = TP / (TP + FN)
    F =  2 * (precision*recall) / (precision + recall)

    # Log evaluation metrics
    mlflow.log_metric("accuracy", accuracy)
    mlflow.log_metric("precision", precision)
    mlflow.log_metric("recall", recall)
    mlflow.log_metric("f-score", F)
    mlflow.log_metric("areaUnderROC", metrics.areaUnderROC)

# COMMAND ----------

print("accuracy is: " + str(accuracy))
print("precision is: " + str(precision))
print("recall is: " + str(recall))
print("f-score is: " + str(F))
print("Area under ROC is: " + str(metrics.areaUnderROC))

# COMMAND ----------

# MAGIC %md
# MAGIC ### Automatically Choosing the Best Model
# MAGIC We want to choose the best model without human intervention. In real life you would run a much more exhaustive model validation, but for now we will choose the best model from only those small number of models run above. We will use the **f-score** as the evaluation metric for choosing the best model.

# COMMAND ----------

# Retrieving experiment name and ID
experiment = mlflow.get_experiment_by_name(experiment_name)
experiment_id = experiment.experiment_id

# Retrieving information on all runs in this experiment, ordering by f-score
run_data = mlflow.search_runs([experiment_id], order_by=["metrics.`f-score` DESC"])

# COMMAND ----------

# Showing all runs below
run_data

# COMMAND ----------

# MAGIC %md
# MAGIC ### Model Registry
# MAGIC The Databricks model registry allows you to register and version models to allow for easy deployment. I am registering the best model found above as a new version in the model registry.

# COMMAND ----------

# Retrieving run ID and path of the model from dataframe above
best_run_id = run_data.loc[:,'run_id'][0]
source_path = run_data.loc[:,'artifact_uri'][0] + '/' + run_data.loc[:,'tags.mlflow.runName'][0]

# Using the run ID to retrieve the run
best_run = mlflow.get_run(run_id=best_run_id)

from mlflow.tracking import MlflowClient

model_register_name = "substance-abuse-best-model"

client = MlflowClient()
# Commented out because I already created the model and am now creating new versions of it
#client.create_registered_model(model_register_name)

# Creating new model versions
result = client.create_model_version(
    name=model_register_name,
    source=source_path,
    run_id=best_run_id
)

# Setting model stage as "Staging"
model_version = result.version

client.transition_model_version_stage(
    name=model_register_name,
    version=model_version,
    stage="Staging"
)

# COMMAND ----------

