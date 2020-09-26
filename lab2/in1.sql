-- Получить список дат начала проявления симптомов у пациентов, 
-- в описании симптомов которых присутствует слово 'throat'

SELECT symptom_onset
FROM _person
WHERE id IN
(
	SELECT id_person
	FROM person_symptom
	WHERE id_symptom IN
	(
		SELECT id
		FROM _symptom
		WHERE name LIKE '%throat%' 
	)
)
ORDER BY symptom_onset

