create database Ankit_Bansal_SQL;
use Ankit_Bansal_SQL;

create table entries(
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(20)
);

insert into entries values
('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR');

/* ===============================================================================
Problem statement -
An employee has access only to enter once in a day to a floor there are multiple floor , 
the access is given using an email id 

To find - 
Loophole -people are giving different id to visit multiple times to different floor
Find total no of visits each person does (total_visits)
Find the most visited floor 
Find the resources used

PROBLEM ANALYSIS:
1. One row per visit exists in the 'entries' table.
2. We need to "Collapse" these rows so each person appears only once.
3. Challenges: 
   - 'total_visits' is a simple count.
   - 'resources_used' needs to be a list, but we must avoid duplicates.
   - 'most_visited_floor' requires comparing counts across different floors for 
     the same person.
===============================================================================
*/

/* Step 1: Get unique combinations of names and resources.
This prevents the same resource from appearing multiple times in the final list 
if a user accessed it during different visits.
*/
WITH distinct_resources AS (
    SELECT DISTINCT name, resources 
    FROM entries
), 

/* Step 2: Group the unique resources into a single comma-separated string per person.
MySQL's GROUP_CONCAT is used here to merge those distinct rows.
*/
agg_resources AS (
    SELECT 
        name, 
        GROUP_CONCAT(resources SEPARATOR ',') AS used_resources 
    FROM distinct_resources 
    GROUP BY name
),

/* Step 3: Calculate the total number of entries (visits) for each person.
We keep this separate to get the actual count of all visits.
*/
total_visites AS (
     SELECT 
          name, 
          COUNT(1) AS total_visits
     FROM entries 
     GROUP BY name
),

/* Step 4: Determine which floor each person visited most often.
We use RANK() to assign #1 to the floor with the highest COUNT(1).
*/
floor_visits AS (
     SELECT 
          name, 
          floor, 
          COUNT(1) AS no_of_floor_visit,
          RANK() OVER(PARTITION BY name ORDER BY COUNT(1) DESC) AS rn
     FROM entries
     GROUP BY name, floor
)

/* Final Step: Combine everything.
We join the floor ranking, the total visit count, and the distinct resource list.
*/
SELECT 
     fv.name, 
     fv.floor AS most_visited_floor,
     tv.total_visits ,
     ar.used_resources
FROM floor_visits fv 
INNER JOIN total_visites tv ON fv.name = tv.name
INNER JOIN agg_resources ar ON fv.name = ar.name
WHERE fv.rn = 1;