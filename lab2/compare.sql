SELECT DISTINCT P1.gender, P1.age
FROM _person P1 JOIN _person AS P2 ON P2.gender = P1.gender
WHERE P2.id <> P1.id AND P1.from_Wuhan = 0
ORDER BY P1.gender, P1.age