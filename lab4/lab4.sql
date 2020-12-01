CREATE EXTENSION plpython3u;

-- #1: Определяемая пользователем скалярная функция CLR
-- Сколько пациентов имеют заданный симптом

--1
CREATE OR REPLACE FUNCTION SymptomCount1(s VARCHAR) RETURNS VARCHAR
AS $$
ps = plpy.execute("SELECT name \
    FROM _person P JOIN person_symptom PS ON P.id = PS.id_person \
    JOIN _symptom S on PS.id_symptom = S.id;")
count = 0
for i in range(ps.nrows()):
    if ps[i]["name"] == s:
        count += 1
return count
$$ language plpython3u;

SELECT * FROM SymptomCount1('anosmia');
SELECT * FROM SymptomCount1('pneumonia');
SELECT * FROM SymptomCount1('cough');

--2
CREATE OR REPLACE FUNCTION SymptomCount2(s VARCHAR) RETURNS INTEGER
AS $$
plan = plpy.prepare("SELECT name  \
    FROM _person P JOIN person_symptom PS ON P.id = PS.id_person \
    JOIN _symptom s on PS.id_symptom = s.id \
    WHERE name = $1", ["VARCHAR"])
result = plpy.execute(plan, [s])
return result.nrows()
$$ language plpython3u;

SELECT * FROM SymptomCount2('anosmia');
SELECT * FROM SymptomCount2('pneumonia');
SELECT * FROM SymptomCount2('cough');

--Выдать информацию о местоположении по идентификатору местности
CREATE OR REPLACE FUNCTION FindLocation(l_id INT) RETURNS _location
AS $$
location = plpy.execute(f"SELECT *  \
    FROM _location \
    WHERE id = {l_id}")
return location[0];
$$ language plpython3u;

SELECT * FROM FindLocation(1);
SELECT * FROM FindLocation(100);

-- #2: Пользовательская агрегатная функция CLR
--Возвращает пол (мужской/женский), представители которого чаще всех
--сталкивались с заданным симптомом

--1
CREATE OR REPLACE FUNCTION FemaleOrMale1(symp VARCHAR) RETURNS VARCHAR
AS $$
plan = plpy.prepare(f"SELECT gender \
FROM _person P JOIN person_symptom PS ON P.id = PS.id_person \
JOIN _symptom S on PS.id_symptom = S.id \
WHERE name = $1 AND gender IS NOT NULL \
GROUP BY gender \
HAVING COUNT(*) IN \
(SELECT MAX(count) \
FROM \
(SELECT gender, COUNT(*) as count \
FROM _person P JOIN person_symptom PS ON P.id = PS.id_person \
JOIN _symptom S on PS.id_symptom = S.id \
WHERE name = $1 AND gender IS NOT NULL \
GROUP BY gender) T)", ["VARCHAR"])
return plpy.execute(plan, [symp])[0]['gender']
$$ language plpython3u;

SELECT * FROM FemaleOrMale1('fever');
SELECT * FROM FemaleOrMale1('vomitting');

--2
CREATE OR REPLACE FUNCTION FemaleOrMale2(symp VARCHAR) RETURNS VARCHAR
AS $$
plan = plpy.prepare(f"SELECT gender \
FROM _person P JOIN person_symptom PS ON P.id = PS.id_person \
JOIN _symptom S on PS.id_symptom = S.id \
WHERE name = $1 AND gender IS NOT NULL", ["VARCHAR"])
data = plpy.execute(plan, [symp])
female_count, male_count = 0, 0
for i in data:
    if i['gender'] == 'male':
        male_count += 1
    else:
        female_count += 1
if female_count > male_count:
    return 'female ' + str(female_count)
elif female_count < male_count:
    return 'male ' + str(male_count)
else:
    return 'equal'
$$ language plpython3u;

SELECT * FROM FemaleOrMale2('fever');
SELECT * FROM FemaleOrMale2('vomitting');

-- #3: Определяемая пользователем табличная функция CLR

