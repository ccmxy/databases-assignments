#1 Find all films with maximum length and minimum rental duration (compared to all other films).
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film.
#You need to find all films with length L and rental duration R.
#You just need to return attribute film id for this query.

SELECT film.film_id, film.length L, film.rental_duration R
FROM   film
WHERE  film.length=(SELECT MAX(film.length) FROM film)
AND film.rental_duration=(SELECT MIN(film.rental_duration)  FROM film);


#2 We want to find out how many actors have played in each film, so for each film return the film id, film title, and the number of actors who played in that film. Some films may have no actors, and your query does not need to return those films.

SELECT film.film_id, film.title, count(*) as NumActors
  FROM film
  INNER JOIN film_actor ON film_actor.film_id = film.film_id
  GROUP BY film_id;

#3 Find the average length of films for each language. Your query should return every language even if there is no films in that language. language refers to attribute language_id (not attribute original_language_id)

  SELECT language.name, avg(IFNULL(length,0)) AverageLength
    FROM language
    LEFT OUTER JOIN film ON language.language_id = film.language_id
    GROUP BY language.name;

#4 We want to find out how many of each category of film KEVIN BLOOM has started in so return a table with category.name and the count
#of the number of films that KEVIN was in which were in that category order by the category name ascending (Your query should return every category even if KEVIN has been in no films in that category).
SELECT category.name, count(actor.actor_id) as kevinCount
 FROM category
 LEFT JOIN film_category ON film_category.category_id = category.category_id
 LEFT JOIN film_actor ON film_actor.film_id = film_category.film_id
 LEFT JOIN actor ON actor.actor_id = film_actor.actor_id AND actor.first_name="KEVIN" AND actor.last_name="BLOOM"
 GROUP BY category.name;

#5 Find the film title of all films which do not feature both SCARLETT DAMON and BEN HARRIS(so you will not list a film if both of these
#actors have played in that film, but if only one or none of these actors have played in a film, that film should be listed).
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT film.title
FROM film
  WHERE film.film_id NOT IN (
  SELECT film.film_id
FROM film
    JOIN film_actor
    WHERE film_actor.film_id = film.film_id
      AND
        film_actor.actor_id IN (SELECT actor.actor_id FROM actor WHERE(actor.first_name = "Ben" AND actor.last_name = "Harris"))
      AND film_actor.film_id IN (SELECT film_actor.film_id FROM film_actor WHERE(film_actor.actor_id IN (SELECT actor.actor_id FROM actor WHERE
actor.first_name = "Scarlett" AND actor.last_name = "Damon")))
);

##Psuedocode of the above:
## Only display films who's IDs are NOT in:
##   Get film id's
##   Join film_actor rows where film actor's film_id matches the row's film_id,
##   AND film_actor.actor_id is Ben Harris's id,
##   AND film_actor.film_id is in a list of the film
##   ids of movies that Scarlett Damon has been in.
##   This successfully lists all but the 4 movies that the pair costarred in,
##   which are RIDER CADDYSHACK, FRANKENSTEIN STRANGER, MILLION ACE, and BEAR GRACELAND.
