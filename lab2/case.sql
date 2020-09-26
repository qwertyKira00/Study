SELECT id, symptom_onset, hosp_visit_date,
CASE 
	WHEN symptom_onset = 'NA' OR hosp_visit_date = 'NA' THEN 'Information is unavailable'
	WHEN symptom_onset < hosp_visit_date THEN 'Was examined with delay'
	WHEN symptom_onset = hosp_visit_date THEN 'Was examined the day when first symptoms appeared'
	ELSE 'Information is unavailable'
END AS Examination
FROM _person;

SELECT P.id, P.reporting_date, P.gender, P.age, P.symptom_onset, 
CASE 
	WHEN P.age < 1 THEN 'Newborn'
	WHEN P.age < 13 THEN 'Child'
	WHEN P.age < 23 THEN 'Teenager'
	ELSE 'Adult'
END AS SocialGroup, S.name
FROM _person P JOIN person_symptom PS ON P.id = PS.id_person LEFT JOIN _symptom S ON S.id = PS.id_symptom