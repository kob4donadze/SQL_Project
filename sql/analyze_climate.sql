-- ============================================
-- Analysis 1: Average Monthly Temperature
-- ============================================

SELECT
    month,
    ROUND(AVG(tmin), 2) AS avg_min_temp,
    ROUND(AVG(tmax), 2) AS avg_max_temp
FROM climate_data
GROUP BY month
ORDER BY month;

-- ============================================
-- Analysis 2: Recent vs. Earlier Climate
-- ============================================

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

-- ============================================
-- Analysis 3: Monthly Temperature Range
-- ============================================
SELECT
    month,
    ROUND(AVG(tmax - tmin), 2) AS avg_temperature_difference
FROM climate_data
GROUP BY month
ORDER BY avg_temperature_difference DESC;

-- ============================================
-- Analysis 4: Average Monthly Precipitation
-- ============================================
SELECT
    month,
    ROUND(AVG(ppt), 2) AS avg_monthly_precipitation
FROM climate_data
GROUP BY month
ORDER BY avg_monthly_precipitation DESC;

-- ============================================
-- Analysis 5: Vegetable Suitability
-- ============================================
WITH vegetable_suitability AS (
    SELECT 
        v.name AS vegetable,
        v.min_temp AS req_min_temp,
        v.vegetation_days,
        -- Calculate total suitable days (30 days per suitable month)
        COUNT(c.month) * 30 AS available_suitable_days,
        -- Calculate 80% threshold required for harvest
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