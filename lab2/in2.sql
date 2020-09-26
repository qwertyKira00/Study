-- Получить список ВЫЗДОРОВЕВШИХ пациентов, 
-- которые закончили наблюдаться в больнице от '02/01/20' до '02/28/20'

SELECT *
FROM _person
WHERE id_status IN
(
	SELECT id
	FROM _status
	WHERE id = 1
) AND exposure_end BETWEEN '02/01/20' AND '02/28/20'
ORDER BY exposure_end

