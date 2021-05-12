/* Questions */
USE mydb;

-- 1. Who was the main actors in the most gross movie of 2019??
SELECT actors AS 'Actor Name', CONCAT('$', FORMAT(grossIncome, 2)) AS "Gross Income"
FROM general_information g
	JOIN box_office b
		ON g.boxOfficeID = b.boxOfficeID
	JOIN actors_link al
		ON g.movieID = al.movieID
	JOIN actors_list a
		ON al.actorID = a.actorID
WHERE grossIncome = 
(
	SELECT MAX(grossINCOME)
	FROM box_office
);

-- 2. What are the top movies in the US for 2019 based on metascore?
SELECT movieTitle AS "Movie Title", metascore AS "Metascore"
FROM general_information g JOIN feedback f
		ON g.feedbackID = f.feedbackID
WHERE metascore = 
(
	SELECT MAX(metascore)
	FROM feedback
);

-- 3. What is the most watched genre
SELECT COUNT(genre) AS 'Number of Appearances', genre AS "Genre"
FROM general_information
GROUP BY genre
LIMIT 1;

-- 4. Which movie got the best reviews from users?
SELECT movieTitle AS "Movie Title", userReviews AS 'Reviews From User'
FROM general_information g JOIN feedback f
		ON g.feedbackID = f.feedbackID
WHERE userReviews = 
(
	SELECT MAX(userReviews)
	FROM feedback
);

-- 5. Which movie got the best reviews from critics?
SELECT movieTitle AS "Movie Title", criticReviews AS 'Reviews From Critics'
FROM general_information g JOIN feedback f
		ON g.feedbackID = f.feedbackID
WHERE criticReviews = 
(
	SELECT MAX(criticReviews)
	FROM feedback
);

-- 6. Which movie got the highest average vote?
SELECT movieTitle AS "Movie Title", avg_votes AS "Average Votes"
FROM general_information g JOIN feedback f
		ON g.feedbackID = f.feedbackID
WHERE avg_votes =
(
	SELECT MAX(avg_votes)
    FROM feedback
);

-- 7. Which movie got the lowest average vote?
SELECT movieTitle AS "Movie Title", avg_votes AS "Average Titles"
FROM general_information g JOIN feedback f
		ON g.feedbackID = f.feedbackID
WHERE avg_votes =
(
	SELECT MIN(avg_votes)
    FROM feedback
);

-- 8. Which movie has the longest duration?
SELECT movieTitle AS "Movie Title", duration AS "Duration"
FROM general_information
WHERE duration =
(
	SELECT MAX(duration)
    FROM general_information
);

-- 9. Which movie has the shortest duration?
SELECT movieTitle AS "Movie Title", duration AS "Duration"
FROM general_information
WHERE duration =
(
	SELECT MIN(duration)
    FROM general_information
);

-- 10. When was the USA grossest movie of July 2019 released into theaters?
SELECT movieTitle AS 'Movie Name', CONCAT('$', FORMAT(grossIncome, 2)) AS "Gross Income"
FROM general_information g JOIN box_office b
		ON g.boxOfficeID = b.boxOfficeID
WHERE grossIncome = 
(
	SELECT MAX(grossINCOME)
	FROM box_office
);

-- 11. How many movies had a average vote of 5 or higher?
SELECT movieTitle AS 'Movie Name', avg_votes AS 'Average Votes'
FROM general_information g JOIN feedback f
	ON g.feedbackID = f.feedbackID
WHERE avg_votes > 5
ORDER BY avg_votes DESC;



-- Views

-- 12. What were all the movies released in the summer?
CREATE OR REPLACE VIEW movies_summer AS 
	SELECT g.movieID AS "Movie ID", movieTitle AS "Movie Title", datePublished AS "Date Published", genre AS "Genre", actors AS "Actors", CONCAT('$', FORMAT(grossIncome, 2)) AS "Gross Income", budget AS "Budget"
		, directors AS "Directors", metascore AS "Metascore", avg_votes AS "Average Votes", votes AS "Votes", userReviews AS "User Reviews", criticReviews AS "Critic Reviews", duration AS "Duration",
        productionName AS "Production Name", writers AS "Writers"
    FROM general_information g
		JOIN actors_link al
			ON g.movieID = al.movieID
		JOIN actors_list a
			ON al.actorID = a.actorID
		JOIN box_office b
			ON g.boxOfficeID = b.boxOfficeID
		JOIN directors_list d
			ON g.directorID = d.directorID
		JOIN feedback f
			ON g.feedbackID = f.feedbackID
		JOIN production_company p
			ON g.productionID = p.productionID
		JOIN writers_list w
			ON g.writerID = w.writerID
    WHERE g.datePublished > "2019-06-01" AND g.datePublished < "2019-09-22"
    ORDER BY movieID;
    
-- 13. What movies had the worst reviews below 5 and 50%?
CREATE OR REPLACE VIEW bad_reviews AS 
	SELECT movieTitle AS 'Movie Name', avg_votes AS 'Average Votes', metascore AS "Metascore"
    FROM general_information g
		JOIN feedback USING(feedbackID)
	WHERE avg_votes < 5 AND metascore < 50
    ORDER BY avg_votes DESC;
    
-- 14. What were the most liked movies over 2 hours?
CREATE OR REPLACE VIEW most_liked_long_movies AS 
	SELECT movieTitle AS 'Movie Name', duration AS "Duration", avg_votes AS 'Average Votes'
    FROM general_information
		JOIN feedback USING(feedbackID)
    WHERE duration > 120 AND avg_votes > 8
    ORDER BY avg_votes DESC;
    
-- 15. What was the most profitable movie for every production company?
CREATE OR REPLACE VIEW top_production_company AS
	SELECT g.movieTitle AS "Movie Title", p.productionName AS "Production Company", CONCAT('$', FORMAT(b.grossIncome, 2)) AS "Gross Income"
    FROM production_company p
		JOIN general_information g USING (productionID)
        JOIN box_office b USING (boxOfficeID)
    GROUP BY productionName
    ORDER BY grossIncome desc;
    
-- 16. What was the best rated movie every month in 2019?
CREATE OR REPLACE VIEW best_movie_every_month AS 
	SELECT movieTitle AS "Movie Title", DATE_FORMAT(datePublished, '%M') AS "Date Released", MAX(metascore) AS "metascore", MAX(userReviews) AS "User Reviews", MAX(criticReviews) AS "Critic Reviews"
    FROM general_information
		JOIN feedback USING (feedbackID)
	WHERE datePublished IN
    (
		SELECT datePublished
        FROM general_information
        WHERE datePublished > "2019-01-01" AND datePublished < "2019-12-31"
    )
	GROUP BY month(datePublished)
	ORDER BY month(datePublished);

    

    

    