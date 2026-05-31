/*
Problem Overview
The combination of gender and day serves as the primary key.

Goal: Write an SQL query to find the running total of scores for each gender on each day. 
The final result should be ordered by gender and day in ascending order.


*/
USE `leetcode_medium`;


CREATE TABLE Scores (
    player_name VARCHAR(50),
    gender VARCHAR(1),
    day DATE,
    score_points INT,
    -- Defining the primary key as the combination of gender and day
    PRIMARY KEY (gender, day)
);

INSERT INTO Scores (player_name, gender, day, score_points) VALUES
-- Female Player Data
('Aron', 'F', '2020-12-30', 17),
('Alice', 'F', '2020-12-31', 23),
('Bajrang', 'F', '2021-01-07', 7),

-- Male Player Data
('Chaitanya', 'M', '2020-12-30', 15),
('Draft', 'M', '2020-12-31', 3),
('Geronimo', 'M', '2021-01-01', 3),
('Khali', 'M', '2021-01-07', 11),
('Sayan', 'M', '2021-01-09', 2);



SELECT player_name, gender , day ,
SUM(score_points)OVER(PARTITION BY gender ORDER BY day  ) AS total_score
FROM Scores
ORDER BY gender, day;