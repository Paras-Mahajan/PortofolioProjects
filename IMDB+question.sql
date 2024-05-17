USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
show tables

-- total number of rows in Table director_mapping
SELECT count(*)
FROM director_mapping
-- rows - 3867

-- total number of rows in Table genre
SELECT COUNT(*)
FROM genre
-- rows - 14662

-- total number of rows in Table movie
SELECT COUNT(*)
FROM movie
-- rows - 7997

-- total number of rows in Table names
SELECT COUNT(*)
FROM names
-- rows - 25735

-- total number of rows in Table ratings
SELECT count(*)
FROM ratings
-- rows - 7997

-- total number of rows in Table role_mapping
SELECT count(*)
FROM role_mapping
-- rows - 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select count(*)
FROM movie
WHERE id IS NULL
-- id column has no null values

SELECT count(*)
FROM movie
WHERE title IS NULL
-- title column has no null values

SELECT count(*)
FROM MOVIE
WHERE year is null
-- year column has no null values

SELECT COUNT(*)
FROM movie
WHERE date_published is null
-- date_published column has no null values

SELECT COUNT(*)
FROM movie
WHERE duration is null
-- duration column has no null values

SELECT COUNT(*)
FROM movie
WHERE country is null
-- date_published column has 20 null values

SELECT COUNT(*)
FROM movie
WHERE worlwide_gross_income is null
-- worlwide_gross_income column has 3724 null values

SELECT COUNT(*)
FROM movie
WHERE languages is null
-- languages column has 194 null values

SELECT COUNT(*)
FROM movie
WHERE production_company is null
-- production_company column has 528 null values

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
-- First_part of the question
-- We we going to find out the number of movies released per year
SELECT 
	Year, 
	COUNT(*) as number_of_movies
FROM 
	movie
GROUP BY 
	year
    
-- Second_part of the question
-- We are going to find out the number of movies released per month
SELECT 
	month(date_published) AS Month, 
	COUNT(*) as number_of_movies
FROM 
	movie
GROUP BY 
	month(date_published)
 ORDER BY 
	number_of_movies DESC


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
 
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT count(*) as No_of_movies
FROM movie
WHERE country in ('USA', 'INDIA')

-- 3267 movies were released in USA and INDIA

SELECT count(*) as No_of_movies
FROM movie
WHERE country in ('USA', 'INDIA') AND year = 2019

-- 887 movies were released in the year 2019 in the country (USA AND INDIA)

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT genre, count(*) AS no_of_movies
FROM movie m
INNER JOIN genre g
on m.id = g.movie_id
GROUP BY genre
ORDER BY no_of_movies DESC

-- Drama genre has 4285 --

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT movie_id, count(*)
FROM genre
GROUP BY movie_id

SELECT count(*)
FROM genre
-- 14662

SELECT count(*)
FROM movie
-- 7997
-- That means to say same movie_id has many columns as many movies has many genres

-- lets count the number of movies with single genre

WITH single_genre AS
(
SELECT movie_id, count(*) as no_of_genres
FROM genre
GROUP BY movie_id
HAVING no_of_genres = 1
)
SELECT COUNT(*) AS no_of_movies_with_single_genre
FROM single_genre



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

SELECT genre, avg(m.duration) as avg_duration
FROM movie m
INNER JOIN genre g
ON g.movie_id = m.id
GROUP BY g.genre





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
WITH genre_rank as
(
SELECT genre, COUNT(*) AS movie_count, RANK() OVER(ORDER BY COUNT(*) DESC) as genre_rank
FROM genre
GROUP BY genre
)
SELECT *
FROM genre_rank
WHERE genre = 'Thriller'


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

SELECT min(avg_rating) AS min_avg_rating, max(avg_rating) AS max_avg_rating, min(total_votes) AS min_total_votes, max(total_votes) AS max_total_votes,
min(median_rating) AS min_median_rating, max(median_rating) AS max_median_rating
FROM ratings




    

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

WITH avg_rating_rank AS
(
SELECT m.title as tile, r.avg_rating as avg_rating, RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
)
SELECT *
FROM avg_rating_rank
WHERE movie_rank <=10






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

SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC





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

