# Bank Marketing Analysis Project

## Overview
This project analyzes the outcomes of a bank's telemarketing campaign to predict customer behavior regarding term deposit subscriptions. Using a dataset of over 11,000 customers, the analysis identifies key factors influencing financial decisions, such as demographics, financial history, and campaign interaction frequency.

## Objectives
- Understand customer behavior through exploratory data analysis (EDA).
- Identify the most important features affecting term deposit subscriptions.
- Propose actionable strategies to optimize future marketing campaigns.

## Key Features
1. **Dataset Summary**:
   - 11,162 rows and 16 columns.
   - Variables include both quantitative (e.g., age, balance, duration) and categorical data (e.g., job, marital status, education).
   - Target variable: Whether a customer subscribes to a term deposit (`yes/no`).

2. **Analysis Highlights**:
   - **Univariate Analysis**: Distribution of key variables like job, education, and marital status.
   - **Multivariate Analysis**: Relationship between variables (e.g., job vs. subscription rate).
   - **Correlation Heatmap**: Identifies strong predictors, such as `duration` and `poutcome`.

3. **Modeling**:
   - Utilized Random Forest to handle non-linear relationships and rank feature importance.
   - Top influencing factors: Call duration, month of contact, and account balance.

## Insights and Recommendations
- **High Potential Segments**:
  - Customers aged 30–50 with high account balances.
  - University-educated individuals without loans.
- **Effective Campaign Practices**:
  - Use mobile phone communication for better engagement.
  - Focus on longer, more detailed calls for increased subscription likelihood.
- **Timing Optimization**:
  - Target campaigns during peak months like May for higher success rates.
## Tools and Technologies

### Data Analysis
- **R**: Used for comprehensive data preparation, cleaning, and exploratory analysis.  
  - **Data Cleaning**:
    - Checked for missing values: `colSums(is.na(data))`.
    - Removed missing data: `data <- na.omit(data)`.
    - Imputed missing values using `mice` package: 
      ```R
      library(mice)
      data <- mice(data, method = 'mean', m = 1)
      ```
    - Removed outliers: 
      ```R
      data <- data[data$balance < quantile(data$balance, 0.99), ]
      ```
  - **Data Transformation**:
    - Converted categorical variables to factors:
      ```R
      data$job <- as.factor(data$job)
      data$marital <- as.factor(data$marital)
      ```
  - **Statistical Analysis**:
    - Summary statistics: `summary(data$balance)` and `summary(data$age)`.

### Visualization
- **R for Static Visualizations**:
  - Histograms:
    ```R
    hist(data$age, main="Distribution of Age", xlab="Age", col="lightblue")
    ```
  - Boxplots:
    ```R
    boxplot(data$balance, main="Balance", ylab="Số dư")
    ```
  - Barplots:
    ```R
    job_counts <- table(data$job)
    barplot(job_counts, main="Frequency of Job Types", col="lightblue")
    ```

- **Power BI for Interactive Visualizations**:
  - Built dashboards to:
    - Display correlation heatmaps.
    - Show customer segmentation charts.
    - Highlight campaign performance by month and demographic groups.
  - Delivered actionable insights via interactive filters and dynamic visuals.

### Modeling
- **R**:
  - Random Forest for feature importance:
    ```R
    library(randomForest)
    model <- randomForest(outcome ~ ., data = dataset, ntree = 100)
    ```
## Conclusion
By implementing the proposed strategies and focusing on identified customer segments, the bank can achieve a 15–25% increase in subscription rates while optimizing campaign costs by 10–20%.

