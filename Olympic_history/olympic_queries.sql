CREATE TABLE athlete_events (
ID INT,
Name VARCHAR,
Sex VARCHAR,
Age VARCHAR,
Height VARCHAR,
Weight VARCHAR,
Team VARCHAR,
NOC VARCHAR,
Games VARCHAR,
Year INT,
Season VARCHAR,
City VARCHAR,
Sport VARCHAR,
Event VARCHAR,
Medal VARCHAR
)


CREATE TABLE noc_regions (
NOC VARCHAR,
region VARCHAR,
notes VARCHAR
)

-- Review data --

SELECT *
FROM  athlete_events

SELECT *
FROM noc_regions


--- Number of Olympic Games held since 2016


SELECT COUNT(DISTINCT(games))
FROM athlete_events

-- All Olypmic games held since 2016

SELECT DISTINCT(sport)
FROM athlete_events

--

/* 2 ways to find out which games have been played in all 'Summer Olympics'
 -first way using cte and RANK()
*/

WITH t1 AS (
	
SELECT COUNT(DISTINCT(games)) AS games_played, sport

FROM athlete_events
WHERE games ILIKE '%Summer'
GROUP BY sport), 

t2 AS (
	
SELECT sport, games_played, RANK() OVER (ORDER BY games_played DESC) AS rank_game
FROM t1
)

SELECT sport, games_played
FROM t2
WHERE rank_game = 1

-- second way using CTE and join
WITH t1 AS (

SELECT COUNT(DISTINCT(games)) AS games_played
FROM athlete_events
WHERE season = 'Summer'),
	
	t2 AS (
SELECT DISTINCT(sport), games
FROM athlete_events
WHERE season = 'Summer'
ORDER BY games),
	
	t3 AS (
SELECT sport, COUNT(games) AS games_played2
FROM t2
GROUP BY sport
	)
	
SELECT *
FROM t3
JOIN t1
ON t1.games_played=t3.games_played2


--- top athletes who have won most gold medals --

SELECT *
FROM athlete_events

WITH t1 AS(
SELECT name,team, sport, COUNT(medal) as gold_medals
FROM athlete_events
WHERE medal = 'Gold'
GROUP BY name, team, sport
ORDER BY gold_medals DESC),

t2 AS (
SELECT *, DENSE_RANK () OVER (ORDER BY gold_medals DESC) AS top_five
FROM t1)

select *
FROM t2
WHERE top_five <= 5



--- count medals per each country

SELECT *
FROM athlete_events

SELECT *
FROM athlete_events AS a
join noc_regions AS b
ON a.noc = b.noc


SELECT country,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS gold,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS silver,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS bronze	 
FROM
(SELECT region AS country, medal
FROM athlete_events AS a
JOIN noc_regions AS b
ON a.noc = b.noc) AS new
WHERE medal != 'NA'
GROUP BY country
ORDER BY gold DESC