# Lentekhi Climate & Vegetable Suitability Analysis

## Project Overview

This project analyzes historical climate data for Lentekhi, Georgia,
with a focus on temperature conditions and potential vegetable
growing periods.

## Data

- Location: Lentekhi, Georgia
- Climate data: WorldClim
- Variables analyzed: minimum and maximum temperature
- Period: 1958–2025
- Vegetable requirements

## Analysis 

### 1.Average Monthly Temperature
Calculates the monthly average minimum (`avg_min_temp`) and maximum (`avg_max_temp`) temperatures in Celsius from raw daily climate observations to establish seasonal baselines.

```sql
SELECT
    month,
    ROUND(AVG(tmin), 2) AS avg_min_temp,
    ROUND(AVG(tmax), 2) AS avg_max_temp
FROM climate_data
GROUP BY month
ORDER BY month;
```
| month | avg_min_temp | avg_max_temp |
| :---: | :----------: | :----------: |
| 1 | -8.43 | 0.72 |
| 2 | -7.65 | 1.61 |
| 3 | -5.66 | 4.07 |
| 4 | -0.78 | 11.16 |
| 5 | 4.04 | 16.03 |
| 6 | 7.60 | 19.98 |
| 7 | 10.19 | 22.53 |
| 8 | 10.36 | 22.86 |
| 9 | 6.53 | 19.41 |
| 10 | 2.49 | 14.00 |
| 11 | -1.78 | 7.30 |
| 12 | -6.18 | 2.73 |


## 2. Historical vs. Recent Climate Comparison

Compares two distinct historical climate periods (**1958–1991** vs. **1992–2025**) to evaluate long-term temperature trends and regional climate shifts in Svaneti.

### SQL Query
```sql
WITH periods AS (
    SELECT
        CASE
            WHEN year <= 1991 THEN '1958–1991'
            ELSE '1992–2025'
        END AS period,
        tmin,
        tmax
    FROM climate_data
),
averages AS (
    SELECT
        period,
        AVG(tmin) AS avg_min_temp,
        AVG(tmax) AS avg_max_temp
    FROM periods
    GROUP BY period
)
SELECT
    period,
    ROUND(avg_min_temp, 2) AS avg_min_temp,
    ROUND(avg_max_temp, 2) AS avg_max_temp
FROM averages
ORDER BY period;
```
| period | avg_min_temp | avg_max_temp |
| :---: | :----------: | :----------: |
| 1958–1991 | 0.56 | 11.45 |
| 1992–2025 | 1.23 | 12.30 |

## 3.Monthly Temperature Range


Calculates the average diurnal (daily) temperature range (`avg_temperature_difference = tmax - tmin`) for each month to identify seasonal variation between daytime highs and nighttime lows in Svaneti.

### SQL Query
```sql
SELECT
    month,
    ROUND(AVG(tmax - tmin), 2) AS avg_temperature_difference
FROM climate_data
GROUP BY month
ORDER BY avg_temperature_difference DESC;
```
| month | avg_temperature_difference |
| :---: | :------------------------: |
|   9   |           12.88            |
|   8   |           12.50            |
|   6   |           12.38            |
|   7   |           12.35            |
|   5   |           11.99            |
|   4   |           11.94            |
|  10   |           11.51            |
|   3   |            9.74            |
|   2   |            9.25            |
|   1   |            9.15            |
|  11   |            9.08            |
|  12   |            8.91            |

## 4.Average Monthly Precipitation


Calculates average monthly precipitation levels (`avg_monthly_precipitation`) in millimeters (`ppt`) to identify rainy vs. dry seasons in Svaneti.

### SQL Query
```sql
SELECT
    month,
    ROUND(AVG(ppt), 2) AS avg_monthly_precipitation
FROM climate_data
GROUP BY month
ORDER BY avg_monthly_precipitation DESC;
```
| month | avg_monthly_precipitation |
| :---: | :-----------------------: |
|   6   |          116.71           |
|  12   |          102.88           |
|   7   |          101.87           |
|  10   |          101.82           |
|   4   |          100.59           |
|   5   |           98.19           |
|   8   |           97.85           |
|   9   |           96.02           |
|   1   |           95.51           |
|  11   |           92.10           |
|   3   |           85.77           |
|   2   |           79.16           |

##  5.Vegetable Suitability

Evaluates whether specific vegetables can be grown in Svaneti by checking if the total available days meeting each crop's minimum temperature requirement meet or exceed a 90% threshold of its required vegetation period.

### SQL Query
```sql
WITH vegetable_suitability AS (
    SELECT 
        v.name AS vegetable,
        v.min_temp AS req_min_temp,
        v.vegetation_days,
        -- Calculate total suitable days (30 days per suitable month)
        COUNT(c.month) * 30 AS available_suitable_days,
        -- Calculate 90% threshold required for harvest
        v.vegetation_days * 0.9 AS required_days_threshold
    FROM vegetables AS v
    LEFT JOIN climate_data AS c 
        ON c.tmin >= v.min_temp
    GROUP BY v.name, v.min_temp, v.vegetation_days
)
SELECT 
    vegetable,
    req_min_temp,
    vegetation_days,
    -- Simple TRUE / FALSE evaluation
    CASE 
        WHEN available_suitable_days >= required_days_threshold THEN TRUE 
        ELSE FALSE 
    END AS can_be_grown
FROM vegetable_suitability
ORDER BY can_be_grown DESC, vegetable ASC;
```
| vegetable | req_min_temp | vegetation_days | can_be_grown |
| :--- | :---: | :---: | :---: |
| Beetroot | 5.00 | 55 | true |
| Bell pepper | 10.00 | 65 | true |
| Broccoli | 5.00 | 60 | true |
| Cabbage | 5.00 | 65 | true |
| Carrot | 5.00 | 70 | true |
| Cauliflower | 5.00 | 55 | true |
| Cucumber | 10.00 | 50 | true |
| Eggplant | 10.00 | 75 | true |
| Garlic | 3.00 | 180 | true |
| Green beans (bush) | 10.00 | 50 | true |
## Key Findings

- Warming Trend (+0.67°C Min / +0.85°C Max): Comparing 1958–1991 against 1992–2025 demonstrates a clear long-term climate shift, with average minimum temperatures rising from 0.56°C to 1.23°C and maximum temperatures increasing from 11.45°C to 12.30°C.

- Short Frost-Free Window: Minimum temperatures remain above 0°C for only 6 months (May to October), making late spring through early autumn the primary open-field agricultural window in Lentekhi.


- High Diurnal Temperature Variation in Late Summer: September (12.88°C) and August (12.50°C) exhibit the largest gaps between daytime highs and nighttime lows, providing strong daytime warmth for ripening crops while requiring consideration for chilly nights.

- Consistent Year-Round Precipitation: Precipitation is well-distributed throughout the year, peaking in June (116.71 mm) and remaining above 79 mm even in the driest month (February at 79.16 mm), ensuring adequate water supply for summer crops.

- High Suitability for Cool and Warm-Season Crops: All evaluated vegetables—ranging from cold-hardy root crops like Garlic and Carrots to warm-season crops like Bell Peppers, Tomatoes, and Cucumbers—meet the 90% vegetation period requirement during suitable weather months.

