CREATE TABLE sf_restaurant_scores(

business_id INT,
business_name VARCHAR,
business_address VARCHAR,
business_city VARCHAR,
business_state VARCHAR,
business_postal_code VARCHAR,
business_latitude NUMERIC,
business_longitude NUMERIC, 
business_location VARCHAR,
business_phone_number VARCHAR,
inspection_id VARCHAR,
inspection_date DATE,
inspection_score INT,
inspection_type VARCHAR,
violation_id VARCHAR,
violation_description VARCHAR,
risk_category VARCHAR
)


-- Review table

SELECT *
FROM sf_restaurant_scores

--- First and last inspection dates for vermin infestations per postal code

Select *
FROM sf_restaurant_scores
WHERE  violation_description ILIKE '%vermin%'

SELECT business_postal_code, MIN(inspection_date), MAX(inspection_date)
FROM sf_restaurant_scores
WHERE violation_description ILIKE '%vermin%'
GROUP BY business_postal_code

-- The lowest inspection score for each facility on Lombard Street
			 
SELECT UPPER(business_address),business_name, MIN(inspection_score) AS min_score
FROM sf_restaurant_scores
WHERE business_address ILIKE '%Lombard%'
GROUP BY business_name, business_address
ORDER BY min_score ASC


--- Compare lowest and highest inspection score from above. Count number of violations for each year 

SELECT COUNT(*) AS num_inspections,
EXTRACT ('YEAR' FROM inspection_date) AS year
FROM sf_restaurant_scores
WHERE business_name = 'Viva Goa Indian Cuisine'
AND  violation_id IS NOT NULL
GROUP BY year


SELECT COUNT(*) AS num_inspections,
EXTRACT ('YEAR' FROM inspection_date) AS year, violation_id
FROM sf_restaurant_scores
WHERE business_name = 'PRESIDIO GATE APARTMENTS'
AND violation_id IS NOT NULL
GROUP BY year,violation_id


--- Select the number of inspections for each risk category by inspection type


SELECT no_risk + high_risk + low_risk + mod_risk AS total_risk, inspection_type,
	   no_risk,low_risk,mod_risk,high_risk
FROM
(SELECT inspection_type,
SUM(CASE WHEN risk_category is NULL THEN cnt ELSE 0 END) AS no_risk,
SUM(CASE WHEN risk_category = 'High Risk' THEN cnt ELSE 0 END) AS high_risk,
SUM(CASE WHEN risk_category = 'Low Risk' THEN cnt ELSE 0 END) AS lOW_RISK,
SUM(CASE WHEN risk_category = 'Moderate Risk' THEN cnt ELSE 0 END) AS mod_risk

FROM
(SELECT COUNT(*) AS cnt, inspection_type, risk_category
FROM sf_restaurant_scores
GROUP BY inspection_type, risk_category) AS sub1
GROUP BY inspection_type) AS sub2
ORDER BY low_risk DESC, no_risk DESC, mod_risk DESC, high_risk DESC


