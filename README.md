# Goodcabs-Operations-Analysis

# City Trip Analytics SQL Project

This project addresses 6 real-world business requests using SQL, providing insights from city-level trip and revenue data.

## 🗂️ Project Summary

### 1. City-Level Fare and Trip Summary Report
- **Purpose:** Understand trip volume, fare efficiency, and city contribution.
- **Fields:** city_name, total_trips, avg_fare_per_trip, avg_fare_per_km, %_contribution

### 2. Monthly City-Level Trips Target Performance
- **Purpose:** Assess performance against monthly targets.
- **Fields:** city_name, month, actual_trips, target_trips, performance_status, % difference

### 3. Repeat Passenger Trip Frequency
- **Purpose:** Evaluate passenger loyalty by trip frequency.
- **Fields:** city_name, 2-Trips to 10-Trips %

### 4. Top and Bottom Cities by New Passengers
- **Purpose:** Identify cities with highest/lowest growth.
- **Fields:** city_name, total_new_passengers, city_category

### 5. Highest Revenue Month by City
- **Purpose:** Highlight peak revenue months.
- **Fields:** city_name, month, revenue, %_contribution_to_city_revenue

### 6. Repeat Passenger Rate Analysis
- **Purpose:** Measure monthly and overall repeat passenger behavior.
- **Fields:** city_name, month, total_passengers, repeat_passengers, monthly_repeat_rate %, city_repeat_rate %

## 📂 Files

- SQL queries in the `queries/` folder
- Sample outputs in the `output/` folder
- Optional schema and ERD diagrams in `schema/`

## 📊 Tools Used

- **Database:** MySQL
- **SQL Concepts:** Window functions, CTEs, JOINs, aggregations, conditional logic

## 📎 How to Use

1. Import `trips_db` and `targets_db` into MySQL Workbench.
2. Execute the queries from the `queries/` folder.
3. View the results or modify them as needed.

## 🔗 Author

**Your Name**  
Looking for Power BI Developer roles | Skilled in SQL, Excel, and Data Analysis  
[LinkedIn](#) | [GitHub](#) | [Email](#)
