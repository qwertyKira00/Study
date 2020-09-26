WITH CTE(gender, MaxAge)
AS 
(
	SELECT gender, MAX(age) AS age
	FROM _person
	WHERE gender <> 'NA' AND age > 0
	GROUP BY gender
)
SELECT MAX(MaxAge) AS 'Максимальный возраст среди пациентов обоих полов'
FROM CTE
