# Disney-Box-Office-Predictions

Disney Box Office Prediction Analysis

This project aimed to predict the financial success of Disney films using box office revenue (adjusted for inflation) as the primary metric. Leveraging statistical analysis and programming, I explored various factors influencing a film's success.

Key Aspects:

Objective: To build a predictive model for Disney film box office revenue using various factors.
Success Metric: Inflation-adjusted box office revenue.
Data Sources: Consolidated "Disney Movies Dataset.csv" and "disney_plus_titles.csv" (from Kaggle) with an additional "2022_Inflation_Conversion.csv" using CPI data from the U.S. Bureau of Labor Statistics.

Data Cleaning (Python):
Used `pandas` to merge datasets and handle missing values.
Extracted year and month from release dates using string operations and date/time parsing.
Formatted categorical data (actors, directors) by extracting the first entry in list strings.

Data Preprocessing (R):
Used `dplyr` and `tidyr` for further cleaning and restructuring of the data.
Applied inflation adjustment using a loop to match years and conversion rates.
Created dummy variables for top actors, directors, and music composers.

Statistical Analysis (R):
Implemented multiple linear regression models using the `lm()` function.
Utilized `ANOVA` to compare models and test for significant terms.
Performed subset selection using `regsubsets()` from the `leaps` package to identify key predictors.
Identified outliers using `Cook's distance`.

Variables Analyzed: Budget, actors, directors, music composers (especially Hans Zimmer), critic scores (IMDb, Metascore, Rotten Tomatoes), release month (June), and ratings.

Key Findings:
Budget and critic scores (Metascore, Rotten Tomatoes) significantly predict box office revenue.
Hans Zimmer's involvement showed a strong positive correlation.
June releases performed best.
Ratings were not a significant predictor.

Final Model: Included interaction between inflated budget and Rotten Tomatoes, quadratic of Metascore, cubic of Rotten Tomatoes, and Hans Zimmer as predictors.
Model Limitations: Adjusted R-squared of 0.665, indicating moderate predictive power. High residual standard error suggests other factors are at play.

Conclusion: Predicting film success is complex. While the model offers valuable insights, other variables and external factors likely influence box office revenue.

Tools and Libraries:
Python: `pandas`
R: `dplyr`, `tidyr`, `leaps`
Software: R Studio


Statistical Analysis:
Multiple Linear Regression (MLR): Used to model the relationship between the box office revenue (dependent variable) and multiple predictor variables.
Simple Linear Regression (SLR): Used to analyze the relationship between two variables at a time, such as budget vs. box office or critic scores vs. box office.
ANOVA (Analysis of Variance): Used to compare different models and determine if adding or removing variables significantly improved the model fit. Specifically used to test for quadratic terms and interactions between variables.
Subset Selection: Used to identify the most significant predictors of box office revenue from a larger set of variables. This helped in selecting the initial variables for the regression models.
Cook's Distance: Used to identify influential outliers that might unduly affect the regression model.

In a broader data science context, this project reinforces the idea that prediction is rarely straightforward. Even with advanced techniques, the inherent complexity and variability of real-world data often result in models with imperfect accuracy. This emphasizes the need for careful interpretation, validation, and understanding of the assumptions and limitations of any model. It also showcases the cyclical process of refining and iterating on data and modeling steps to gain the most significant insights and predictive power.
