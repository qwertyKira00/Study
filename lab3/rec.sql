CREATE TABLE IF NOT EXISTS contagious(
    id INT PRIMARY KEY,
    id_contagious INT,
    FOREIGN KEY (id_contagious) REFERENCES contagious(id),
    reporting_date VARCHAR
);
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(2, 1, '1/20/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(3, 1, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(4, 1, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(5, 2, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(6, 3, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(7, 3, '1/21/2020');
INSERT INTO contagious(id, id_contagious, reporting_date) VALUES(8, 4, '1/21/2020');

SELECT * FROM contagious;

WITH CTE(gender, MaxAge)
AS
(
	SELECT gender, MAX(age) AS age
	FROM _person
	WHERE gender <> 'NA' AND age > 0
	GROUP BY gender
)
SELECT MAX(MaxAge) AS 'Максимальный возраст среди пациентов обоих полов'
FROM CTE