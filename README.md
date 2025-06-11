# Disney-Box-Office-Predictions

Summary
This document outlines a data science project focused on predicting the financial success of Disney films using box office revenue as the primary metric. The project leverages statistical analysis and programming to explore various factors that might influence a film's success.

Significant Conclusion and Application to Data Science:
This project demonstrates the complexity of predictive modeling in real-world scenarios, highlighting the importance of:
Thorough Data Preparation: Data cleaning and preprocessing (including inflation adjustment) are critical steps that significantly impact model performance.
Feature Engineering: Creating new features (like dummy variables and interaction terms) can improve model accuracy.
Model Iteration and Selection: Building and comparing multiple models using techniques like subset selection and ANOVA is essential to find the best fit.
Understanding Model Limitations: Evaluating model performance metrics (R-squared, residual standard error) and recognizing the limitations of the model are vital.
Domain Knowledge: Incorporating domain-specific knowledge (e.g., how film release dates and star power might affect success) can enhance analysis and model building.
In a broader data science context, this project reinforces the idea that prediction is rarely straightforward. Even with advanced techniques, the inherent complexity and variability of real-world data often result in models with imperfect accuracy. This emphasizes the need for careful interpretation, validation, and understanding of the assumptions and limitations of any model. It also showcases the cyclical process of refining and iterating on data and modeling steps to gain the most significant insights and predictive power.

Key Points:
Objective: Predict Disney film box office success based on multiple variables.
Success Metric: Box office revenue (adjusted for inflation).

Data Sources: "Disney Movies Dataset.csv" and "disney_plus_titles.csv" consolidated into a single dataset.
Data Cleaning: Extensive cleaning involved handling missing values, removing irrelevant columns, formatting data, splitting release dates, and adjusting financial figures for inflation.

Variables: Budget, actors, directors, music composers, critic scores (IMDb, Metascore, Rotten Tomatoes), release date, and ratings were analyzed.
Inflation Adjustment: Crucial step to normalize financial data across different years using Consumer Price Index data.
Modeling: Multiple linear regression models were built, including interactions and polynomial terms.

Key Findings/ Results:
Budget significantly impacts box office revenue.
Critic scores (Metascore and Rotten Tomatoes) are strong predictors.
Music producer Hans Zimmer has a notable positive correlation with box office revenue.
June tends to be the highest grossing month for releases.
Ratings were not a significant predictor.

Final Model: Included interaction of inflation budget and Rotten Tomatoes, quadratic of Metascore, cubic of Rotten Tomatoes, and Hans Zimmer.
Model Limitations: Adjusted R-squared of 0.665 indicates moderate predictive power; high residual standard error suggests room for improvement.
Conclusion: Predicting film success is complex and involves many variables beyond those analyzed; model provides insights but is not perfect.

Key Resources and Tools Utilized:
Datasets:
"Disney Movies Dataset.csv" (Kaggle)
"disney_plus_titles.csv" (Kaggle)
"2022_Inflation_Convertion.csv" (Online inflation calculator using CPI data from The U.S. Labor Department's Bureau of Labor Statistics)
Programming Languages: R and Python were used for data cleaning, manipulation, analysis, and model building.
Statistical Methods:
Multiple Linear Regression
ANOVA (Analysis of Variance)
Simple Linear Regression
Subset Selection
Cook's Distance (for outlier detection)
Software: R Studio was used for statistical analysis and modeling.
