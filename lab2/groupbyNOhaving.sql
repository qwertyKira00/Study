-- Для каждого жителя Ухани, в описании симптомов которого присутствует слово 'head'
-- получить его возраст, дату проявления симптомов и статус здоровья (если он известен)
SELECT P.age AS Age, symptom_onset, S.progress
FROM _person P JOIN _status S ON P.id_status = S.id 
JOIN person_symptom PS ON PS.id_person = P.id
JOIN _symptom SYMP ON PS.id_symptom = SYMP.id
WHERE P.from_Wuhan = 1 AND SYMP.name LIKE '%head%' AND S.progress NOT LIKE '%UNKNOWN%'
GROUP BY P.id
-- HAVING progress NOT LIKE '%UNKNOWN%'