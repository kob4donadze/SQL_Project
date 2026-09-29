COPY climate_data
FROM 'C:\Program Files\PostgreSQL\18\data\Weather_Lentekhi.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY vegetables(name, min_temp, vegetation_days)
FROM 'C:/Program Files/PostgreSQL/18/data/Vegetable_requirements.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

