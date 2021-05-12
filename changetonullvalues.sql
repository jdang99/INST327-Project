USE mydb;
SET sql_safe_updates = FALSE;

-- box_office table
UPDATE box_office
SET grossincome = NULL
WHERE grossincome = 0;

UPDATE box_office
SET budget = NULL 
WHERE budget = 0;

-- feedback table
UPDATE feedback
SET metascore = NULL
WHERE metascore = 0;

UPDATE feedback
SET avg_votes = NULL
WHERE avg_votes = 0;

UPDATE feedback
SET votes = NULL
WHERE votes = 0;

UPDATE feedback
SET userReviews = NULL
WHERE userReviews = 0;

UPDATE feedback
SET criticReviews = NULL
WHERE criticReviews = 0;

-- general information
UPDATE general_information
SET duration = NULL
WHERE duration = 0;

-- delete extra/mistake rows
set sql_safe_updates = false;

DELETE FROM mydb.production_company
WHERE directorID = 8;