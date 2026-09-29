CREATE TABLE climate_data (
    year INTEGER,
    month INTEGER,
    pet NUMERIC(5,2),
    ppt NUMERIC(5,2),
    srad NUMERIC(5,2),
    tmax NUMERIC(4,2),
    tmin NUMERIC(4,2),
    vap NUMERIC(4,2),
    vpd NUMERIC(4,2),
    ws NUMERIC(4,2),
    PRIMARY KEY (year, month)
);

CREATE TABLE vegetables (
    name VARCHAR(50) PRIMARY KEY,
    min_temp NUMERIC(4,2),
    vegetation_days INTEGER
);
