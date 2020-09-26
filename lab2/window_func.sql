-- Для заданной группы (пол) пациентов вывести: раннюю дату внесения в базу данных,
-- средний возраст, раннюю дату начала проявления симптомов,
-- раннюю дату обращения в больницу, максимальную широту территории проживания,
-- максимальную долготу территории проживания

SELECT DISTINCT P.gender, 
MIN(P.reporting_date) OVER (PARTITION BY P.gender) AS EarliestSReport,
AVG(P.age) OVER (PARTITION BY P.gender) AS AverageAge,
MIN(P.symptom_onset) OVER (PARTITION BY P.gender) AS EarliestSymptomOnset,
MIN(P.hosp_visit_date) OVER (PARTITION BY P.gender) AS EarliestHospitalVisit,
MAX(L.latitude) OVER (PARTITION BY P.gender) AS MaxLatitude,
MAX(L.longitude) OVER (PARTITION BY P.gender) AS MaxLongitude
FROM _person P JOIN _location L ON P.id_location = L.id;
