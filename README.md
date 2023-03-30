# Life_Expectancy_Prediction_with_R

ReadMe
Machine Learning Prediction of Life Expectancy using Support Vector Machine (SVM).
This study aims to predict life expectancy using support vector machine (SVM) linear machine learning algorithm. By doing so, it will investigate the factors that significantly contribute to life expectancy and evaluate the performance of the SVM algorithm in predicting life expectancy. The dataset used in this project is the World Health Organization (WHO) life expectancy dataset, which contains various features such as GDP, education level, alcohol consumption, adult mortality, BMI, and more. The project was written in R language and the main libraries used were e1071, caret, corrplot, CatEncoder, and tidyverse.

Installation and Usage
1.	Install the required libraries:
install.packages(c(“e1071”, “caret”, ”corrplot”, “CatEncoder”, “tidyverse”)) 

2.	Load the required libraries:
library(e1071, caret, corrplot, CatEncoder, tidyverse)

3.	Import the dataset:
df <- read.csv("life_expectancy.csv")

Dataset
The WHO life expectancy dataset used in this project can be found in the data folder. It contains 22 features and 2938 instances. The dataset was downloaded from Kaggle which was originally obtained from the World Health Organization (WHO) data repository website for 15 years (2000 – 2015) dataset concerning life expectancy for 193 countries. The corresponding socio-economic datapoints were collected from the United Nations database. The data set will be used to predict the life expectancy of each represented country for the period of 15 years.

Methodology
1.	Data Pre-processing: The dataset was cleaned, and the data type of population column was converted into numeric from character. The missing values in all numeric data were fixed with median values. NB: If mean or mode were used, it will give less accurate results because most of the features have skewed distribution. 
2.	Exploratory Data Analysis (EDA): The density plot and histogram distribution were plotted to show the various distribution of other attributes with the target label (life expectancy). Adult Mortality, Alcohol, Thinness has negatively skewed distribution while Diphtheria, Hepatitis B, and Polio were positively skewed. Schooling, Income Composition of Resources, Life Expectancy, and Total Expenditure have near normal or Gaussian distribution while BMI has a bimodal distribution.
3.	Feature Selection & Dataset Optimization: The most important features were selected while the redundant ones were dropped. Categorical variables like country and status were encoded with LabelEncoder before fitting them into the model. Standard scaler was used to scale the dataset within a specific range. 
4.	Model Selection: SVM regression was chosen as the machine learning algorithm due to its high accuracy and ability to handle non-linear continuous data.
5.	Model Design: The data was split into training and testing sets in 80:20 ratio using the createDataPartition() function and the SVM regression model was trained on the training set.
6.	Model evaluation: The performance and accuracy of the SVM model was evaluated on the testing set using r2, RMSE, and MAE score metrics.

Results
The result of the trained SVM model was optimized by iterating the model at varying tune lengths from 3 to 10 until better accuracy of the performance metrics was achieved. The SVM model achieved an r2 score of 73.99%, RMSE score of 4.8509, and MAE score of 3.1850.

Conclusion
This study used an SVM algorithm to predict life expectancy and identified the most correlated factors: schooling, BMI, income composition, and adult mortality. The study optimized performance metrics, achieving the best possible results.