SELECT m.production_company , COUNT(*) as movie_count, RANK() OVER(ORDER BY count(*) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY m.production_company




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
SELECT g.genre, count(*) as movie_count
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
on m.id = r.movie_id
WHERE m.country = 'USA' and r.total_votes > 1000 AND m.year = 2017
GROUP BY g.genre



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

SELECT m.title, r.avg_rating, g.genre
FROM genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
INNER JOIN movie m
ON m.id = r.movie_id
WHERE m.title regexp '^THE' AND r.avg_rating > 8







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT count(*) as no_of_movies
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.median_rating = 8 AND date_published > '2018-04-01' AND date_published < '2019-04-01'

-- 360 movies

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.country, sum(total_votes) AS total_votes
FROM ratings r
INNER JOIN movie m
ON r.movie_id = m.id
WHERE m.country in ('Germany', 'Italy')
GROUP BY m.country

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
	COUNT(CASE WHEN id is null THEN 1 END) AS nulls_in_id_column,
	COUNT(CASE WHEN name is null THEN 1 END) AS nulls_in_name_column,
	COUNT(CASE WHEN height is null THEN 1 END) AS nulls_in_height_column,
	COUNT(CASE WHEN date_of_birth is null THEN 1 END) AS nulls_in_date_of_birth_column,
	COUNT(CASE WHEN known_for_movies is null THEN 1 END) AS nulls_in_known_for_movies_column
FROM names




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

SELECT n.name, COUNT(*) AS movie_count
FROM movie m
LEFT JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN director_mapping dm
ON dm.movie_id = r.movie_id
INNER JOIN names n
ON n.id = dm.name_id
WHERE r.avg_rating > 8 AND g.genre IN (
WITH genre__ AS
(
SELECT genre, RANK() OVER(ORDER BY count(*) DESC) as genre_rank
FROM genre
GROUP BY genre
ORDER BY COUNT(*) DESC
)
SELECT genre
FROM genre__
WHERE genre_rank<=3
)
GROUP BY n.name
ORDER BY movie_count DESC

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

SELECT n.name as actor_name , count(*)
FROM movie m
LEFT JOIN ratings r
ON r.movie_id = m.id
INNER JOIN role_mapping rm
ON r.movie_id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE r.median_rating >= 8
GROUP BY n.name
ORDER BY count(*) DESC




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

WITH prod_comp_rank AS
(
SELECT m.production_company, SUM(total_votes) AS vote_count, RANK() OVER(ORDER BY SUM(total_votes) DESC) as prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY m.production_company
)
SELECT *
FROM prod_comp_rank
WHERE prod_comp_rank <= 3

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
SELECT n.name AS actor_name, SUM(total_votes) AS total_votes, COUNT(*) AS movie_count, SUM(avg_rating)/COUNT(*) AS actor_avg_rating,
		RANK() OVER(ORDER BY SUM(total_votes) DESC, (SUM(avg_rating)/COUNT(*))DESC) as actor_rank
FROM movie m
LEFT JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE m.country = 'India'
GROUP BY n.id
HAVING movie_count >= 5


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


SELECT n.name AS actor_name, SUM(total_votes) AS total_votes, COUNT(*) AS movie_count, SUM(avg_rating)/COUNT(*) AS actor_avg_rating,
		RANK() OVER(ORDER BY SUM(total_votes) DESC, (SUM(avg_rating)/COUNT(*))DESC) as actor_rank
FROM movie m
LEFT JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE m.country = 'India' AND m.languages = 'HINDI' AND rm.category = 'Actress'
GROUP BY n.name
HAVING movie_count >= 3



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
	m.title,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating > 7 AND r.avg_rating < 8 THEN 'Hit movies'
        WHEN r.avg_rating > 5 AND r.avg_rating < 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
        END AS movie_category
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
ON r.movie_id = m.id
WHERE g.genre = 'Thriller'







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



with duration_summary AS
(
SELECT g.genre, AVG(m.duration) as avg_duration
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre
)
select *,
		SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
		AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM duration_summary



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


SELECT g.genre, m.year, m.title, m.worlwide_gross_income, RANK() OVER(ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE g.genre in
(
WITH genre__ AS
(
SELECT genre, RANK() OVER(ORDER BY count(*) DESC) as genre_rank
FROM genre
GROUP BY genre
ORDER BY COUNT(*) DESC
)
SELECT genre
FROM genre__
WHERE genre_rank<=3
)
LIMIT 3






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

SELECT m.production_company, count(*) AS movie_count, RANK() OVER(ORDER BY count(*) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.median_rating >= 8
GROUP BY m.production_company




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

SELECT n.name AS actress_name, sum(r.total_votes) AS total_votes,
		avg(r.avg_rating )AS actress_avg_rating, RANK() OVER (ORDER BY avg(r.avg_rating) DESC) AS actress_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE rm.category = 'Actress' 
GROUP BY n.name
HAVING actress_avg_rating > 8





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
-- creating table top_9_directors

CREATE VIEW top_9_directors
AS (
WITH dir_summary AS
			(
				SELECT dm.name_id, row_number() OVER(ORDER BY COUNT(*) DESC) AS dir_rank
				FROM movie m
				INNER JOIN director_mapping dm
				ON m.id = dm.movie_id
				GROUP BY dm.name_id
			)
				SELECT name_id
				FROM dir_summary
				WHERE dir_rank <= 9
)
-- CREATE VIEW TABLE date_summary
CREATE VIEW date_summary AS
			(
			SELECT n.id , m.date_published, LEAD(m.date_published,1) OVER(ORDER BY m.date_published) AS next_movie_date
			FROM movie m
				INNER JOIN director_mapping dm
					ON m.id = dm.movie_id
				INNER JOIN names n
					ON n.id = dm.name_id
				INNER JOIN top_10_directors t
				ON t.name_id = n.id
			GROUP BY n.id, m.date_published
            )

SELECT n.id AS director_id, 
		n.name AS director_name, 
		COUNT(*) AS number_of_movies, 
        AVG(datediff(ds.next_movie_date, ds.date_published)) AS avg_inter_movie_days,
		avg(r.avg_rating) AS avg_rating,
		SUM(r.total_votes) AS total_votes, 
		MIN(r.avg_rating) AS min_rating, 
		MAX(r.avg_rating) AS max_rating,
		SUM(m.duration) AS total_duration
					
			FROM movie m
			INNER JOIN ratings r
			ON m.id = r.movie_id
			INNER JOIN director_mapping dm
			ON dm.movie_id = m.id
			INNER JOIN names n
			ON n.id = dm.name_id
			INNER JOIN top_9_directors t
            ON t.name_id = dm.name_id
            INNER JOIN date_summary ds
            ON ds.id = n.id
			GROUP BY n.id
