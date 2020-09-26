-- Получить список пациентов женского пола, занесенных в базу данных '2/27/2020'
SELECT DISTINCT id, reporting_date, gender
FROM _person P
WHERE reporting_date = '2/27/2020' AND
EXISTS (
	SELECT id 
	FROM _person
	WHERE gender = 'female' AND
	id = P.id
);

-- Получить список всех пар пациентов, проживающих на одной территории
SELECT DISTINCT P1.id, P1.gender, P1.age, P1.id_location, P2.id, P2.gender, P2.age, P2.id_location
FROM _person P1 JOIN _person P2 ON P1.id_location = P2.id_location
WHERE P1.id < P2.id
ORDER BY P1.id_location, P2.id_location;

-- Получить список всех локаций, в которых проживают пациенты как мужского, так и женского пола 
SELECT DISTINCT *
FROM _location
WHERE id IN 
(
	SELECT DISTINCT id_location
	FROM _person P
	WHERE gender = 'male' AND
	EXISTS (
		SELECT id
		FROM _person
		WHERE gender = 'female' AND
		id_location = P.id_location
	)
);

-- Получить список локаций, в которых никто не проживает
SELECT *
FROM _location 
WHERE EXISTS (
	SELECT _location.id
	FROM _location LEFT OUTER JOIN _person
	ON _location.id = _person.id_location
	WHERE _person.id_location IS NULL
)
