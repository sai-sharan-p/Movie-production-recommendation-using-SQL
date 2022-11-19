USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

--  A faster method using schema def.

SELECT
	TABLE_NAME AS 'TABLE NAME', 
    TABLE_ROWS AS 'NUMBER OF ROWS'
FROM 
	INFORMATION_SCHEMA.TABLES
WHERE 
	TABLE_SCHEMA = 'IMDB';

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- We can solve this using case statements. The code is below. 

-- Query to count the number of nulls in each column using case statements
SELECT
		Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
             END) 
           AS id_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
			 END) 
           AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
             END) 
           AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
             END)
           AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
             END) 
           AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
             END) 
           AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
             END) 
           AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
             END) 
           AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
             END) 
           AS production_company_NULL_COUNT
FROM  
			movie; 
            
-- Country, worlwide_gross_income, languages and production_company columns have NULL values


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- total number of movies released each year. 

SELECT 
	year, 
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY 
	year;
-- Year 2017 has move number of movies when campared with 2018 & 2019. 


-- the month wise trend.

SELECT 
	MONTH(date_published) AS month_num,
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY 
	MONTH(date_published)
ORDER BY 
	MONTH(date_published);

/*The highest number of movies is produced in the month of March.


So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Pattern matching using LIKE operator for country column

SELECT 
	Count(DISTINCT id) AS number_of_movies, 
    year
FROM   
	movie
WHERE  
	( country LIKE '%INDIA%'
OR 
country LIKE '%USA%' )
AND 
year = 2019; 

-- The number of movies produced in USA or India are 1059 in 2019. 


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- Finding unique genres using DISTINCT keyword
SELECT 
	DISTINCT genre
FROM 
	genre;

-- Movies belong to 13 genres in the dataset.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Using LIMIT clause to display only the genre with highest number of movies produced
SELECT 
	COUNT(movie_id), 
    genre
FROM 
	genre
GROUP BY
	genre
ORDER BY
	COUNT(movie_id) desc
limit 1;

-- 4265 Drama movies were produced in total and are the highest among all genres.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie belongs to
-- Using the result of CTE, we find the count of movies which belong to only one genre


WITH movies_with_one_genre
     AS (
     SELECT 
		movie_id
	 FROM   
		genre
	GROUP  BY 
		movie_id
		HAVING 
			COUNT(DISTINCT genre) = 1)
SELECT 
	COUNT(*) AS movies_with_one_genre
FROM   
	movies_with_one_genre; 

-- 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Finding the average duration of movies by grouping the genres that movies belong to 

SELECT 
	g.genre, 
    SUM(m.duration)/COUNT(m.duration) as avg_duration
FROM
	genre g INNER JOIN movie m
	ON g.movie_id=m.id
GROUP BY
	genre
ORDER BY
	SUM(m.duration)/COUNT(m.duration) DESC;
    
-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.
    
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Using aggregation of movies and rank function, gives the desired output. 

SELECT 
	genre, 
    COUNT(movie_id) as movie_count,
	RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM
	genre
GROUP BY
	genre; 
    
    -- Thriller has rank=3 and movie count of 1484


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- We can do this by using min & max. The code is below.
SELECT 
	MIN(avg_rating) AS min_avg_rating, 
	MAX(avg_rating) AS max_avg_rating, 
	MIN(total_votes) AS min_total_votes, 
	MAX(total_votes) AS max_total_votes, 
	MIN(median_rating) AS min_median_rating, 
    MAX(median_rating) AS max_median_rating
FROM
	ratings;
    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies using LIMIT clause
SELECT
	title, 
	avg_rating, 
	RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM
	movie m INNER JOIN ratings r 
ON 
	m.id=r.movie_id
    LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Finding the number of movies vased on median rating and sorting based on movie count.
SELECT 
	median_rating, 
    COUNT(movie_id) AS movie_count
FROM 
	ratings
GROUP BY
	median_rating
ORDER BY 
	median_rating, 
	COUNT(movie_id);

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- CTE: Finding the rank of production company based on movie count with average rating > 8 using RANK function.
-- Querying the CTE to find the production company with rank=1
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                     AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query to find 
-- 1. Number of movies released in each genre 
-- 2. During March 2017 
-- 3. In the USA  (LIKE operator is used for pattern matching)
-- 4. Movies had more than 1,000 votes

SELECT
	g.genre, 
    COUNT(g.movie_id) as movie_count
FROM
	genre g 
INNER JOIN 
	movie m
ON g.movie_id=m.id
INNER JOIN 
	ratings r
ON r.movie_id=g.movie_id
WHERE 
	m.year=2017 
AND
	r.total_votes > 1000
AND 
	Month(date_published) = 3
AND 
	country LIKE '%USA%'
GROUP BY 
	g.genre
ORDER BY 
	COUNT(g.movie_id) 
DESC;

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’ (LIKE operator is used for pattern matching)
-- 2. Which have an average rating > 8?

SELECT 
	m.title, 
    r.avg_rating, 
    g.genre
FROM 
	genre g 
INNER JOIN 
	movie m
ON g.movie_id=m.id
INNER JOIN
	ratings r
ON r.movie_id=g.movie_id
WHERE 
	m.title like 'The%' 
AND 
	r.avg_rating > 8
ORDER BY 
		m.title,
        r.avg_rating DESC;

-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- All the movies belong to the top 3 genres.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019
SELECT 
	COUNT(m.id) AS movie_count
FROM 
	movie m 
INNER JOIN
	ratings r
ON r.movie_id=m.id
WHERE 
	r.median_rating= 8 
AND 
	m.date_published 
    BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY
	median_rating;

-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Two approaches - one is search based on language and the other by country column
-- The below code is using the country column. 

SELECT 
	m.country, 
	SUM(r.total_votes) as total_no_of_votes
FROM 
	movie m 
INNER JOIN
	ratings r 
ON m.id=r.movie_id
WHERE 
	m.country = 'Italy' 
OR 
	m.country= 'Germany'
GROUP BY 
	m.country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE 
    WHEN name IS NULL THEN 1 
    ELSE 0
    END) AS name_nulls,
    SUM(CASE 
    WHEN height IS NULL THEN 1 
    ELSE 0
    END) AS height_nulls,
    SUM(CASE 
    WHEN date_of_birth IS NULL THEN 1 
    ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE 
    WHEN known_for_movies IS NULL THEN 1 
    ELSE 0
    END) AS known_for_movies_nulls
FROM
	names ;
    
    -- Height, date_of_birth, known_for_movies columns contain NULLS

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- CTE: Computes the top 3 genres using average rating > 8 condition and highest movie counts
-- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  
WITH cte_top_genre AS
(
	SELECT 
		g.genre, 
        COUNT(g.movie_id) AS movie_count
	FROM 
		genre g 
	INNER JOIN 
		ratings r 
	ON g.movie_id = r.movie_id
	WHERE 
		avg_rating>8 
	GROUP BY 
		g.genre 
    ORDER BY 
		movie_count DESC
	LIMIT 3
),
cte_top_director AS
(
SELECT 
	n.name AS director_name, 
    COUNT(d.movie_id) AS movie_count, 
    RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM 
	names n 
INNER JOIN 
	director_mapping d 
ON n.id = d.name_id
INNER JOIN 
	ratings r 
ON r.movie_id = d.movie_id
INNER JOIN 
	genre g 
ON g.movie_id = d.movie_id, 
	cte_top_genre
WHERE 
	r.avg_rating > 8 
AND 
	g.genre 
IN (
	cte_top_genre.genre) -- (SELECT genre FROM cte_top_genre) GROUP BY n.name
GROUP BY 
	n.name
ORDER BY 
	movie_count DESC
)
SELECT 
	director_name, 
    movie_count 
FROM 
	cte_top_director 
WHERE 
	director_rank <= 3 
LIMIT 3;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT
	n.name AS actor_name, 
    COUNT(rm.movie_id) AS movie_count
FROM 
	names n 
INNER JOIN
	role_mapping rm
on n.id=rm.name_id 
INNER JOIN
		ratings r
ON r.movie_id=rm.movie_id 
WHERE 
	r.median_rating>= 8
GROUP BY 
	n.name
ORDER BY 
	COUNT(rm.movie_id) 
DESC
LIMIT 2;

-- Top 2 actors are Mammootty and Mohanlal.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company, 
    SUM(total_votes) AS vote_count, 
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
	movie m 
INNER JOIN
	ratings r
ON m.id=r.movie_id
GROUP BY
	production_company
ORDER BY 
	SUM(total_votes) DESC
LIMIT 3;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	n.name AS actor_name, 
	SUM(r.total_votes) AS total_votes, 
	COUNT(rm.movie_id) AS movie_count, 
	ROUND(SUM(r.avg_rating*r.total_votes),2)/SUM(r.total_votes) AS actor_avg_rating,
	RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes),2)/SUM(r.total_votes) DESC) AS actor_rank
FROM 
	names n 
INNER JOIN
	role_mapping rm
ON n.id=rm.name_id 
INNER JOIN
	ratings r
ON rm.movie_id=r.movie_id 
INNER JOIN
	movie m
ON m.id=rm.movie_id
WHERE 
	country = 'India'
GROUP BY 
	n.name 
HAVING
	COUNT(rm.movie_id)>= 5;
	
    -- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.
    
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:

+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	n.name as actress_name, 
	SUM(r.total_votes) AS total_votes, 
	COUNT(rm.movie_id) AS movie_count, 
	ROUND(SUM(r.avg_rating*r.total_votes),2)/SUM(r.total_votes) AS actor_avg_rating,
	RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*r.total_votes),2)/SUM(r.total_votes) DESC) AS actor_rank
FROM 
	names n 
INNER JOIN 
	role_mapping rm
ON n.id=rm.name_id 
INNER JOIN
	ratings r
ON rm.movie_id=r.movie_id 
INNER JOIN
	movie m
ON m.id=rm.movie_id
WHERE 
	country = 'India' 
AND 
	languages = 'Hindi' 
AND 
	category = 'actress'
GROUP BY 
	n.name 
HAVING 
	COUNT(rm.movie_id)>= 3;

-- Top five actresses in Hindi movies released in India based on their average ratings are 
-- Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
		    Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using CASE statements to classify thriller movies as per avg rating 
SELECT 
	m.title AS thriller_movies, 
	r.avg_rating AS Rating,
(CASE
	WHEN r.avg_rating > 8 THEN 'superhit movie'
	WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
	WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'one-time-watch movie'
ELSE 
	'Flop movie'
END) AS movie_classification 
FROM 
	ratings r 
INNER JOIN
	movie m
ON r.movie_id=m.id 
INNER JOIN
	genre g 
ON r.movie_id=g.movie_id
WHERE
	g.genre = 'thriller'
GROUP BY
	m.title, 
	r.avg_rating
ORDER BY
	r.avg_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	g.genre, 
	ROUND(AVG(m.duration),2) AS avg_duration,
	SUM(ROUND(AVG(m.duration),2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	AVG(ROUND(AVG(m.duration),2)) OVER (ORDER BY genre ROWS 5 PRECEDING) AS moving_avg_duration
FROM 	
	genre g 
INNER JOIN
	movie m
ON m.id=g.movie_id
GROUP BY
	g.genre
ORDER BY
	genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_list AS 
(
	SELECT 
		genre, 
		COUNT(g.movie_id) AS movie_count, 
        RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank 
	FROM 
		genre AS g 
	INNER JOIN
		ratings as r 
	ON g.movie_id = r.movie_id 
	WHERE 
		r.avg_rating > 8 
	GROUP BY
		genre 
	ORDER BY
		COUNT(g.movie_id) DESC
),
world_gross_income_summary AS 
(
SELECT 
	genre, 
    year, 
    title as movie_name, 
CASE 
	WHEN POSITION('INR' IN worlwide_gross_income)>0 THEN CONCAT('$', CAST((CAST(REPLACE(worlwide_gross_income, 'INR',' ') AS DECIMAL(10)) /79) AS CHAR (20)))
	ELSE worlwide_gross_income
END AS 
	worldwide_gross_income,
CASE 
	WHEN POSITION('INR' IN worlwide_gross_income)>0 THEN CAST(REPLACE(worlwide_gross_income, 'INR',' ') AS DECIMAL(10)) /79
	WHEN POSITION('$' IN worlwide_gross_income)>0 THEN CAST(REPLACE(worlwide_gross_income, '$',' ') AS DECIMAL(10))
END AS 
	worldwide_gross_income_num
FROM 
	movie AS m 
INNER JOIN 
	genre as g
ON m.id = g.movie_id 
WHERE 
	genre IN 
			(SELECT 
				genre 
			FROM 
				genre_list 
			WHERE 
				genre_rank <= 3
                ) AND 
					worlwide_gross_income IS NOT NULL
), 
using_rank AS 
(
SELECT 
	genre, 
    year, 
    movie_name, 
    worldwide_gross_income, 
	DENSE_RANK() OVER (PARTITION BY YEAR ORDER BY worldwide_gross_income_num DESC) AS movie_rank 
 FROM  
	world_gross_income_summary 
ORDER BY
	year
 ) 
 SELECT 
	* 
 FROM 
	using_rank 
WHERE 
	movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company, 
    COUNT(id) AS movie_count,
	RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM 
	movie m 
INNER JOIN
	ratings r
ON m.id=r.movie_id
WHERE 
	languages LIKE '%,%' 
AND 
	median_rating>=8 
GROUP BY
	production_company 
HAVING 
	production_company IS NOT NULL
    LIMIT 2;

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Top 3 actresses based on number of Super Hit movies

SELECT 
	n.name AS actress_name, 
	SUM(r.total_votes) AS total_votes, 
	COUNT(r.movie_id) AS movie_count,
	AVG(r.avg_rating) AS actress_avg_rating,
	RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM 
	movie m 
INNER JOIN
	ratings r
ON m.id=r.movie_id 
INNER JOIN
	role_mapping rm
ON rm.movie_id=m.id 
INNER JOIN
	names n
ON n.id=rm.name_id 
INNER JOIN
	genre g
ON r.movie_id=g.movie_id
WHERE
	r.avg_rating > 8 and rm.category = 'actress' and g.genre = 'Drama'
GROUP BY
	n.name
ORDER BY
	count(r.movie_id) DESC
LIMIT 3;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations


Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      name,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   
		next_date_published_summary )
SELECT   
		 name_id                       AS director_id,
         name                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     
	top_director_summary
GROUP BY 
	director_id
ORDER BY 
	Count(movie_id) DESC 
limit 9;