-- Получить список дат обращения в больницу пациентов, 
-- в описании местоположения которых присутствует слово 'Wuhan'
SELECT hosp_visit_date
FROM _person P JOIN _location L ON P.id_location = L.id
WHERE _location LIKE '%Wuhan%'
