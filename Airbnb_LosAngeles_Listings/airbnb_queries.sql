CREATE TABLE airbnb_listing_details (
ID INT,
Host_Name VARCHAR,
Host_Since DATE,
Host_Response_Rate INT,
Neighbourhood VARCHAR,
City VARCHAR,
State VARCHAR,
Zipcode VARCHAR,
Country VARCHAR,
Property_Type VARCHAR,
Room_Type VARCHAR,
Accommodates INT,
Bathrooms NUMERIC,
Bedrooms INT,
Beds INT,
Bed_Type VARCHAR,
Amenities VARCHAR,
Price NUMERIC,
Cleaning_Fee NUMERIC,
Guests_Included INT,
Minimum_Nights INT,
Maximum_Nights INT,
Number_of_Reviews INT,
Review_Scores_Rating INT,
Cancellation_Policy VARCHAR
)

-- review table

SELECT * 
FROM airbnb_listing_details 


-- cheapest neighbourhood to find a Villa 
WITH cheapest_cte AS
(
SELECT neighbourhood, MIN(price) AS cheapest_price,
RANK () OVER (ORDER BY price ASC) 
FROM airbnb_listing_details
WHERE property_type ILIKE 'Villa'
GROUP BY  neighbourhood, price
)

SELECT neighbourhood
FROM cheapest_cte
WHERE RANK = 1

-- average number of bathrooms and bedrooms for each property type 

SELECT property_type,
ROUND(AVG(bathrooms),2) AS avg_num_bathrooms, ROUND(AVG(bedrooms),2) avg_num_bedrooms
FROM airbnb_listing_details 
GROUP BY property_type

-- number of apartments in West Hollywood
SELECT neighbourhood, COUNT(property_type) AS num_apartments
FROM airbnb_listing_details 
WHERE neighbourhood = 'West Hollywood'
AND property_type = 'Apartment'
GROUP BY neighbourhood

-- Number of house searches in the Inglewood neighbourhood area have a TV as an amenity


SELECT COUNT(DISTINCT ID)
FROM airbnb_listing_details
WHERE neighbourhood = 'Inglewood'
AND amenities ILIKE '%TV%'
AND property_type = 'House'


/* neighborhoods where you can sleep on a real bed in a loft with internet while paying
the lowest price possible 
*/

SELECT neighbourhood, MIN(price) AS cheapest_price, 
RANK () OVER (ORDER BY price ASC)
FROM airbnb_listing_details 
WHERE amenities ILIKE '%fire extinguisher%'
AND bed_type = 'Real Bed'
AND property_type ILIKE 'loft'
GROUP BY neighbourhood, price
ORDER BY cheapest_price ASC



-- Number of searches for each room type in Los Angeles

SELECT city,
COUNT(CASE WHEN room_type ilike '%apt%' then 1 END AS apt,
COUNT(CASE WHEN room_type ilike '%pri%' then 1 END) AS private,
COUNT(CASE WHEN room_type ilike '%shar%' then 1 END) AS share
FROM airbnb_listing_details
GROUP BY 1
	  
/*  all listings in the Hollywood neighbourhood with a review score rating
	and where the cancellation policy is flexible
*/	 
	  
SELECT  *
FROM airbnb_listing_details
WHERE neighbourhood = 'Hollywood'
AND cancellation_policy = 'flexible'
AND review_scores_rating IS NOT NULL
ORDER BY review_scores_rating DESC


	  