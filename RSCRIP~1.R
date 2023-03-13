
#Step 1
#Importing data into data frame and installing relevant packages
df <- read.csv("life_expectancy.csv")

#Check the structure and and summary of dataset

str(df)
summary(df)

#Installing Necessary Packages

install.packages("caret")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("corrplot")
install.packages("dplyr")
install.packages("tidyr")
install.packages("CatEncoders")

#Loading into libraries

library(caret)
library(ggplot2)
library(tidyverse)
library(corrplot)
library(dplyr)
library(tidyr)
library(CatEncoders)

#Step 2: Data Pre-processing
#Data Cleaning 
#1. Converting Population column from character to numeric

df$Population <- as.numeric(df$Population)
df$Population[df$Population == ""] <- ' '
df$Population <- as.numeric(df$Population)
str(df)

#Select only the numeric data leaving out the categorical data for now

df_num <- select_if(df, is.numeric)

#2. Filling the null/missing values with median

for (i in colnames(df_num)) { df_num[[i]] [is.na(df_num[[i]])] <- median(df_num[[i]], na.rm = TRUE)
}

#Check for null values after the filling up to confirm the step
anyNA(df_num)
str(df_num)
summary(df_num)

#Step 3: EDA

#1: Plotting the Histogram distribution to show variable distributions and visualizations

df_num %>% 
  gather(key = key, value = value) %>%
  mutate(key = as.factor(key)) %>% 
  ggplot(aes(x = value, fill = key)) + 
  geom_histogram(colour = "black") + facet_wrap(~key, scales = "free", ncol = 5) +
  theme(legend.position = "none", strip.background = element_rect(fill = "grey", size = 8))
        strip.text = element_text(colour = "black", face = "bold"),
        + labs(x = "values", y = "count")

#2: Plotting the Box plot to show variable out liers
        
df_num %>% 
  gather(key = key, value = value) %>%
  mutate(key = as.factor(key)) %>% 
  ggplot(aes(x = value, fill = key)) + 
  geom_boxplot(colour = "black") + facet_wrap(~key, scales = "free", ncol = 5) +
  theme(legend.position = "none", strip.background = element_rect(fill = "grey", size = 8))
        strip.text = element_text(colour = "black", face = "bold"),
        + labs(x = "values", y = "count")

#3: Plotting the density distribution to show variable distributions and visualizations        
df_num %>% 
  gather(key = key, value = value) %>%
  mutate(key = as.factor(key)) %>% 
  ggplot(aes(x = value, fill = key)) + 
  geom_density(colour = "black") + facet_wrap(~key, scales = "free", ncol = 5) +
  theme(legend.position = "none", strip.background = element_rect(fill = "grey", size = 8))
        strip.text = element_text(colour = "black", face = "bold"),
        + labs(x = "values", y = "count")

#4: Plotting correlation matrix of the variable with the target
df_corplot <- cor(df_num)
corrplot(df_corplot, method = "number", type = "upper", number.cex = 0.30)

#5: Encoding of Categorical data
#Since country and status are categorical data that will be useful for our model,
#we encode them to enable us use them for the prediction.

Country <- LabelEncoder.fit(df$Country)
df$Country <- transform(Country, df$Country)
Status <- LabelEncoder.fit(df$Status)
df$Status <- transform(Status, df$Status)

#Step 4: Data Set Optimization
#1: Feature selection: selecting the correlated features and dropping redundant ones
drops <- c('Infant.Deaths', 'HIV.AIDS', 'Measles', 'Percentage.Expenditure',
           'Population', 'Under.Five.Deaths', 'GDP', 'Thinness.5.9.Years')

#Save the required features in a separate data frame.
df_data <- df[, !(names(df) %in% drops)]

#2: Standardization of only the predictors
df_std <- df_data %>% mutate_at(c('Country', 'Year', 'Status', 'Adult.Mortality', 
                                  'Alcohol', 'Hepatitis.B', 'BMI', 'Polio', 
                                  'Total.Expenditure', 'Diphtheria', 
                                  'Thinness..1.19.Years', 
                                  'Income.Composition.of.Resources', 
                                  'Schooling'), ~(scale(.) %>% as.vector))
for (i in colnames(df_std)) { df_std[[i]] [is.na(df_std[[i]])] <- median(df_std[[i]], na.rm = TRUE)
}
anyNA(df_std)
summary(df_std)

