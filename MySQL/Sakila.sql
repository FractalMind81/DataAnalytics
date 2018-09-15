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


