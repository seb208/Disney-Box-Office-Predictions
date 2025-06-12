# **Disney Box Office Prediction Analysis**

This project aimed to predict the financial success of Disney films using box office revenue (adjusted for inflation) as the primary metric. Leveraging statistical analysis and programming, I explored various factors influencing a film's success.

---

## **Key Aspects:**

* **Objective**: To build a predictive model for Disney film box office revenue using various factors.

* **Success Metric**: Inflation-adjusted box office revenue.

* **Data Sources**: Consolidated "Disney Movies Dataset.csv" and "disney_plus_titles.csv" (from Kaggle) with an additional "2022_Inflation_Conversion.csv" using CPI data from the U.S. Bureau of Labor Statistics.

---

## **Data Cleaning (Python):**

Used `pandas` to merge datasets and handle missing values. Extracted year and month from release dates using string operations and date/time parsing. Formatted categorical data (actors, directors) by extracting the first entry in list strings.

---

## **Data Preprocessing (R):**

Used `dplyr` and `tidyr` for further cleaning and restructuring of the data. Applied inflation adjustment using a loop to match years and conversion rates. Created dummy variables for top actors, directors, and music composers.

---

## **Statistical Analysis (R):**

Implemented multiple linear regression models using the `lm()` function. Utilized `ANOVA` to compare models and test for significant terms. Performed subset selection using `regsubsets()` from the `leaps` package to identify key predictors. Identified outliers using `Cook's distance`.

---

## **Variables Analyzed:**

Budget, actors, directors, music composers (especially Hans Zimmer), critic scores (IMDb, Metascore, Rotten Tomatoes), release month (June), and ratings.

---

## **Key Findings:**

* **Budget** and **critic scores** (Metascore, Rotten Tomatoes) significantly predict box office revenue.

* **Hans Zimmer's** involvement showed a strong positive correlation.

* **June releases** performed best.

* Ratings were not a significant predictor.

---

## **Final Model:**

Included interaction between inflated budget and Rotten Tomatoes, quadratic of Metascore, cubic of Rotten Tomatoes, and Hans Zimmer as predictors.

* **Model Limitations**: Adjusted R-squared of 0.665, indicating moderate predictive power. High residual standard error suggests other factors are at play.

---

## **Conclusion:**

Predicting film success is complex. While the model offers valuable insights, other variables and external factors likely influence box office revenue.

---

## **Tools and Libraries:**

* **Python**: `pandas`

* **R**: `dplyr`, `tidyr`, `leaps`

* **Software**: R Studio

---

## **Statistical Analysis Methods:**

* **Multiple Linear Regression (MLR)**: Used to model the relationship between the box office revenue (dependent variable) and multiple predictor variables.

* **Simple Linear Regression (SLR)**: Used to analyze the relationship between two variables at a time, such as budget vs. box office or critic scores vs. box office.

* **ANOVA (Analysis of Variance)**: Used to compare different models and determine if adding or removing variables significantly improved the model fit. Specifically used to test for quadratic terms and interactions between variables.

* **Subset Selection**: Used to identify the most significant predictors of box office revenue from a larger set of variables. This helped in selecting the initial variables for the regression models.

* **Cook's Distance**: Used to identify influential outliers that might unduly affect the regression model.

---

In a broader data science context, this project reinforces the idea that prediction is rarely straightforward. Even with advanced techniques, the inherent complexity and variability of real-world data often result in models with imperfect accuracy. This emphasizes the need for careful interpretation, validation, and understanding of the assumptions and limitations of any model. It also showcases the cyclical process of refining and iterating on data and modeling steps to gain the most significant insights and predictive power.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
## **Model 2: Python-based Linear Regression for Box Office Prediction**

This section details a second predictive modeling approach for Disney film box office revenue, implemented in Python. It focuses on a streamlined machine learning workflow, emphasizing robust data preparation and clear visualization of results.

---

### **Strategy & Implementation:**

1.  **Data Preparation**: Loaded the Disney film dataset. Critical numerical columns (`Release Year`, `Budget (float)`, `IMDB score`, `Metascore`, `Box office (float)`) were converted to numeric types, handling non-numeric entries as missing values (`NaN`).

2.  **Feature Engineering & Handling Missing Values**:

    * **Predictors**: `Release Year`, `Budget (float)`, `IMDB score`, and `Metascore` were chosen as numerical predictors. `Release Month`, a categorical feature, was converted using **one-hot encoding** for model compatibility.

    * **Imputation**: Missing numerical values in both features and the target (`Box office (float)`) were filled using **mean imputation**, ensuring a complete dataset for the model.

3.  **Model Training**: A **Linear Regression** model was selected. Data was split into training (60%) and testing (40%) sets to evaluate performance on unseen data.

4.  **Model Evaluation**: Performance was assessed using **R-squared (Variance Score)**, an **Actual vs. Predicted Plot** (comparing forecasts to true values), and a **Residual Errors Plot** (analyzing prediction differences).

---

### **Accessibility & Design (Visualizations):**

The accompanying visualizations prioritize clarity and accessibility:

* **Distinct Colors**: Seaborn color palettes (e.g., 'viridis', 'cool') ensure strong contrast and differentiation.

* **Clear Labeling**: Axes are explicitly labeled with units, and font sizes are adjusted for readability. Titles are bolded for prominence.

* **Grid Lines**: Subtle grids aid in value interpretation.

* **Legend Placement**: Legends are strategically placed to avoid data overlap.

* **Line Weight**: Key lines, like the "Perfect Prediction Line" and "Zero Residual Line," are thicker and distinct for immediate visual identification.

---

### **Results:**

* **Coefficients**: The model produced coefficients for each input feature (e.g., Release Year, Budget, IMDB score, Metascore, and each Release Month), indicating their estimated impact on predicted box office revenue.

* **R-squared (R^2)**: The model achieved an R-squared score of **0.49**. This means roughly 49% of the variability in Disney film box office revenue can be explained by the chosen features.

* **Visual Interpretation**:

    * The **Actual vs. Predicted plot** shows a general positive correlation, with some spread around the perfect prediction line, aligning with the R-squared value.

    * The **Residual Errors plot** helps identify patterns in the errors, which could suggest areas for model improvement or indicate unmodeled factors.
