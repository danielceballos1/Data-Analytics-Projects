CREATE TABLE covid_deaths (

iso_code VARCHAR,	
continent VARCHAR,
location VARCHAR,
date DATE,
population	VARCHAR,
total_cases	VARCHAR,
new_cases VARCHAR,
new_cases_smoothed VARCHAR,
total_deaths VARCHAR,
new_deaths	VARCHAR

);

select count(*)
from covid_deaths



--first check to see the columns and data types
SELECT *
FROM covid_deaths

/*tabluea

total deaths, cases, and fatality percentage of world */

SELECT location,
MAX(CAST(total_deaths AS NUMERIC)) AS total_deaths,
MAX(CAST(total_cases AS NUMERIC)) AS total_cases,
MAX(CAST(total_deaths AS NUMERIC))/ MAX(CAST(total_cases AS NUMERIC))* 100 AS global_fatality_rate
FROM covid_deaths
WHERE location = 'World'
GROUP BY location 


-- total deaths and cases (number and percentage), and percentage dead per continent

WITH continent_cte AS (SELECT location, MAX(CAST(total_deaths AS NUMERIC)) AS deaths, 
MAX(CAST(total_cases AS NUMERIC)) AS cases
FROM covid_deaths
WHERE continent IS null
GROUP BY location
ORDER BY deaths)

SELECT location, deaths AS continent_deaths, cases AS continent_cases, deaths/cases*100 AS continent_death_percentage
FROM continent_cte
WHERE location IN ('Europe', 'Asia', 'Oceania', 'North America','South America', 'Africa')
ORDER BY continent_death_percentage DESC



-- total deaths and cases (number and percentage) per country 

SELECT location,
MAX(CAST(total_deaths AS NUMERIC)) as country_deaths,
MAX(CAST(total_cases AS NUMERIC)) as country_cases,
MAX(CAST(total_deaths AS NUMERIC))/ MAX(CAST(total_cases AS NUMERIC))* 100 AS fatality_percentage_rate
FROM covid_deaths
GROUP BY location 
ORDER BY fatality_percentage_rate DESC

-- use this for changing nulls to 0’s

WITH null_cte AS 
(SELECT location,
MAX(CAST(total_deaths AS NUMERIC)) AS country_deaths,
MAX(CAST(total_cases AS NUMERIC)) AS country_cases,
MAX(CAST(total_deaths AS NUMERIC))/ MAX(CAST(total_cases AS  NUMERIC))* 100 AS fatality_percentage_rate
FROM covid_deaths
GROUP BY location 
ORDER BY fatality_percentage_rate DESC)

SELECT location,
COALESCE(country_deaths, 0) AS country_deaths,
COALESCE(country_cases, 0)AS country_cases,
(CASE WHEN fatality_percentage_rate IS Null THEN 0 ELSE fatality_percentage_rate END)
FROM null_cte




--- Continent, location, population, country_deaths, country_cases, country COVId fatality percentage


WITH null_cte AS 
(SELECT continent, location,
CAST(population AS numeric),
MAX(CAST(total_deaths AS numeric)) AS country_deaths,
MAX(CAST(total_cases AS numeric)) AS country_cases,
MAX(CAST(total_deaths AS numeric))/ MAX(CAST(total_cases AS numeric))* 100 AS fatality_percentage_rate
FROM covid_deaths
WHERE continent is NOT NULL
GROUP BY continent, location, population
ORDER BY fatality_percentage_rate DESC)

SELECT continent, location,
COALESCE(population, 0) AS population,
COALESCE(country_deaths, 0) AS country_deaths,
COALESCE(country_cases, 0)AS country_cases,
(CASE WHEN fatality_percentage_rate IS Null THEN 0 ELSE fatality_percentage_rate END)
FROM null_cte
