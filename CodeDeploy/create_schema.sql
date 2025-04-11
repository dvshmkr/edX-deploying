
CREATE TABLE IF NOT EXISTS airport (
ident NVARCHAR(10),
type NVARCHAR(50),
name NVARCHAR(200),
latitude FLOAT,
longitude FLOAT,
elevation_ft FLOAT,
continent NVARCHAR(10),
iso_country NVARCHAR(10),
iso_region NVARCHAR(10),
municipality NVARCHAR(100),
gps_code NVARCHAR(10),
iata_code NVARCHAR(10),
local_code NVARCHAR(10)
);

CREATE TABLE IF NOT EXISTS route_miles (
route_csv NVARCHAR(100),
segment_count INT,
direct_miles INT,
total_miles INT
);

CREATE USER IF NOT EXISTS 'web_user'@'%' IDENTIFIED BY 'SED_REPLACE_PASS';

-- -- Grant USAGE privilege on the TEST-routes database
-- GRANT USAGE ON `TEST-routes`.* TO 'web_user'@'%';
-- -- Grant SELECT privileges on specific tables within TEST-routes
-- GRANT SELECT ON `TEST-routes`.airport TO 'web_user'@'%';
-- GRANT SELECT ON `TEST-routes`.route_miles TO 'web_user'@'%';

<<<<<<< HEAD
-- Grant USAGE privilege on the TEST-routes database
GRANT USAGE ON `FINAL-routes`.* TO 'web_user'@'%';
-- Grant SELECT privileges on specific tables within FINAL-routes
GRANT SELECT ON `FINAL-routes`.airport TO 'web_user'@'%';
GRANT SELECT ON `FINAL-routes`.route_miles TO 'web_user'@'%';
=======
-- -- Grant USAGE privilege on the TEST-routes database
-- GRANT USAGE ON `FINAL-routes`.* TO 'web_user'@'%';
-- -- Grant SELECT privileges on specific tables within FINAL-routes
-- GRANT SELECT ON `FINAL-routes`.airport TO 'web_user'@'%';
-- GRANT SELECT ON `FINAL-routes`.route_miles TO 'web_user'@'%';
>>>>>>> dev

SELECT "WORKED!" as INFO


-- -- Check if the TEST-routes database exists and grant privileges if it does
-- SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = 'TEST-routes';
-- IF FOUND_ROWS() > 0 THEN
--     CREATE USER IF NOT EXISTS 'web_user'@'%' IDENTIFIED BY 'SED_REPLACE_PASS';
--     GRANT USAGE ON `TEST-routes`.* TO 'web_user'@'%';
--     GRANT SELECT ON `TEST-routes`.airport TO 'web_user'@'%';
--     GRANT SELECT ON `TEST-routes`.route_miles TO 'web_user'@'%';
--     -- Optionally, you might want to revoke privileges on the other database if it exists
--     -- REVOKE ALL PRIVILEGES ON `FINAL-routes`.* FROM 'web_user'@'%';
-- END IF;

-- -- Check if the FINAL-routes database exists and grant privileges if it does
-- SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = 'FINAL-routes';
-- IF FOUND_ROWS() > 0 THEN
--     CREATE USER IF NOT EXISTS 'web_user'@'%' IDENTIFIED BY 'SED_REPLACE_PASS';
--     GRANT USAGE ON `FINAL-routes`.* TO 'web_user'@'%';
--     GRANT SELECT ON `FINAL-routes`.airport TO 'web_user'@'%';
--     GRANT SELECT ON `FINAL-routes`.route_miles TO 'web_user'@'%';
--     -- Optionally, you might want to revoke privileges on the other database if it exists
--     -- REVOKE ALL PRIVILEGES ON `TEST-routes`.* FROM 'web_user'@'%';
-- END IF;