# 🧮 SQL Data Analytics Portfolio

This repository showcases two SQL projects designed to demonstrate skills in **data cleaning**, **data exploration**, and **analytical querying** using **Microsoft SQL Server (T-SQL)**.  
Both projects focus on transforming data into meaningful insights through practical SQL techniques.

---

## 📊 Project 1: COVID-19 Data Exploration

### 🧠 Overview
This project explores COVID-19 data to analyze **infection rates**, **death ratios**, and **vaccination progress**.  
It demonstrates SQL techniques for cleaning, aggregating, and analyzing data.

> **File:** Covid_Data_Exploration.sql

### 🧩 Key Concepts Used
| Category | Description |
|-----------|--------------|
| **Filtering & Grouping** | Used `WHERE`, `GROUP BY`, and aggregate functions to summarize data. |
| **Joins** | Combined multiple tables to analyze related metrics. |
| **Window Functions** | Applied `OVER (PARTITION BY ...)` to calculate cumulative metrics. |
| **CTEs & Temp Tables** | Simplified complex queries for layered analysis. |
| **Views** | Stored reusable query results for dashboards. |
| **Data Cleaning** | Handled nulls and standardized values. |

### 📈 Example Insights
- Total cases, deaths, and mortality rate.  
- Running total of vaccinations.  
- Comparison of trends over time.

---

## 🏠 Project 2: Nashville Housing Data Cleaning

### 🧠 Overview
This project focuses on cleaning and transforming a **housing dataset** to prepare it for analysis.  
It demonstrates SQL skills such as standardizing formats, splitting columns, and removing duplicates.

> **File:** Nashville Housing Project Script (Data Cleaning).sql

### 🧹 Key Cleaning Steps
| Task | Description |
|------|--------------|
| **Populated Missing Data** | Filled missing values using SQL functions and joins. |
| **Split Address Components** | Extracted `Address`, `City`, and `State` into separate columns. |
| **Removed Duplicates** | Applied `ROW_NUMBER()` with `PARTITION BY` to delete duplicate rows. |
| **Normalized Columns** | Standardized values and updated column names. |

---

### 📊 Data Analysis on Cleaned Nashville Housing Data

This script demonstrates **analytical queries** performed on the cleaned Nashville Housing dataset.  
It highlights insights such as property sale trends, average sale prices, active owners, and top streets.

> **File:** Nashville Housing Project Script (Data Analyzing).sql

### 🧩 Key Analysis Techniques
| Technique | Description |
|-----------|--------------|
| **Aggregations & Grouping** | Used `COUNT()`, `AVG()`, and `SUM()` to summarize property data. |
| **Ordering & Ranking** | Used `ORDER BY` and `TOP N` queries to find least sale prices and top streets. |
| **CTEs (Common Table Expressions)** | Simplified multi-step queries, e.g., extracting street names or filtering top streets. |
| **CASE Statements** | Standardized and transformed data, e.g., removing `$` and `,` from sale prices. |
| **Filtering & Conditional Logic** | Applied `WHERE` and `HAVING` clauses for targeted analysis. |

### 📈 Example Insights
- Least property sale prices.  
- Top streets with the most properties sold.  
- Owners with multiple properties sold.  
- Average sale prices for single-family homes.  

---

