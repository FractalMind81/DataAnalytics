USE SAKILA;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT FIRST_NAME, LAST_NAME FROM ACTOR;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
--     Name the column Actor Name.
SELECT UPPER(CONCAT(FIRST_NAME,' ',LAST_NAME)) AS ACTOR_NAME FROM ACTOR;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
--     of whom you know only the first name, "Joe." What is one query would 
--     you use to obtain this information?
SELECT ACTOR_ID, FIRST_NAME, LAST_NAME FROM ACTOR
WHERE FIRST_NAME = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT * FROM ACTOR
WHERE LAST_NAME LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
--     This time, order the rows by last name and first name, in that order:
SELECT * FROM ACTOR
WHERE LAST_NAME LIKE '%LI%'
ORDER BY LAST_NAME,FIRST_NAME;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
--     Afghanistan, Bangladesh, and China
SELECT COUNTRY_ID, COUNTRY FROM COUNTRY 
WHERE COUNTRY IN ('Afghanistan','Bangladesh','China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing 
--     queries on a description, so create a column in the table actor named description 
--     and use the data type BLOB (Make sure to research the type BLOB, as the difference 
--     between it and VARCHAR are significant).
ALTER TABLE ACTOR 
ADD COLUMN description BLOB(300) NULL;

-- 3b. Very quickly you realize that entering descriptions for each actor 
--     is too much effort. Delete the description column.
ALTER TABLE ACTOR
DROP COLUMN DESCRIPTION;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME, COUNT(LAST_NAME) FROM ACTOR
GROUP BY LAST_NAME;

-- 4b. List last names of actors and the number of actors who have that last name, 
--     but only for names that are shared by at least two actors
SELECT LAST_NAME, COUNT(LAST_NAME) FROM ACTOR
GROUP BY LAST_NAME
HAVING COUNT(LAST_NAME) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as 
--     GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE ACTOR
SET FIRST_NAME = 'HARPO'
WHERE FIRST_NAME = 'GROUCHO' AND LAST_NAME = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
--     GROUCHO was the correct name after all! In a single query, if the first 
--     name of the actor is currently HARPO, change it to GROUCHO.
UPDATE ACTOR
SET FIRST_NAME = 'GROUCHO'
WHERE FIRST_NAME = 'HARPO' AND LAST_NAME = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you 
--     use to re-create it?
SHOW CREATE TABLE ADDRESS;

-- 6a. Use JOIN to display the first and last names, as well as the address, of 
--     each staff member. Use the tables staff and address.
SELECT FIRST_NAME, LAST_NAME, ADDRESS FROM STAFF S
JOIN ADDRESS A 
ON S.ADDRESS_ID = A.ADDRESS_ID;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August 
--     of 2005. Use tables staff and payment.
SELECT FIRST_NAME, LAST_NAME, SUM(AMOUNT) FROM STAFF S
JOIN PAYMENT P
ON S.STAFF_ID = P.STAFF_ID
GROUP BY FIRST_NAME, LAST_NAME;

-- 6c. List each film and the number of actors who are listed for that film. Use tables 
--     film_actor and film. Use inner join.
SELECT TITLE, COUNT(ACTOR_ID) AS ACTORS FROM FILM F
INNER JOIN FILM_ACTOR FA
ON F.FILM_ID = FA.FILM_ID
GROUP BY TITLE;

--  6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(INVENTORY_ID) AS COPIES FROM INVENTORY
WHERE FILM_ID = (
				SELECT FILM_ID FROM FILM 
				WHERE TITLE = 'Hunchback Impossible'
                );
                
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by 
--     each customer. List the customers alphabetically by last name
SELECT P.CUSTOMER_ID, C.LAST_NAME, SUM(AMOUNT) AS TOTAL FROM PAYMENT P
JOIN CUSTOMER C
ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY CUSTOMER_ID,C.LAST_NAME
ORDER BY C.LAST_NAME;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
--     As an unintended consequence, films starting with the letters K and Q have 
--     also soared in popularity. Use subqueries to display the titles of movies 
--     starting with the letters K and Q whose language is English
SELECT TITLE FROM FILM 
WHERE TITLE LIKE 'K%' OR TITLE LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT concat(FIRST_NAME," ",LAST_NAME) AS ACTOR_NAME FROM ACTOR
WHERE ACTOR_ID IN 
(
	SELECT ACTOR_ID FROM FILM_ACTOR
	WHERE FILM_ID IN
    (
		SELECT FILM_ID FROM FILM
        WHERE TITLE = "Alone Trip"
	)
); 

-- 7c. You want to run an email marketing campaign in Canada, for which you will 
--     need the names and email addresses of all Canadian customers. Use joins to 
--     retrieve this information.
SELECT CONCAT(FIRST_NAME," ",LAST_NAME) AS CUSTOMER_NAME,EMAIL FROM CUSTOMER 
JOIN ADDRESS 
ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
JOIN CITY 
ON ADDRESS.CITY_ID = CITY.CITY_ID
JOIN COUNTRY 
ON CITY.COUNTRY_ID = COUNTRY.COUNTRY_ID
WHERE COUNTRY = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family
--     movies for a promotion. Identify all movies categorized as family films.
SELECT TITLE FROM FILM F
JOIN FILM_CATEGORY FC
ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C
ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = "Family";

-- 7e. Display the most frequently rented movies in descending order.
SELECT F.TITLE, COUNT(R.RENTAL_ID) AS RENTAL_COUNT FROM RENTAL R
JOIN INVENTORY I 
ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM F
ON I.FILM_ID = F.FILM_ID
GROUP BY TITLE
ORDER BY RENTAL_COUNT DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT S.STORE_ID, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM STORE S
JOIN INVENTORY I 
ON S.STORE_ID = I.STORE_ID
JOIN RENTAL R
ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P
ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY S.STORE_ID;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT STORE_ID, CITY, COUNTRY FROM STORE S
JOIN ADDRESS A
ON S.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C 
ON A.CITY_ID = C.CITY_ID
JOIN COUNTRY CT
ON C.COUNTRY_ID = CT.COUNTRY_ID;

-- 7h. List the top five genres in gross revenue in descending order. 
--    (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT NAME, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM CATEGORY C
JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I
ON FC.FILM_ID = I.FILM_ID
JOIN RENTAL R
ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P
ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY NAME
ORDER BY REVENUE DESC;

-- 8A. Use the solution from the problem above to create a view.
CREATE VIEW TOP_FIVE_GENRES_VW AS
SELECT NAME, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM CATEGORY C
JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I
ON FC.FILM_ID = I.FILM_ID
JOIN RENTAL R
ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P
ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM TOP_FIVE_GENRES_VW;

-- 8c. Drop top_five_genres_view
DROP VIEW TOP_FIVE_GENRES_VW;









