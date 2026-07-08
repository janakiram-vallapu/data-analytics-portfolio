# Trader Performance vs Market Sentiment Analysis

## 📌 Project Overview

This project analyzes cryptocurrency trading data alongside the Crypto Fear & Greed Index to understand how market sentiment influences trader behavior and performance.

The analysis explores whether traders perform differently during Fear, Greed, Extreme Fear, and Extreme Greed market conditions.

---

## 🎯 Objectives

- Clean and preprocess trading and sentiment datasets.
- Merge historical trade data with the Fear & Greed Index.
- Engineer useful trading metrics.
- Analyze trader performance across different market sentiments.
- Generate actionable business insights and recommendations.

---

## 📂 Dataset

### Historical Trading Data

Contains information about:

- Account
- Coin
- Execution Price
- Trade Size
- Direction
- Closed PnL
- Fees
- Timestamp

### Fear & Greed Index

Contains:

- Date
- Fear & Greed Value
- Market Sentiment Classification

---

## 🛠 Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

---

## 📊 Analysis Performed

### Data Preprocessing

- Data loading
- Missing value validation
- Duplicate checking
- Date conversion
- Dataset merging

### Feature Engineering

- Daily PnL
- Total Trades
- Average Trade Size
- Win Rate

### Exploratory Data Analysis

- Average Daily PnL by Market Sentiment
- Trading Activity Analysis
- Trade Size Analysis
- Win Rate Comparison
- Daily PnL Distribution
- Correlation Analysis

---

## 📈 Key Findings

- Traders achieved higher average profits during Fear market conditions.
- Trading activity was highest during Extreme Fear.
- Larger average trade sizes were observed during Fear periods.
- Win rates remained relatively stable across different market sentiments.
- Correlation analysis indicated weak relationships among the analyzed trading metrics.

---

## ⚠ Limitations

- Leverage information was not available in the dataset.
- Unrealized PnL was not included.
- Analysis is limited to the provided historical data.

---

## 💡 Recommendations

- Monitor market sentiment before increasing trading activity.
- Avoid assuming that more trades always produce higher profits.
- Combine sentiment analysis with additional market indicators for better decision-making.

---

## Repository Structure

```
Trader-Performance-vs-Market-Sentiment-Analysis
│
├── data
├── notebooks
├── report
├── README.md
├── requirements.txt
└── .gitignore
```

## Author

**Janakiram Vallapu**

PrimeTrade.ai Internship Assessment