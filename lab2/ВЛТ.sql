SELECT id,
MIN(age) AS MinAge, 
MAX(exposure_end) AS MaxExposureEnd
INTO #DifficultCases
FROM _person
GROUP BY id