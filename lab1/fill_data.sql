SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE '/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/person.csv' 
INTO TABLE _person
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/location.csv' 
INTO TABLE _location
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/symptom.csv' 
INTO TABLE _symptom
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/status.csv' 
INTO TABLE _status
FIELDS TERMINATED BY ';' 
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/person_symptom.csv'
INTO TABLE person_symptom
FIELDS TERMINATED BY ';';