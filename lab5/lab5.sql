--Кодировка бд
SHOW SERVER_ENCODING;

--Синтаксис ввода/вывода типов данных JSON соответствует стандарту RFC 7159.

--#1 Из таблиц базы данных, созданной в первой лабораторной работе,
-- извлечь данные в JSON(Oracle, Postgres).
SELECT to_jsonb(_person) FROM _person;
SELECT to_jsonb(_location) FROM _location;
SELECT to_jsonb(_status) FROM _status;
SELECT to_jsonb(_symptom) FROM _symptom;
SELECT to_jsonb(person_symptom) FROM person_symptom;

SELECT row_to_json(_person) FROM _person;
--Функции array_to_json и row_to_json подобны to_json,
--но предлагают возможность улучшенного вывода.
-- Действие to_json, описанное выше, распространяется на каждое отдельное значение,
-- преобразуемое этими функциями.

--#2 Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать
-- таблице базы данных, созданной в первой лабораторной работе.

--STEP 1: Выгрузка данных из таблицы в JSON-файл
--Не работает. Подсказка psql: COPY TO instructs the PostgreSQL server process to write a file.
-- You may want a client-side facility such as psql's \copy. (См. copy.png)
COPY (SELECT row_to_json(t)
FROM
(   SELECT *
    FROM _person) t
)
TO '/Users/anastasia/Desktop/5Сем/Database/lab5/JSON/person.json';

--STEP 2: Выгрузка данных JSON-файла в таблицу
--https://coderoad.ru/39224382/Как-я-могу-импортировать-файл-JSON-в-PostgreSQL
--2.1:
CREATE TABLE IF NOT EXISTS copy_location(
	id INT PRIMARY KEY,
	_location VARCHAR(64) DEFAULT NULL,
	country VARCHAR(64) DEFAULT NULL,
	latitude FLOAT(7) DEFAULT NULL,
	longitude FLOAT(7) DEFAULT NULL
	);
--2.2:
CREATE UNLOGGED TABLE location_import(doc json);
--2.3: \COPY location_import from '/Users/anastasia/Desktop/5Сем/Database/lab5/JSON/location.json'

--2.4:
INSERT INTO copy_location (id, _location, country, latitude, longitude)
SELECT id, _location, country, latitude, longitude
FROM location_import, json_populate_record(null::copy_location, doc);

--json_populate_record(base anyelement, from_json json)
--Разворачивает объект из from_json в табличную строку,
-- в которой столбцы соответствуют типу строки, заданному параметром base

--#3 Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON,
-- или добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

CREATE TABLE IF NOT EXISTS family(
	id SERIAL PRIMARY KEY,
	family json
	);
--DROP TABLE family;

--#1
UPDATE family
SET family = json_object('{relatives, pets}', '{2, 0}');

--#2
CREATE UNLOGGED TABLE family_import(doc json);
--\COPY family_import from '/Users/anastasia/Desktop/5Сем/Database/lab5/JSON/family.json'
INSERT INTO family(family) SELECT * FROM family_import;

--#4 Выполнить следующие действия:

--1. Извлечь JSON фрагмент из JSON документа
--#1
CREATE TYPE myrowtype AS
(
    relatives INT,
    pets INT
);
SELECT relatives, pets
FROM family_import, json_populate_record(null::myrowtype, doc)
WHERE pets > 2;

--#2
SELECT * FROM family;
SELECT family->'relatives' relatives
FROM family;

--2. Извлечь значения конкретных узлов или атрибутов JSON документа
CREATE UNLOGGED TABLE _family(doc jsonb);
INSERT INTO _family(doc) VALUES ('{"relatives": 2, "pets": {"qty": 2, "species": ["cat", "dog"]}}');
INSERT INTO _family(doc) VALUES ('{"relatives": 1, "pets": {"qty": 1, "species": ["bird"]}}');
INSERT INTO _family(doc) VALUES ('{"relatives": 1, "pets": {"qty": 0, "species": []}}');
SELECT * FROM _family;
--DROP TABLE _family;

SELECT doc->'pets'->'species' species
FROM _family;

--3. Выполнить проверку существования узла или атрибута
CREATE OR REPLACE FUNCTION IfAttrExists(json_string json, json_attr text)
RETURNS boolean AS'
BEGIN
    IF (SELECT json_string->json_attr) IS NOT NULL THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
'LANGUAGE plpgsql;

SELECT ifattrexists('{"relatives": 2, "pets": {"qty": 2, "species": ["cat", "dog"]}}','pets');
SELECT ifattrexists('{"relatives": 2, "pets": {"qty": 2, "species": ["cat", "dog"]}}','relatives');
SELECT ifattrexists('{"relatives": 2, "pets": {"qty": 2, "species": ["cat", "dog"]}}','family');

--4. Изменить JSON документ
--https://qna.habr.com/q/505126

UPDATE _family
SET doc = doc || '{"pets": {"qty": 0}}'::jsonb
WHERE (doc->'pets'->'qty')::INT = 0;

--5. Разделить JSON документ на несколько строк по узлам
SELECT * FROM json_array_elements('[{"relatives": 2, "pets": {"qty": 2, "species": ["cat", "dog"]}},
{"relatives": 1, "pets": {"qty": 1, "species": ["bird"]}}]');

--Создаем массив JSON для таблицы _family
INSERT INTO _family(doc) VALUES ('[{"relatives": 1, "pets": {"qty": 1, "species": ["cat"]}},
{"address": "Qwerty23", "phone_number": "81113456767"}]');
INSERT INTO _family(doc) VALUES ('[{"relatives": 0, "pets": {"qty": 1, "species": ["rodent"]}},
{"address": "PolytQwer888", "phone_number": "81119874321"}]');

--Выдает атрибут doc типа jsonb, содержащий массив json, построчно
--для одиноких
WITH IsAlone AS (
    SELECT jsonb_array_elements(doc::jsonb)
    FROM _family
    WHERE (doc->0->'relatives')::INT = 0
)
SELECT *
FROM IsAlone;