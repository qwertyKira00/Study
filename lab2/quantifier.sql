-- Получить список пациентов старше любого пациента из Ухани
SELECT DISTINCT *
FROM _person
WHERE age > ALL
(
	SELECT age
	FROM _person
	WHERE from_Wuhan = 1
);

-- Получить список пациентов, дата начала симптомов которых раньше любого пациента, посещавшего Ухань
SELECT DISTINCT *
FROM _person
WHERE symptom_onset < ALL
(
	SELECT symptom_onset
	FROM _person
	WHERE visiting_Wuhan = 1
)