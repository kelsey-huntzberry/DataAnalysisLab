# Project Name: Predicting Substance Abuse Treatment Readmission

## Project Data:
This code uses the Treatment Episode Data Set or TEDS (https://www.datafiles.samhsa.gov/study-series/treatment-episode-data-set-admissions-teds-nid13518), which includes all publicly funded substance abuse treatment admissions in the US. Along with thesse records of admission, basic demographics and substance use history are included in the data set.

## Project Description:
In the Python code included in this folder, I used demographics and substance use history to predict whether a patient was being admitted for their first treatment or if they had been admitted at least once before. I used variables such as age, race, employment status, and age of first substance use to predict whether a treatment was a readmission.

## Methods:
I created and validated a machine learning model to predict whether a treatment was a readmission. I used stratefied random sampling to choose a training data set (50% of data), test data set (30%), and a holdout data set (20%). I tried the following models: Logistic regression, ridge regression, lasso regression, random forest, gradient boosted trees, stochastic gradient boosted trees, and k-nearest neighbors. I used multiple grid searches to perform hyperparameter tuning to pick the best model. I compared the models using accuracy, F1-scores, confusion matrices, and ROC curves to compare models.

## Results:
Random forest was chosen as the best model for prediction of readmission. This model was the only one which had predicted first admissions at rates higher than chance. All models were much better at predicting a repeated admission. Overall accuracy for this model was 70% with an AUC of 0.74. ROC curves and a confusion matrix of the chosen model are included in the project folder.

Gradient boosted trees had a higher overall accuracy but only did well at predicted a repeated admission. Prediction of first admissions was no better than chance.
