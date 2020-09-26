INSERT _location(id, _location, country, latitude, longitude)
SELECT 1050,
(
	SELECT DISTINCT _location
	FROM _location
	WHERE country = 
	(
		SELECT MAX(country)
		FROM _location
	) AND _location LIKE 'Vinh%'
), 
(
	SELECT MAX(country)
	FROM _location
),
(
	SELECT AVG(latitude)
	FROM _location
),
(
	SELECT AVG(longitude)
	FROM _location
);

UPDATE _location
SET latitude = latitude * 1.5, longitude = (SELECT AVG(age) FROM _person WHERE age > 0)
WHERE id = 1050;

DELETE FROM _location
WHERE id = 1050