-- Возвращает информацию в виде таблицы о пациентах заданного возраста, проживающих
-- в заданной стране
CREATE OR REPLACE FUNCTION InfoPatientsByCountry(country VARCHAR, age INT) RETURNS TABLE
(
    reporting_date varchar,
    country varchar,
    latitude varchar,
    longitude varchar,
    symptom_onset varchar,
    age int
)
AS $$
pl = plpy.execute("SELECT reporting_date, country, latitude, longitude, symptom_onset, age \
FROM _person P JOIN _location L ON P.id_location = L.id \
ORDER BY country")
tbl = list()
for i in pl:
    if i['country'] == country and i['age'] == age:
        tbl.append(i)
return tbl
$$ LANGUAGE plpython3u;

SELECT * FROM InfoPatientsByCountry('China', 30);
SELECT * FROM InfoPatientsByCountry('Canada', 60);

-- #4: Хранимая процедура CLR

--Добавить в таблицу симптомов новый симптом
CREATE OR REPLACE PROCEDURE AddSymptom(id int, symp VARCHAR)
AS $$
plan = plpy.prepare(f"INSERT INTO _symptom(id, name)\
VALUES ($1, $2)", ["INT", "VARCHAR"])
plpy.execute(plan, [id, symp])
$$
LANGUAGE plpython3u;

CALL AddSymptom(49, 'hallucinations');
SELECT *
FROM _symptom

--Удалить из таблицы симптомов заданный симптом
CREATE OR REPLACE PROCEDURE DeleteSymptom(symp VARCHAR)
AS $$
plan = plpy.prepare(f"DELETE FROM _symptom\
WHERE name = $1", ["VARCHAR"])
plpy.execute(plan, [symp])
$$
LANGUAGE plpython3u;

CALL DeleteSymptom('hallucinations');
SELECT *
FROM _symptom

-- #5: Триггер CLR
-- Когда функция используется как триггер,
-- словарь TD содержит значения, связанные с работой триггера

--Триггерная функция history() триггера After log_person
--запишет в таблицу log информацию об изменениях в таблице person_copy
--сообщение о добавлении/обновлении/удалении + id пациента
--********************************************AFTER
SELECT *
INTO TEMP person_copy
FROM _person;
--DROP TABLE person_copy;
--SELECT * FROM person_copy;

CREATE TABLE IF NOT EXISTS log
(
    message varchar,
    id int
);
--DROP TABLE log;

CREATE OR REPLACE FUNCTION history() RETURNS TRIGGER
AS $$
plan = plpy.prepare("INSERT INTO log(message, id) values ($1, $2);", ["VARCHAR", "INT"])
msg1 = 'Add new patient'
msg2 = 'Update patient'
msg3 = 'Delete patient'
if TD['event'] == 'INSERT':
    plpy.execute(plan, [msg1, TD['new']["id"]])
    #return TD['new']
elif TD['event'] == 'UPDATE':
    plpy.execute(plan, [msg2, TD['new']["id"]])
    #return TD['new']
elif TD['event'] == 'DELETE':
    plpy.execute(plan, [msg3, TD['old']["id"]])
    #return TD['old']
#return TD['new']
$$ LANGUAGE plpython3u;

CREATE TRIGGER log_person
AFTER INSERT OR UPDATE OR DELETE ON person_copy
FOR EACH ROW
EXECUTE PROCEDURE history();

DROP TRIGGER log_person on person_copy;

--TEST AFTER
DELETE FROM person_copy
WHERE id = 2;

UPDATE person_copy
SET id_status = 2
WHERE exposure_end IS NULL;

SELECT *
FROM log;

-- #6: Определяемый пользователем тип данных CLR

--Физические параметры пациента
CREATE TYPE attr AS (
    age INT,
    gender VARCHAR
);
-- DROP type attr;

-- Получить физические параметры пациента по его id
CREATE OR REPLACE FUNCTION GetAttributes(id INT) RETURNS attr
AS $$
data = plpy.execute(f"SELECT age, gender  \
    FROM _person \
    WHERE id = {id}")
#return [data[0]['age'], data[0]['gender']];
return (data[0]['age'], data[0]['gender']);
$$ language plpython3u;

SELECT * FROM GetAttributes(1);
SELECT * FROM GetAttributes(2);