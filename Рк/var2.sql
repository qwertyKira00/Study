CREATE TABLE IF NOT EXISTS employee(
	id INT PRIMARY KEY,
	FIO VARCHAR(64) DEFAULT NULL,
	birth_date VARCHAR(64) DEFAULT NULL,
	position VARCHAR(64) DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS exchange_rates(
	id INT PRIMARY KEY,
	currency VARCHAR(64) DEFAULT NULL,
    sale FLOAT DEFAULT NULL,
    purchase FLOAT DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS exchange_operation(
	id INT PRIMARY KEY,
	employee INT,
	FOREIGN KEY (employee) REFERENCES employee(id),
	currency INT,
	FOREIGN KEY (currency) REFERENCES exchange_rates(id),
	sum INT DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS currency_type(
	id INT PRIMARY KEY,
    currency VARCHAR(64) DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS CR(
	id_currency INT,
    FOREIGN KEY (id_currency) REFERENCES exchange_rates(id),
    id_type INT,
    FOREIGN KEY (id_type) REFERENCES currency_type (id)
	);

SELECT e.FIO, er.currency, eo.id as c, eo.sum, ct.currency,
CASE
    WHEN eo.sum >= 1000 and eo.sum <= 10000 and ct.currency = 'сильная'
    OR  ct.currency = 'твердая' THEN '1'
    WHEN eo.sum >= 1000 and eo.sum <= 10000 and ct.currency != 'сильная'
    AND  ct.currency != 'твердая' THEN '3'
    WHEN eo.sum > 10000 and eo.sum <= 100000 THEN '2'
    WHEN eo.sum > 100000 THEN '1'
    ELSE '4'
END AS Priority
FROM employee e JOIN exchange_operation eo ON eo.employee = e.id
JOIN exchange_rates er ON eo.currency = er.id
JOIN CR ON CR.id_currency = er.id
JOIN currency_type ct ON CR.id_type = ct.id;

SELECT e.FIO, er.currency, eo.id as c, eo.sum,
CASE
    WHEN eo.sum >= 1000 and eo.sum <= 10000  THEN '3'
    WHEN eo.sum > 10000 and eo.sum <= 100000 THEN '2'
    WHEN eo.sum > 100000 THEN '1'
    ELSE '4'
END AS Priority
FROM employee e JOIN exchange_operation eo ON eo.employee = e.id
JOIN exchange_rates er ON eo.currency = er.id;

--Выдает количетсво операций определенного типа валют при условии, что
--средння сумма каждой группы операций меньше 50 000
SELECT COUNT(*) as cnt, AVG(sum), ct.currency
FROM exchange_operation eo JOIN exchange_rates er ON eo.currency = er.id
JOIN CR ON CR.id_currency = er.id
JOIN currency_type ct ON CR.id_type = ct.id
GROUP BY ct.currency
HAVING AVG(sum) < 50000;

SELECT *
FROM employee e JOIN exchange_operation eo ON eo.employee = e.id
JOIN exchange_rates er ON eo.currency = er.id
JOIN CR ON CR.id_currency = er.id
JOIN currency_type ct ON CR.id_type = ct.id;

CREATE OR REPLACE FUNCTION get_employees()
RETURNS INTEGER AS
'
    SELECT COUNT(*)
    FROM employee;
' LANGUAGE sql;
SELECT get_employees();

CREATE OR REPLACE FUNCTION get_sum_max()
RETURNS INTEGER AS
'
    SELECT MAX(sum)
    FROM exchange_operation;
' LANGUAGE sql;
SELECT get_sum_max();

CREATE OR REPLACE FUNCTION get_employees_table()
RETURNS TABLE (id int, fio varchar) AS
'
    SELECT id, fio
    FROM employee;
' LANGUAGE sql;
SELECT get_employees_table();


CREATE OR REPLACE PROCEDURE ind(DB_name VARCHAR, table_name VARCHAR)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem IN
        SELECT *
        FROM pg_index JOIN pg_class ON pg_index.indrelid = pg_class.oid
        WHERE relname = table_name
    LOOP
            RAISE NOTICE ''elem = % '', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL ind('RK_var', 'exchange_operation');

--Создать хранимую процедуру с входным параметром,
--которая выводит имена и описания типа объектов
-- (только хранимых процедур и скалярных функций),
-- в тексте которых на языке SQL встречается строка,
-- задаваемая параметром процедуры.
CREATE OR REPLACE PROCEDURE Routines(string VARCHAR)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem IN
        SELECT routine_name, routine_type
        FROM information_schema.routines
        WHERE specific_schema = ''public'' AND (data_type != ''record''
        OR routine_type = ''PROCEDURE'')
        AND routine_definition LIKE CONCAT(''%'', string, ''%'')
    LOOP
            RAISE NOTICE ''elem = % '', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL Routines('SELECT');

CREATE TABLE IF NOT EXISTS employees_train(
	id INT,
	FIO VARCHAR(64) DEFAULT NULL,
	birth_date VARCHAR(64) DEFAULT NULL,
	position VARCHAR(64) DEFAULT NULL
	);

--Создать хранимую процедуру с входным параметром – «имя таблицы»,
--которая удаляет дубликаты записей из указанной таблицы
-- в текущей базе данных. Созданную хранимую процедуру протестировать.

--ctid - Физическое расположение данной версии строки в таблице.
CREATE OR REPLACE PROCEDURE Delete_Duplicate(table_name VARCHAR)
AS '
BEGIN
   EXECUTE ''CREATE TABLE distinct_employees AS
            SELECT DISTINCT *
            FROM '' || table_name;
    EXECUTE ''DROP TABLE employees_train;
            ALTER TABLE distinct_employees TO '' || table_name;
END;
' LANGUAGE plpgsql;

CALL Delete_Duplicate('employees_train')

















CREATE TABLE IF NOT EXISTS work_type(
    id INT PRIMARY KEY,
    name VARCHAR,
    labor_costs INT,
    equipment VARCHAR
);

CREATE TABLE IF NOT EXISTS executor(
    id INT PRIMARY KEY,
    fio VARCHAR,
    birth_date VARCHAR,
    experience INT,
    phone_number VARCHAR
);

CREATE TABLE IF NOT EXISTS customer(
    id INT PRIMARY KEY,
    fio VARCHAR,
    birth_date VARCHAR,
    experience INT,
    phone_number VARCHAR
);

CREATE TABLE IF NOT EXISTS WT_EXEC(
    id_work INT,
    FOREIGN KEY (id_work) REFERENCES work_type(id),
    id_executor INT,
    FOREIGN KEY (id_executor) REFERENCES executor(id)
);

CREATE TABLE IF NOT EXISTS E_C(
    id_executor INT,
    FOREIGN KEY (id_executor) REFERENCES executor(id),
    id_customer INT,
    FOREIGN KEY (id_customer) REFERENCES customer(id)
);

CREATE TABLE IF NOT EXISTS WT_CUST(
    id_work INT,
    FOREIGN KEY (id_work) REFERENCES work_type(id),
    id_customer INT,
    FOREIGN KEY (id_customer) REFERENCES customer(id)
);

SELECT fio
FROM executor E JOIN WT_EXEC ON WT_EXEC.id_executor = E.id
JOIN work_type WT ON WT_EXEC.id_work = WT.id;

--[Предикат сравнения] Получить список исполнителей, чей стаж работы больше 2
SELECT *
FROM executor
WHERE experience > 2;

--[Оконная функция] Получить таблицу с дополнительным
--атрибутом MAX_LAB_Costs, который содержит
-- максимальные трудозатраты
--для определенной группы изделия (группировка по имени работы)
SELECT name,
       labor_costs,
       MAX(labor_costs) OVER (PARTITION BY name) AS MAX_LAB_Costs,
       equipment
FROM work_type


CREATE OR REPLACE PROCEDURE ind(DB_name VARCHAR, table_name VARCHAR)
AS '
DECLARE
    elem RECORD;
BEGIN
    FOR elem IN
        SELECT *
        FROM pg_index JOIN pg_class ON pg_index.indrelid = pg_class.oid
        WHERE relname = table_name
    LOOP
            RAISE NOTICE ''elem = % '', elem;
    END LOOP;
END;
' LANGUAGE plpgsql;

CALL ind('RK_var', 'exchange_operation');

