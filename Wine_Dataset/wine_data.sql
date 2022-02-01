CREATE TABLE wine (

	ID VARCHAR,
	country VARCHAR,
	description VARCHAR,
	designation VARCHAR,
	points INT,
	price INT,
	province VARCHAR,
	region_1 VARCHAR,
	region_2 VARCHAR,
	variety VARCHAR,
	winery VARCHAR

)



/* For tableau - divide wines from the "US" into the following categories:
fruity/savory, dry/sweet, light/full, smooth/spicy

Return designation, winery, country, region_1, region_2, price, points, and description

*/

	
SELECT DISTINCT designation AS Brand,  winery, country, region_1, region_2, price, points,
	   CASE WHEN
		        description ILIKE '%fruit-Driven%' OR
		        description ILIKE '%Sweet Attack%' OR
		        description ILIKE '%Jammy%' OR
		        description ILIKE '%Extracted%' OR
		        description ILIKE '%Flamboyant%' OR
		        description ILIKE '%Sweet Tannin%' OR
		        description ILIKE '%New World Style%' OR
		        description ILIKE '%Juicy%' OR
		        description ILIKE '%Ripe%'  THEN 'fruity' END AS wine_description,
		CASE WHEN 
				description ILIKE '%Herbaceous%' OR
		        description ILIKE '%Earthy%' OR
		        description ILIKE '%Rustic%' OR
		        description ILIKE '%Food Friendly%' OR
		        description ILIKE '%Old World Style%' OR
		        description ILIKE '%Bone Dry%' OR
		        description ILIKE '%Elegant%' OR
		        description ILIKE '%Closed%' OR
				description ILIKE '%Stalky%' OR
		        description ILIKE '%Stemmy%' OR
		        description ILIKE '%High Minerality%' OR
		        description ILIKE '%Vegetal%'  THEN 'savory' END AS wine_description,
		CASE WHEN 
				description ILIKE '%dry%' THEN 'dry'  END AS wine_description,
		CASE WHEN 
				description ILIKE '%sweet%' THEN 'sweet'  END AS wine_description,
		CASE WHEN 
				description ILIKE '% light%' THEN 'light'  END AS wine_description,
		CASE WHEN 
				description ILIKE '%full %' OR
				description ILIKE '%bitter%' THEN 'full' END AS wine_description,
		 CASE WHEN
		        description ILIKE '%smooth%' OR
		        description ILIKE '%Plush%' OR
		        description ILIKE '%Round%' OR
		        description ILIKE '%Velvety%' OR
		        description ILIKE '%Supple%' OR
		        description ILIKE '%Opulent%' OR
		        description ILIKE '%Voluptuous%' OR
		        description ILIKE '%Creamy%' OR
		        description ILIKE '%Buttery%' OR
				description ILIKE '%Lush%' OR
		        description ILIKE '%Soft%' OR
		        description ILIKE '%Silky%' OR
		        description ILIKE '%Spineless%' OR
		        description ILIKE '%Flabby%' THEN 'smooth'  END AS wine_description,
		 CASE WHEN
		        description ILIKE '%spicy%' OR
		        description ILIKE '%juicy%' OR
		        description ILIKE '%sharp%' OR
		        description ILIKE '%Balsamic%' OR
		        description ILIKE '%peppery%' OR
		        description ILIKE '%lean%' OR
		        description ILIKE '%Austere%' OR
		        description ILIKE '%Edgy%' OR
		        description ILIKE '%lively%' THEN 'spicy'  END AS wine_description,
				description
FROM(
SELECT  description, designation, country, region_1, region_2, winery, price, points
FROM wine) as s
WHERE designation IS NOT null
AND country IS NOT null
AND price IS NOT null
AND country = 'US'
GROUP BY designation, description, country, region_1, region_2, winery, price, points
ORDER BY winery


--Select country with the highest scores
SELECT
	country,
	best_score
FROM
(SELECT
	MAX(points) AS best_score,
 	country,
 	DENSE_RANK() OVER (ORDER BY MAX(points) DESC) AS score
FROM wine
GROUP BY country
ORDER BY best_score DESC) AS sub1
WHERE score = 1


-- find the points,price,province,winery, and country of the most expesive wine 
SELECT
	points,
	price,
	province,
	winery,
	country
FROM wine
WHERE price =
(SELECT MAX(price) AS max_price
FROM wine)

-- count the number of bold, fruit, earthy, and light wines 

SELECT
	COUNT(CASE WHEN description ILIKE '%bold%' THEN 1 END) AS bold,
	COUNT(CASE WHEN description ILIKE '%fruity%' THEN 1 END) AS fruity,
	COUNT(CASE WHEN description ILIKE '%earthy%' THEN 1 END) AS earthy,
	COUNT(CASE WHEN description ILIKE '%light%' THEN 1 END) AS light
FROM wine


/*  Find the top 10 wines in  the Rioja, Spain region (not Argentina) that cost less than 100 dollars. 
	Return the designation, winery, region, points, and price.

*/
		
