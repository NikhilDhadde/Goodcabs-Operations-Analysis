
-- Q1: City-Level Fare and Trip Summary Report
-- Generate a report that displays the total trips, average fare per km, average fare per trip, and the percentage contribution of each city's trips to the overall trips.
SELECT 
    city_name,
    COUNT(*) AS Total_Trip,
    ROUND(AVG(fare_amount), 2) AS Average_Fare_Amount,
    ROUND(SUM(fare_amount) / SUM(distance_travelled_km), 2) AS Average_Fare_Amount_per_KM,
    ROUND((COUNT(trip_id) / (SELECT COUNT(trip_id) FROM fact_trips) * 100), 2) AS pct_controbution_of_Total_Trip
FROM fact_trips T
JOIN dim_city C ON T.city_id = C.city_id
GROUP BY city_name;

-- Q2: Monthly City-Level Trips Target Performance Report
-- Compare the actual total trips with the target trips and categorize the performance.
WITH Target AS (
    SELECT 
        TT.city_id,
        C.city_name,
        MONTHNAME(Month) AS Month,
        total_target_trips
    FROM targets_db.monthly_target_trips TT
    JOIN dim_city C ON TT.city_id = C.city_id
),
Actual AS (
    SELECT 
        city_id, MONTHNAME(date) AS Month, COUNT(trip_id) AS Actual_trip
    FROM fact_trips
    GROUP BY city_id , MONTHNAME(date)
) 
SELECT 
    city_Name,
    T.Month,
    Actual_trip,
    Total_Target_trips,
    CASE 
        WHEN Actual_trip - Total_Target_trips >= 0 THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    ROUND((Actual_trip - Total_Target_trips) / Total_Target_trips * 100, 2) AS Ptc_diff    
FROM Target T
JOIN Actual A ON T.City_id = A.City_id AND T.Month = A.Month;

-- Q3: City-Level Repeat Passenger Trip Frequency Report
-- Show the percentage distribution of repeat passengers by the number of trips (2 to 10) taken in each city.
SELECT 
    city_name,
    ROUND(SUM(CASE WHEN trip_count = '2-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '2-trip %',
    ROUND(SUM(CASE WHEN trip_count = '3-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '3-trip %',
    ROUND(SUM(CASE WHEN trip_count = '4-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '4-trip %',
    ROUND(SUM(CASE WHEN trip_count = '5-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '5-trip %',
    ROUND(SUM(CASE WHEN trip_count = '6-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '6-trip %',
    ROUND(SUM(CASE WHEN trip_count = '7-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '7-trip %',
    ROUND(SUM(CASE WHEN trip_count = '8-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '8-trip %',
    ROUND(SUM(CASE WHEN trip_count = '9-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '9-trip %',
    ROUND(SUM(CASE WHEN trip_count = '10-Trips' THEN repeat_passenger_count ELSE 0 END) / SUM(repeat_passenger_count) * 100, 2) AS '10-trip %'
FROM dim_repeat_trip_distribution
JOIN trips_db.dim_city USING (city_id)
GROUP BY city_name
ORDER BY city_name;

-- Q4: Identify Cities with Highest and Lowest Total New Passengers
-- Identify top 3 and bottom 3 cities based on total new passengers.
WITH Total AS (
    SELECT city_name, SUM(new_passengers) AS Total_new_passengers
    FROM trips_db.fact_passenger_summary 
    JOIN dim_city USING (City_id)
    GROUP BY city_name
),
Ranked_City AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY total_new_passengers DESC) AS top,
              ROW_NUMBER() OVER (ORDER BY total_new_passengers) AS bottom	
    FROM Total
)
SELECT city_name, Total_new_passengers, 
    CASE 
        WHEN top <= 3 THEN 'Top 3'
        WHEN bottom <= 3 THEN 'Bottom 3' 
    END AS city_category
FROM Ranked_City
WHERE top <= 3 OR bottom <= 3
ORDER BY Total_new_passengers DESC;

-- Q5: Identify Month with Highest Revenue for Each City
-- Show each city’s highest revenue month and its contribution to total revenue.
WITH Month_wise AS (
    SELECT city_name, MONTHNAME(date) AS Month_Name, SUM(fare_amount) AS Total_fare
    FROM trips_db.fact_trips 
    JOIN dim_city USING (city_id)
    GROUP BY city_name, Month_Name
),
Ranked_data AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY city_Name ORDER BY Total_fare DESC) AS Rn 
    FROM Month_wise
),
City_wise AS (
    SELECT city_name, SUM(fare_amount) AS Total_fare_city
    FROM trips_db.fact_trips 
    JOIN dim_city USING (city_id)
    GROUP BY city_name
)
SELECT city_Name, Month_name, Total_fare,
       ROUND(Total_fare / Total_fare_city * 100, 2) AS Pct_contribution
FROM Ranked_data 
JOIN City_wise USING (City_name)
WHERE Rn = 1;

-- Q6: Monthly Repeat Passenger Rate
-- Calculate the repeat passenger rate for each city and month.
SELECT 
    city_name,
    MONTHNAME(p.month) AS month_name,
    total_passengers,
    repeat_passengers,
    ROUND((repeat_passengers / total_passengers * 100), 2) AS Pct_repeat_passengers
FROM trips_db.fact_passenger_summary p
LEFT JOIN dim_city c USING (City_id);

-- Q7: City-wide Repeat Passenger Rate
-- Calculate the overall repeat passenger rate for each city.
SELECT 
    city_name,
    SUM(total_passengers) AS total_passengers,
    SUM(repeat_passengers) AS repeat_passengers,
    ROUND((SUM(repeat_passengers) / SUM(total_passengers) * 100), 2) AS Pct_repeat_passengers
FROM trips_db.fact_passenger_summary p
LEFT JOIN dim_city c USING (City_id)
GROUP BY city_name;
