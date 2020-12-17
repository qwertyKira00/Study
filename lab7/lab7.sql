CREATE OR REPLACE PROCEDURE UpdateSymptom()
LANGUAGE plpgsql
SECURITY DEFINER
AS
'
BEGIN
    UPDATE _symptom
    SET name = ''cough''
    WHERE _symptom.id = 49;
END';

CALL UpdateSymptom(49);