SELECT
	DISTINCT designation,
	winery,
	country,
	region_1,
	points,
	price
FROM(	
SELECT
	description,
	winery,
	country,
	designation,
	region_1,
	points,
	price,
	RANK() OVER (ORDER BY points DESC) AS top_10
FROM wine
WHERE country = 'Spain'
AND region_1 = 'Rioja'
AND price < 100 ) AS sub1
	WHERE top_10 <= 20
	ORDER BY points DESC
	LIMIT 10


-- Count the number of distinct designations. Group by year in descending order. Limit to the top 10.
SELECT
	COUNT(DISTINCT designation) AS num_designations,
	country
FROM wine
GROUP BY country
ORDER BY num_designations DESC
LIMIT 10


-- Find wines that are classifed as light, fruity but not oakey. Also, the wines should not be in France.

SELECT DISTINCT *
FROM wine
WHERE description ILIKE '%light%' 
AND description ILIKE '%fruity%'
AND description NOT ILIKE '%oak%'
AND country != 'France'


-- Count the number of wine varieties 
SELECT  variety , COUNT(variety) AS num_variety
FROM wine
GROUP BY variety
ORDER BY num_variety DESC



/*  Find the total revenue made by each region from each variety of wine in that region.
	Return total revenue, the region, and variety.*/
	
SELECT
	SUM(price) total_revenue,
	region,
	variety
FROM
(SELECT
 	price,
 	region_1 AS region,
 	variety
FROM wine
UNION 
SELECT
 	price,
	region_2 AS region,
 	variety
FROM wine) AS b
WHERE region IS NOT null 
GROUP BY region, variety
HAVING SUM(price) IS NOT null
ORDER BY total_revenue DESC

 /* Find the cheapest wine in each country.
 	Retrun the country, price, and designation where designation is not null.
	
	1st way
	
 */
 

SELECT
	country,
	price,
	designation,
	rank_price
FROM
(SELECT
 	country,
 	price,
 	designation,
 	DENSE_RANK() OVER (PARTITION BY country ORDER BY MIN(price)) AS rank_price
FROM wine
GROUP BY country, designation, price) AS sub1
WHERE rank_price = 1
AND designation IS NOT null
AND price IS NOT null
ORDER BY price ASC


-- second way


WITH cheapest_wine AS(
SELECT
 	country,
 	price,
 	designation,
 	RANK() OVER (PARTITION BY country ORDER BY MIN(price) ASC) AS rank_price
FROM wine
WHERE price IS NOT null
GROUP BY country, price, designation)


SELECT 
	country,
	price,
	rank_price,
	designation
FROM cheapest_wine
WHERE rank_price = 1
AND price IS NOT null
AND designation IS NOT null
ORDER BY price ASC



/*  Find the Find the most expensive wine in each country.
 	Return the country and  price.
	
 */
 
WITH most_expensive AS(
SELECT
 	country,
 	price,	
 	RANK() OVER (PARTITION BY country ORDER BY MAX(price) DESC) AS rank_price
FROM wine
WHERE price IS NOT null
GROUP BY country, price)


SELECT
	country,
	price,
	rank_price
FROM most_expensive
WHERE rank_price = 1
ORDER BY price DESC



-- Return the number of light, med, full wines




SELECT
	COUNT(CASE WHEN description ilike '%light%' THEN 1 END) AS light,
	COUNT(CASE WHEN description ilike '%medium%' THEN 1 END) AS medium,
	COUNT(CASE WHEN description ilike '%full%' THEN 1 END) AS full
FROM(
SELECT distinct description
FROM wine) as s
	


-- Return the number of wines varieties in Spain

SELECT DISTINCT variety , num_variety
FROM(
SELECT variety , COUNT(variety) AS num_variety
FROM wine
WHERE country = 'Spain'
GROUP BY variety
ORDER BY num_variety DESC) AS b
ORDER BY num_variety DESC






-- Top 5 most expensive wines with rank above 90


WITH most_expensive AS(
SELECT
 	country,
 	price,	
 	RANK() OVER (PARTITION BY country ORDER BY MAX(price) DESC) AS rank_price,
	points,
	designation
FROM wine
WHERE price IS NOT null
AND points > 90
GROUP BY country, price, points, designation)


SELECT
	country,
	price,
	rank_price,
	points,
	designation
FROM most_expensive
WHERE rank_price = 1
ORDER BY price DESC
LIMIT 5

-- Top 5 wines cheapest wines with a rank above 90


WITH cheapest_wine AS(
SELECT
 	country,
 	price,
 	designation,
 	RANK() OVER (PARTITION BY country ORDER BY MIN(price) ASC) AS rank_price,
	points
FROM wine
WHERE price IS NOT null
AND points >= 90
GROUP BY country, price, designation, points)


SELECT 
	country,
	price,
	rank_price,
	designation,
	points
FROM cheapest_wine
WHERE rank_price = 1
AND price IS NOT null
AND designation IS NOT null
ORDER BY price ASC
LIMIT 5

