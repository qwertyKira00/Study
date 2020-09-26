SELECT P.id, P.gender, PSS.name
FROM _person P JOIN
(
	SELECT PS.id_person, S.name
	FROM person_symptom PS JOIN _symptom S ON PS.id_symptom = S.id
) AS PSS ON PSS.id_person = P.id
ORDER BY PSS.name DESC;

SELECT L.country
FROM _person P JOIN
(
	SELECT id, country
	FROM _location 
	WHERE country <> 'China' AND country <> 'France'
) AS L ON P.id_location = L.id
UNION
SELECT L.country
FROM _location L JOIN
(
	SELECT P.id, P.id_location, S.progress
	FROM _person P JOIN _status S ON P.id_status = S.id
	WHERE S.progress NOT LIKE '%UNKNOWN%'
) AS PS ON PS.id_location = L.id

