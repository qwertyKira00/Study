-- Получить список пациентов, проживающих на территории, где широта больше среднего значения
-- долготы у страны, идущей первой по алфавиту

SELECT *
FROM _person P
WHERE EXISTS
(
	SELECT *
	FROM _location L
	WHERE latitude > 
	(
		SELECT AVG(longitude)
		FROM _location 
		WHERE country = 
		(
			SELECT MIN(country)
			FROM _location 
		)
	) AND P.id_location = L.id 
) and symptom_onset <> 'NA'
ORDER BY symptom_onset DESC
