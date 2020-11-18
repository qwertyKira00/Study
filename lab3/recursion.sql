CREATE TABLE IF NOT EXISTS contagious(
    id INT NOT NULL PRIMARY KEY,
    id_contagious INT,
    reporting_date VARCHAR
);
--DROP TABLE contagious;
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(1, 0, '1/18/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(2, 1, '1/20/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(3, 1, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(4, 1, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(5, 2, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(6, 3, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(7, 3, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(8, 4, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(9, 4, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(10, 9, '1/21/2020');

SELECT * FROM contagious;

WITH RECURSIVE RecContagious(id, id_contagious, reporting_date)
AS
(
	--Выбираем человека, для которого требуется вывести
    --список контактирующих
    SELECT id, id_contagious, reporting_date
	FROM contagious
	WHERE id = 4
    UNION ALL
    SELECT C.id, C.id_contagious, C.reporting_date
    FROM contagious C
    JOIN RecContagious on C.id_contagious = RecContagious.id
)
SELECT * FROM RecContagious;

--********************************************Функция (рекурсия)
CREATE OR REPLACE FUNCTION RecFunc (firstId int)
RETURNS TABLE
    (
    id INT,
    id_contagious INT,
    reporting_date VARCHAR
    )
AS '
DECLARE
    x INT;
BEGIN
    RETURN QUERY
    SELECT * FROM contagious C
    WHERE C.id = firstId;
    FOR x IN
        SELECT *
        FROM contagious C
        WHERE C.id_contagious = firstId
        LOOP
            -- RAISE NOTICE ''''ELEM = % '''', elem;
            RETURN QUERY
                SELECT *
                FROM RecFunc(x);
        END LOOP;
END' LANGUAGE plpgsql;

SELECT * FROM RecFunc(4);

--********************************************Процедура (рекурсия)
CREATE OR REPLACE PROCEDURE RecProc
(
    result INOUT INT,
    firstID INT
)
AS '
DECLARE
    x INT;
BEGIN
    result = firstID;
    FOR x IN
        SELECT *
        FROM contagious C
        WHERE C.id_contagious = firstId
        LOOP
            RAISE NOTICE ''Patient = %'', x;
            CALL RecProc(result, x);
        END LOOP;
END;
' LANGUAGE plpgsql;
CALL RecProc(0, 1);