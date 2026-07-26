-- ==========================================
-- HR DATA CLEANING
-- ==========================================

USE projects;

-- ==========================================
-- Rename ID column
-- ==========================================

ALTER TABLE hr
CHANGE COLUMN `ï»¿id` emp_id VARCHAR(20);

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- ==========================================
-- Clean birthdate
-- ==========================================

UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%'
        THEN STR_TO_DATE(birthdate, '%m/%d/%Y')
    WHEN birthdate LIKE '%-%'
        THEN STR_TO_DATE(birthdate, '%m-%d-%Y')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

-- ==========================================
-- Clean hire_date
-- ==========================================

UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%'
        THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date LIKE '%-%'
        THEN STR_TO_DATE(hire_date, '%m-%d-%Y')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- ==========================================
-- Clean termdate
-- ==========================================

UPDATE hr
SET termdate = STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> '';

UPDATE hr
SET termdate = NULL
WHERE TRIM(termdate) = '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- ==========================================
-- Add age column
-- ==========================================

ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());