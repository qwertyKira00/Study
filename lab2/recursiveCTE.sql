-- Степень числа 2
WITH RECURSIVE 2POW(n) AS
(
	SELECT 1
	UNION ALL
	SELECT n + (SELECT n) FROM 2POW
	WHERE n < 100
)
SELECT n FROM 2POW;

TODO
-- with recursive cte (id, gender, id_status) as (
-- select id, gender, id_status
-- from _person 
-- where id_status = 1
-- union all
-- select p.id, p.gender, p.id_status
-- from _person P
-- join cte on p.id_status = cte.id
-- )
-- select * from cte;
