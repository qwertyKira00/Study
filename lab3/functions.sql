CREATE FUNCTION get_max_died() RETURNS VARCHAR AS
'   WITH CTE(country, DiedPatientsQuantity)
    AS
    (
        SELECT LS.country, COUNT(*) AS DiedPatientsQuantity
    FROM (
        SELECT P.id, L.country
        FROM _person P JOIN _location AS L ON P.id_location = L.id
        WHERE P.id_status = 3 ) AS LS
    GROUP BY LS.country
    )
    SELECT country
    FROM CTE
    WHERE DiedPatientsQuantity =
        (SELECT MAX(DiedPatientsQuantity)
          FROM CTE);
' LANGUAGE SQL;

SELECT get_max_died() as MaxDied;
--drop function get_max_died();

CREATE FUNCTION MaleByAge(x int) RETURNS _person AS
$$
    SELECT *
    FROM _person
    WHERE gender = 'male' AND age <= x;
$$ LANGUAGE SQL;

--Вернет кортеж
SELECT MaleByAge(18);

--Вернет все атрибуты первого кортежа, где пациент мужского пола
-- и его возраст <= 18
SELECT *
FROM MaleByAge(18);
--drop function MaleByAge();

CREATE OR REPLACE FUNCTION AllMalesByAge(x int, y int) RETURNS TABLE
(
    id int,
    age int,
    reporting_date varchar,
    symptom_onset varchar
)
AS
$$
    SELECT id, age AS AgeGroup1, reporting_date, symptom_onset
    FROM _person
    WHERE gender = 'male' AND age <= x
    UNION SELECT id, age AS AgeGroup2, reporting_date, symptom_onset
    FROM _person
    WHERE gender = 'male' AND age > x AND age <= y;
$$LANGUAGE SQL;

SELECT *
FROM AllMalesByAge(18, 30);
--Добавить операторы (например, разделить на два блока)

-- RETURN QUERY не выполняет возврат из функции. Они просто добавляют строки в результирующее множество.
-- Затем выполнение продолжается со следующего оператора в функции.
-- Успешное выполнение RETURN QUERY формирует множество строк результата.
-- Для выхода из функции используется RETURN, обязательно без аргументов (или можно просто дождаться окончания выполнения функции).

CREATE OR REPLACE FUNCTION Fibonacci (index int, stop_index int, x int, y int)
RETURNS TABLE (Fib int)
AS '
BEGIN
    RETURN QUERY SELECT x;
    IF index < stop_index THEN
        RETURN QUERY
        SELECT *
        FROM Fibonacci(index + 1, stop_index, y, x + y);
    END if;
END' LANGUAGE plpgsql;
select * from Fibonacci(1, 10, 1, 1);
--На свою БД

CREATE OR REPLACE FUNCTION Fibonacci_Loop(stop_index int)
RETURNS TABLE (Fib int)
LANGUAGE plpgsql
AS '
    DECLARE
    x int = 1;
    y int = 1;
    tmp int;
BEGIN
    RETURN QUERY SELECT x;
    RETURN QUERY SELECT y;
    FOR index in 3..stop_index LOOP
        RETURN QUERY SELECT x + y;
        tmp = x;
        x = y;
        y = tmp + y;
    END LOOP;
END;';
SELECT * FROM Fibonacci_Loop(10);