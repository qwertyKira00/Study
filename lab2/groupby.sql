-- Оператор GROUP BY определяет, как строки будут группироваться
-- [GROUP BY столбцы_для_группировки]

-- Сгруппировать по полу
SELECT gender, COUNT(*) AS PatientsQuantity
FROM _person
GROUP BY gender;

-- Сгруппировать по статусу состояния здоровья (средний возраст в каждой группе)
SELECT _status.progress, AVG(_person.age) AS AverageAge
FROM _person JOIN _status ON _person.id_status = _status.id
GROUP BY _status.id
HAVING _status.progress NOT LIKE '%UNKNOWN%';

-- Получить количество умерших пациентов в каждой стране
SELECT LS.country, COUNT(*) AS DiedPatientsQuantity
FROM (
	SELECT P.id, L.country
	FROM _person P JOIN _location AS L ON P.id_location = L.id 
	WHERE P.id_status = 3 ) AS LS
GROUP BY LS.country
ORDER BY DiedPatientsQuantity;

-- Получить средний возраст смерти для всех стран
SELECT LS.country, AVG(LS.age) AS AverageAge
FROM (
	SELECT P.age, L.country
	FROM _person P JOIN _location AS L ON P.id_location = L.id 
	WHERE P.id_status = 3 ) AS LS
GROUP BY LS.country;
