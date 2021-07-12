# Databricks notebook source
# MAGIC %md
# MAGIC ### Goal: Calculate Predictions Using Registered Model
# MAGIC In this notebook we load the most recent Staging model from the model registry and calculate predictions on the dataframe.

# COMMAND ----------

# Specifying schema because inferSchema is not working correctly
from pyspark.sql.types import StructType
from pyspark.sql.types import DoubleType
from pyspark.sql.types import StringType

schema = StructType() \
      .add("RACE",StringType(),True) \
      .add("DIVISION",StringType(),True) \
      .add("LIVARAG",StringType(),True) \
      .add("VET",StringType(),True) \
      .add("METHUSE",StringType(),True) \
      .add("ALCFLG",StringType(),True) \
      .add("HERFLG",StringType(),True) \
      .add("COKEFLG",StringType(),True) \
      .add("EDUC",DoubleType(),True) \
      .add("EMPLOY",StringType(),True) \
      .add("SERVICES",StringType(),True) \
      .add("OPSYNFLG",StringType(),True) \
      .add("FRSTUSE",DoubleType(),True) \
      .add("PSOURCE",StringType(),True) \
      .add("FREQ",DoubleType(),True) \
      .add("NOPRIOR",DoubleType(),True)

# COMMAND ----------

# Read in 1000 rows of data to calculate predictions on
predict_data = spark.read.format("csv").option("header", True).schema(schema).load('/FileStore/tables/substance_abuse_holdout_data.csv')

# COMMAND ----------

import mlflow

# Using "best model" registration to load model from MLFlow
model_name = "substance-abuse-best-model"
stage = 'Staging'

model_uri=f"models:/{model_name}/{stage}"
model = mlflow.spark.load_model(model_uri)

# Calculate predictions on Spark dataframe
predictions = model.transform(predict_data)

# COMMAND ----------

display(predictions)

# COMMAND ----------

# Writing predictions to Delta Lake
predictions.write.format("delta").mode("overwrite").save("/predictions/substance_abuse_predictions")

# COMMAND ----------

