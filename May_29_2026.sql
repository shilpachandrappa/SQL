/*

1. Players TableEach row contains the unique ID and the name of a tennis player.
Column Name Type 
player_id   int 
player_name varchar


Conversation with Gemini
Leetcode 1783 question

Here is a complete breakdown and solution for LeetCode 1783: Grand Slam Titles (a great data modeling and aggregation problem often asked in data engineering interviews).

The Problem Summary
You are given two tables: Players and Championships.

1. Players Table
Each row contains the unique ID and the name of a tennis player.
Column Name	Type
player_id	int
player_name	varchar

2. Championships Table
Each row represents the winners of the four Grand Slam tournaments for a specific year.

Column Name	Type
year	int
Wimbledon	int
Fr_open	int
US_open	int
Au_open	int

Objective

1. Write an SQL query to report the number of grand slam tournaments won by each player.

2. Do not include players who haven't won any tournaments.

3. Return the result table in any order.

RESULT
player_id	player_name	grand_slams_count
1	Nadal	4
2	Federer	3
3	Djokovic	1


*/

USE `leetcode_medium`;

-- Create the Players table
CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50) NOT NULL
);

-- Create the Championships table
CREATE TABLE Championships (
    year INT PRIMARY KEY,
    Wimbledon INT,
    Fr_open INT,
    US_open INT,
    Au_open INT
);

-- Insert values into the Players table
INSERT INTO Players (player_id, player_name) VALUES
(1, 'Nadal'),
(2, 'Federer'),
(3, 'Djokovic'),
(4, 'Murray'); -- This player won 0 titles to test our filtering

-- Insert values into the Championships table
INSERT INTO Championships (year, Wimbledon, Fr_open, US_open, Au_open) VALUES
(2018, 1, 1, 1, 2),
(2019, 1, 2, 2, 3);



WITH CTE AS (
SELECT Wimbledon as winner FROM Championships
UNION ALL
SELECT Fr_open as winner FROM Championships
UNION ALL
SELECT US_open as winner FROM Championships
UNION ALL
SELECT Au_open as winner FROM Championships
)
SELECT p.player_id, p.player_name, SUM(c.winner) as grand_slams_count
FROM  Players p 
JOIN CTE c ON c.winner = p.player_id
GROUP BY c.winner;

/*
Option 1: The UNION ALL Approach (Recommended for Clean Data Modeling)
By normalizing the wide Championships table into a long format using UNION ALL, we can treat all tournaments equally. 
This makes the final aggregation trivial and highly maintainable if more tournaments are added later.

Why this works well:
UNION ALL grabs every single winning instance across all four columns, 
preserving duplicates (which is what we want, since a player can win multiple titles in a year).

INNER JOIN automatically filters out any players who have a total count of 0, 
fulfilling the requirement to exclude non-winners.


*/


WITH CTE AS (
SELECT Wimbledon as winner FROM Championships
UNION ALL
SELECT Fr_open as winner FROM Championships
UNION ALL
SELECT US_open as winner FROM Championships
UNION ALL
SELECT Au_open as winner FROM Championships 
)

SELECT p.player_id, p.player_name, SUM(winner) as grand_slams_count FROM Players p
JOIN CTE c ON p.player_id =  c.winner
GROUP BY winner;


SELECT p.player_id, p.player_name , 
SUM(p.player_id = c.wimbledon) + SUM(p.player_id = c.Fr_open) + SUM(p.player_id = c.US_open) + SUM(p.player_id = c.Au_open) as grand_slams_count
FROM Players p
JOIN Championships c ON p.player_id IN (c.Wimbledon, c.Fr_open, c.US_open, c.Au_open)
GROUP BY p.player_id , p.player_name