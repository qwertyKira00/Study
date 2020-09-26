SELECT id, 
(
	SELECT MAX(P.age)
	FROM _person P
	WHERE P.id_location = _location.id
) AS Max_Age,
(
	SELECT MIN(P.symptom_onset)
	FROM _person P
	WHERE P.id_location = _location.id
) AS Min_SymptomOnset,
(
	SELECT MIN(P.hosp_visit_date)
	FROM _person P
	WHERE P.id_location = _location.id
) AS Min_HospitalVisitDate,
(
	SELECT MIN(P.exposure_start)
	FROM _person P
	WHERE P.id_location = _location.id
) AS Min_ExposureStart,
(
	SELECT MIN(P.exposure_end)
	FROM _person P
	WHERE P.id_location = _location.id
) AS Min_ExposureEnd,
_location, country, latitude, longitude
FROM _location
-- ORDER BY Max_Age
