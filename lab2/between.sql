-- Получить список (отсортированный) пациентов, чьи симптомы проявились от '01/03/20' и '02/03/20'

SELECT DISTINCT id, symptom_onset 
FROM _person P
WHERE symptom_onset BETWEEN '01/03/20' AND '02/03/20'
ORDER BY P.symptom_onset