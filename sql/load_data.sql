COPY climate_data
FROM 'C:\Program Files\PostgreSQL\18\data\Weather_Lentekhi.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

