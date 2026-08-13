# Trader Performance vs Market Sentiment Analysis

## Project Overview

This project explores how cryptocurrency market sentiment affects trader behavior and profitability. It combines historical trade data with the Crypto Fear & Greed Index to analyze whether traders consistently perform better under certain sentiment states such as Fear, Greed, or Extreme Fear.

## Project Objectives

- Clean and validate trading and sentiment data
- Merge sentiment data with historical trades
- Create trading performance metrics
- Identify performance patterns across market conditions
- Derive business insights and recommendations

## Tools and Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

## Dataset

The project uses:

- Historical trading logs with trade price, size, direction, and PnL
- Market sentiment data from the Fear & Greed Index
- Time-based values required for trend and performance analysis

## Project Workflow

1. Loaded the trading and sentiment datasets.
2. Cleaned and validated missing or inconsistent values.
3. Converted dates and aligned the datasets for analysis.
4. Engineered KPIs such as daily PnL, trade volume, and win rate.
5. Compared performance across different sentiment states.
6. Visualized patterns and summarized the findings.

## Key Findings

- Average profitability was stronger during Fear market conditions.
- Trading volume increased during extreme negative sentiment periods.
- Trade size varied with sentiment and risk appetite.
- Win rates remained relatively stable across different market states.

## Limitations

- Leverage and unrealized PnL were not available in the dataset.
- The analysis is limited to the available historical sample.
- Additional market indicators could improve the predictive quality of the study.

## Repository Structure

```text
Primetrade_Project/
├── README.md
├── requirements.txt
├── .gitignore
├── data/
├── notebooks/
├── report/
├── images/
├── BI_Dashboard/
└── ...
```

## How to Use

1. Install the required packages from requirements.txt.
2. Open the notebook files in the notebooks folder.
3. Review the data and run the analysis to reproduce the findings.
4. Use the report or dashboard outputs for presentation and interpretation.

## Skills Demonstrated

- Data cleaning and preprocessing
- Trading analytics
- Sentiment and market analysis
- Exploratory data analysis
- Visualization and reporting
- Python-based analysis workflows

## Author

**Janaki Ram Vallapu**  
PrimeTrade.ai Internship Assessment
