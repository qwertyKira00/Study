--Хранимая процедура без параметров или с параметрам
--Процедуры аналогичны конструкциям в других языках программирования,
--поскольку обеспечивают следующее:
-- 1) обрабатывают входные параметры и возвращают вызывающей программе значения в виде выходных параметров;

-- 2) содержат программные инструкции, которые выполняют операции в базе данных, включая вызов других процедур;

-- 3) возвращают значение состояния вызывающей программе,
-- таким образом передавая сведения об успешном или неуспешном завершении (и причины последнего)

--Возвращает индекс статуса "мертв"
CREATE OR REPLACE FUNCTION GetStatus() RETURNS INT AS
$$
    SELECT id
    FROM _status
    WHERE progress = 'DEATH';
$$ LANGUAGE SQL;
--SELECT GetStatus();

--Создание копии таблицы _person для дальнейшей модификации
SELECT *
INTO TEMP person_copy
FROM _person;
--DROP TABLE person_copy;
--SELECT * FROM person_copy;

--Замена текущего статуса пациента на статус "мертв",
--если symptom_onset != hosp_visit_date и возраст больше заданного

CREATE OR REPLACE PROCEDURE ChangeStatus(x int)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
    DECLARE
    st int = GetStatus();
BEGIN
    UPDATE person_copy
    SET id_status = st
    --SELECT GetStatus()
    WHERE symptom_onset != hosp_visit_date
      AND symptom_onset != ''NA''
      AND hosp_visit_date != ''NA''
      AND age > x;
END;';

CALL ChangeStatus(65);
SELECT * FROM person_copy WHERE symptom_onset != hosp_visit_date AND symptom_onset != 'NA'
  AND hosp_visit_date != 'NA' AND age > 65;

--Создание копии таблицы _symptom для дальнейшей модификации
SELECT *
INTO TEMP symptom_copy
FROM _symptom;
--DROP TABLE symptom_copy;

CREATE OR REPLACE FUNCTION CheckIfExists(symptom varchar)
RETURNS _symptom AS
'
SELECT *
FROM symptom_copy
WHERE name = symptom
'LANGUAGE SQL;
SELECT CheckIfExists('hallucinations');

CREATE OR REPLACE PROCEDURE AddDataSymptom(symptom varchar)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
BEGIN

    IF CheckIfExists(symptom) IS NULL THEN
    INSERT INTO symptom_copy (id, name) VALUES (49, symptom);
    END IF;
END';

CALL AddDataSymptom('hallucinations');

SELECT *
FROM symptom_copy;

CREATE TABLE IF NOT EXISTS Fib
(
    N      INT,
    number INt
);
--DROP TABLE Fib;

CREATE OR REPLACE PROCEDURE FibonacciRecTable(prev int, curr int, stop_index int, index int)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
    --DECLARE
    --prev int = 1;
    --curr int = 1;
BEGIN
    IF prev = 1 AND curr = 1 THEN
    INSERT INTO Fib (N, number) VALUES (1, 1);
    INSERT INTO Fib (N, number) VALUES (2, 1);
    END IF;

    IF index <= stop_index THEN
    INSERT INTO Fib (N, number) VALUES (index, curr + prev);
    CALL FibonacciRecTable(curr, prev + curr, stop_index, index + 1);
    END IF;
END';
CALL FibonacciRecTable(1,1,10, 3);
SELECT * FROM Fib;


CREATE OR REPLACE PROCEDURE FibonacciRecINOUT(res INOUT int, stop_index int, prev int = 1, curr int = 1)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
BEGIN
    IF stop_index > 0 THEN
        res = prev + curr;
        CALL FibonacciRecINOUT(res, stop_index - 1, curr, prev + curr);
    END IF;
END';
--DROP PROCEDURE fibonaccirecinout(integer,integer,integer);
CALL FibonacciRecINOUT(0, 10);

--Cursor

SELECT *
INTO TEMP person_copy
FROM _person;
--DROP TABLE person_copy;

SELECT * FROM person_copy;

--Хранимая процедура с использованием курсора
--Замена даты окончания наблюдения на 03/01/2020 у всех выздоровевших пациентов

CREATE OR REPLACE PROCEDURE Cursor()
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
    DECLARE _cursor CURSOR
    FOR SELECT *
    FROM _person P JOIN _status S ON P.id_status = S.id
    WHERE S.progress = ''RECOVERED'';
    row _person;

BEGIN
    OPEN _cursor;
    LOOP
        FETCH _cursor INTO row;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE ''Patient %'', row;
        UPDATE person_copy
        SET exposure_end = ''03/01/2020'';
    END LOOP;
    CLOSE _cursor;

END';
CALL Cursor();

--Хранимая процедура с доступом к метаданным
--INFORMATION_SCHEMA обеспечивает доступ к метаданным о базе данных, информации о сервере MySQL,
-- такой как название базы данных или таблицы, типе данных столбца или привилегиях доступа

--Выдает тип всех атрибутов таблицы, имя которой передано в качестве параметра

CREATE OR REPLACE PROCEDURE GetColumnType(name varchar)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
    DECLARE _cursor CURSOR
    FOR SELECT data_type
    FROM information_schema.columns
    --Информация об information_schema.columns:
    -- https://postgrespro.ru/docs/postgresql/9.6/infoschema-columns
    WHERE table_name = name;
    type record;
    index int = 0;
    --Переменные типа record похожи на переменные строкового типа, но они не имеют предопределённой структуры.
    -- Они приобретают фактическую структуру от строки, которая им присваивается командами SELECT или FOR.
    --Структура переменной типа record может меняться каждый раз при присвоении значения.
BEGIN
    OPEN _cursor;
    LOOP
        FETCH _cursor INTO type;
        EXIT WHEN NOT FOUND;
        index = index + 1;
        RAISE NOTICE ''Column % type is %'', index, type;
    END LOOP;
    CLOSE _cursor;
END';
CALL GetColumnType('_person');

--Выдает названия всех атрибутов таблицы, имя которой передано в качестве параметра

CREATE OR REPLACE PROCEDURE GetColumnName(name varchar)
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
    DECLARE _cursor CURSOR
    FOR SELECT column_name
    FROM information_schema.columns
    --Информация об information_schema.columns:
    -- https://postgrespro.ru/docs/postgresql/9.6/infoschema-columns
    WHERE table_name = name;
    col_name varchar;
    index int = 0;
    --Переменные типа record похожи на переменные строкового типа, но они не имеют предопределённой структуры.
    -- Они приобретают фактическую структуру от строки, которая им присваивается командами SELECT или FOR.
    --Структура переменной типа record может меняться каждый раз при присвоении значения.
BEGIN
    OPEN _cursor;
    LOOP
        FETCH _cursor INTO col_name;
        EXIT WHEN NOT FOUND;
        index = index + 1;
        RAISE NOTICE ''Column % name is %'', index, col_name;
    END LOOP;
    CLOSE _cursor;
END';
CALL GetColumnName('_person');



