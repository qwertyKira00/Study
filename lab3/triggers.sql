--********************************************AFTER
SELECT *
INTO TEMP person_copy
FROM _person;
--DROP TABLE person_copy;
--SELECT * FROM person_copy;

CREATE TABLE IF NOT EXISTS log
(
  message varchar,
  added varchar
);
--DROP TABLE log;

CREATE OR REPLACE FUNCTION history() RETURNS TRIGGER AS $$
DECLARE
    msg varchar;
    id varchar;
BEGIN
    IF TG_OP = 'INSERT' THEN
        id = NEW.id;
        msg = 'Add new patient #';
        INSERT INTO log(message,added) values (msg || id, NOW());
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        id = NEW.id;
        msg = 'Update patient #';
        INSERT INTO log(message,added) values (msg || id,NOW());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        id = OLD.id;
        msg = 'Delete patient #';
        INSERT INTO log(message,added) values (msg || id, NOW());
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

--Триггер After, срабатывающий на любые изменения в таблице
--(DELETE, UPDATE, INSERT). Вызывается функция history(),
--которая записыает историю изменений таблицы
CREATE TRIGGER log_person
AFTER INSERT OR UPDATE OR DELETE ON person_copy
FOR EACH ROW
EXECUTE PROCEDURE history();

--TEST AFTER
DELETE FROM person_copy
WHERE id = 3;

SELECT *
FROM log;

--********************************************INSTEAD OF

CREATE VIEW fib_view AS
SELECT *
FROM fib;
--DROP view fib_view;

CREATE OR REPLACE FUNCTION ResetNumber() RETURNS TRIGGER
LANGUAGE plpgsql
AS
'
BEGIN
    UPDATE fib_view
    SET number = tg_argv[0]::INTEGER
    WHERE n = OLD.n;
    RETURN OLD;
END;
';

CREATE TRIGGER DelLocation
    INSTEAD OF DELETE ON fib_view
    FOR EACH ROW
    EXECUTE PROCEDURE ResetNumber(100);

DELETE FROM fib_view
WHERE n = 2;

SELECT *
FROM fib_view
--WHERE n = 2;
--TODO:Спросить про Foreign Key(применение)
--********************************************Запрет на добавление строки в таблицу
--Если BEFORE триггер уровня строки возвращает NULL,
-- то все дальнейшие действия с этой строкой прекращаются
-- (т. е. не срабатывают последующие триггеры,
-- команда INSERT/UPDATE/DELETE для этой строки не выполняется).
-- Если возвращается не NULL,
-- то дальнейшая обработка продолжается именно с этой строкой.
SELECT *
INTO TEMP status_copy
FROM _status;
--DROP TABLE status_copy;
--SELECT * FROM status_copy;

CREATE OR REPLACE FUNCTION ProhibitionRow() RETURNS TRIGGER
LANGUAGE plpgsql
AS
'
BEGIN
    RETURN NULL;
END;
';

CREATE TRIGGER InsertROWProhibition
BEFORE INSERT ON status_copy
FOR EACH ROW
EXECUTE PROCEDURE ProhibitionRow();
--DROP TRIGGER InsertROWProhibition ON status_copy;

INSERT INTO status_copy(id, progress) VALUES (4, 'Relapse');

SELECT *
FROM status_copy;

--********************************************Запрет на добавление (уровень БД)
--Событиями DDL прежде всего являются инструкциям CREATE, ALTER, DROP
-- и вызовы некоторых системных хранимых процедур, которые выполняют схожие операции.
--В ответ на событие из области действия сервера или базы данных.
SELECT *
INTO TEMP status_copy
FROM _status;
--DROP TABLE status_copy;
--SELECT * FROM status_copy;

CREATE OR REPLACE FUNCTION ProhibitionCreateTable() RETURNS event_trigger
LANGUAGE plpgsql
AS
'
BEGIN
    --RAISE EXCEPTION ''Добавление новых таблиц в базу данных запрещено!''
        --USING HINT = ''Воспользуйтесь уже существующей таблицей или создайте временную таблицу'';
    --RETURN NULL;
END;
';


CREATE EVENT TRIGGER no_create_allowed
  ON ddl_command_end WHEN TAG IN ('CREATE TABLE')
  EXECUTE PROCEDURE ProhibitionCreateTable();
--Можно разорвать соединение
CREATE TABLE _relatives(id INT, age INT, gender VARCHAR);
--DROP EVENT TRIGGER IF EXISTS no_create_allowed CASCADE;

--The ddl_command_start event occurs just before the execution of a CREATE, ALTER, or DROP command.
-- No check whether the affected object exists or doesn't exist
-- is performed before the event trigger fires.
-- ddl_command_start also occurs just before the execution of a SELECT INTO command,
-- since this is equivalent to CREATE TABLE AS.

--The ddl_command_end event occurs just after the execution of this same set of commands.


