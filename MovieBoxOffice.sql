Table 1 Query:
Create table Movies 
  (ID int, 
  Title varchar(50),
  Director varchar(50),
  Year int,
  Length_minutes int)


Table 2 Query:
Create table BoxOffice
( Movie_id int,
  Rating int,
  Domestic_Sales int,
  International_Sales int)


Table 1 Insert:
Insert into table Movies VALUES
(1, "Toy Story", "John Lasseter", 1995, 81)
(2,	"A Bug's Life",	John Lasseter,	1998,	95)
(3,	"Toy Story 2",	John Lasseter,	1999,	93)
(4,	"Monsters, Inc.",	Pete Docter,	2001,	92)
(5,	"Finding Nemo",	Andrew Stanton,	2003,	107)
(6,	"The Incredibles",	Brad Bird,	2004,	116)
(7,	"Cars",	John Lasseter,	2006,	117)
(8,	"Ratatouille",	Brad Bird,	2007,	115)
(9,	"WALL-E",	Andrew Stanton,	2008,	104)
(10,	"Up",	Pete Docter,	2009,	101)
(11,	"Toy Story 3",	Lee Unkrich,	2010,	103)
(12,	"Cars 2",	John Lasseter,	2011, 120)
(13,	"Brave",	Brenda Chapman,	2012,	102)
(14,	"Monsters University",	Dan Scanlon,	2013,	110)


  
Table 2 Insert:
Insert into table BoxOffice VALUES
(5, 8.2,	380843261,	555900000)
(14, 7.4,	268492764,	475066843)
(8, 8,	206445654,	417277164)
(12, 6.4,	191452396,	368400000)
(3, 7.9,	245852179,	239163000)
(6, 8,	261441092,	370001000)
(9, 8.5,	223808164,	297503696)
(11, 8.4,	415004880,	648167031)
(1,	8.3,	191796233,	170162503)
(7, 7.2,	244082982,	217900167)
(10, 8.3,	293004164,	438338580)
(4, 8.1,	289916256,	272900000)
(2,	7.2,	162798565,	200600000)
(13, 7.2,	237283207,	301700000)


-- Find the movie with a row ID of 6 
SELECT ID, title FROM Movies 
  WHERE ID = 6;


--Find the movies released in the years between 2000 and 2010
SELECT Title, year FROM Movies
  WHERE year BETWEEN 2000 AND 2010;


-- Find the movies NOT released in the years between 2000 and 2010 
SELECT Title, Year FROM Movies
  WHERE Year < 2000 OR year > 2010;


-- Find the first 5 Pixar movies and their release year 
SELECT Title, Year FROM Movies
  WHERE Year <= 2003;


-- Find all Toy Story Movies
SELECT title, director FROM movies 
  WHERE title LIKE "Toy Story%";


--Find the domestic and international sales for each movie
SELECT title, domestic_sales, international_sales 
FROM Movies
  JOIN BoxOffice
    ON movies.id = boxoffice.movie_id;


--Show the sales numbers for each movie that did better internationally rather than domestically
SELECT title, domestic_sales, international_sales
FROM Movies
  JOIN BoxOffice
    ON movies.id = boxoffice.movie_id
WHERE International_sales > Domestic_sales;


-- List all the movies by their ratings in descending order 
SELECT Title, Rating
FROM Movies
  JOIN BoxOffice
    ON movies.id = boxoffice.movie_id
ORDER BY Rating DESC;


-- List the last four Pixar movies released (ordered from most recent to least) 
SELECT DISTINCT Director FROM Movies
ORDER BY Director ASC;


-- List the last four Pixar movies released (ordered from most recent to least) 
SELECT Title, year FROM Movies
ORDER BY year DESC
LIMIT 4;


-- List the first five Pixar movies sorted alphabetically 
SELECT Title FROM Movies
ORDER BY Title ASC
LIMIT 5;


-- List the next five Pixar movies sorted alphabetically 
SELECT Title FROM Movies
ORDER BY Title ASC
LIMIT 5 OFFSET 5;


