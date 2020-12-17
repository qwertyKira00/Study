COPY (SELECT row_to_json(t) FROM(SELECT * FROM _person) t)
TO '/Users/anastasia/Desktop/5Сем/Database/lab5/JSON/person1.json';

CREATE UNLOGGED TABLE person_json(doc json);
--\COPY person_json from '/Users/anastasia/Desktop/5Сем/Database/lab5/JSON/person1.json'