#3: Plotting correlation graph of features and target
Co_plot1 <- plot(df_data$Schooling,df_data$Life.Expectancy, pch = 19, col = "light blue") 
Co_plot1 <- plot(df_data$Income.Composition.of.Resources,df_data$Life.Expectancy, pch = 19, col = "light blue")
Co_plot1 <- plot(df_data$Adult.Mortality,df_data$Life.Expectancy, pch = 19, col = "light blue")
Co_plot1 <- plot(df_data$BMI,df_data$Life.Expectancy, pch = 19, col = "light blue")


#Step 5: Data Splicing
#1: Splitting Data for training and testing models
df_split <- createDataPartition(df_std$Life.Expectancy, p = 0.8, list = FALSE)

df_train <- df_std[df_split,]
df_test <- df_std[-df_split,]

#2: Checking the dimensions of training and testing data frame
dim(df_train)
dim(df_test)


#3: Implement train control method to control all computational overheads
train_ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

#4: Install additional package 

install.packages("e1071")
library(e1071)

#Step 6: Build SVM ML Algorithm

df_svm.linear <- train(Life.Expectancy~., data = df_train, 
                       method = "svmLinear", trControl = train_ctrl,
                       preProcess = c("center","scale"),tunelength = 10)

#Check the result of the trained model
df_svm.linear

#Step 7: Predict with trained model

df_pred <- predict(df_svm.linear, newdata = df_test)


#To check the characteristics of the predicted and observed variables
df_pred          #predicted 

length(df_pred)

df_test$Life.Expectancy     #target label
length(df_test$Life.Expectancy)

#Step 8: Check Model Accuracy

# accuracy check using statistical parameters
df_MAE = MAE(df_test$Life.Expectancy, df_pred)
df_RMSE = RMSE(df_test$Life.Expectancy, df_pred)
df_R2 = R2(df_test$Life.Expectancy, df_pred)

#Step 9: Plot a regression line for predicted and observed
plot(df_pred~df_test$Life.Expectancy, ylab = 'Predicted Life Expectancy', 
     xlab = 'Observed Life Expectancy')
abline(0,1, col=2)

#Step 10: Model Optimization
for (i in 3:10){
  df_svm.linear<-train(Life.Expectancy~., data=df_train,
                       method= "svmLinear", trControl = train_ctrl,
                       preprocess = c("center","scale"), tunelength=i)
  print(i)  
  print(df_svm.linear)
}
#Using a tune length of 4
df_svm.linear.4 <- train(Life.Expectancy~., data = df_train, 
                       method = "svmLinear", trControl = train_ctrl,
                       preProcess = c("center","scale"),tunelength = 4)

#Predicting with an optimized tune length
df_pred.4 <- predict(df_svm.linear, newdata = df_test)

df_pred.4

#Plotting with the new predicted value at tunelength of 4
plot(df_pred.4~df_test$Life.Expectancy, ylab = 'Predicted Life Expectancy', 
     xlab = 'Observed Life Expectancy')

#Adding a correlation line
abline(0,1, col=2)

#Step 11: Graphs of Performance Metrics at Tunelengths
#Creating a dataframe for the performance metrics
df_met <- data.frame(
  Tunelength = c(3,4,5,6,7,8,9,10),
  MAE = c(3.1848, 3.1850, 3.1853, 3.1850, 3.1866, 3.1846, 3.1866, 3.1858),
  RMSE = c(4.8535, 4.8509, 4.8537, 4.8540, 4.8551, 4.8462, 4.8586, 4.8556),
  R2 = c(0.7396, 0.7399, 0.7396, 0.7396, 0.7394, 0.7396, 0.7396, 0.7394)
)

#Plotting the graphs of the performance metrics at varying tunelengths
plot(df_met$Tunelength, df_met$MAE, type = "l", col = "light blue", lwd = 4, xlab = "Tunelength", ylab = "MAE")

plot(df_met$Tunelength, df_met$RMSE, type = "l", col = "light green", lwd = 4, xlab = "Tunelength", ylab = "RMSE")

plot(df_met$Tunelength, df_met$R2, type = "l", col = "yellow", lwd = 4, xlab = "Tunelength", ylab = "R2")
