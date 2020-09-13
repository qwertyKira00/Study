CREATE TABLE IF NOT EXISTS _person(
	id INT(5) AUTO_INCREMENT PRIMARY KEY, 
	reporting_date VARCHAR(64) DEFAULT NULL, 
	gender VARCHAR(64) DEFAULT NULL,
	age INTEGER CHECK (age >= 0 and age <= 110) DEFAULT NULL, 
	symptom_onset VARCHAR(64) DEFAULT NULL, 
	hosp_visit_date VARCHAR(64) DEFAULT NULL, 
	exposure_start VARCHAR(64) DEFAULT NULL, 
	exposure_end VARCHAR(64) DEFAULT NULL, 
	visiting_Wuhan INTEGER CHECK (visiting_Wuhan >= 0 and visiting_Wuhan <= 1) DEFAULT NULL,
	from_Wuhan INTEGER CHECK (from_Wuhan >= 0 and from_Wuhan <= 1) DEFAULT NULL,
	id_location INT,
	FOREIGN KEY (id_location) REFERENCES _location(id),
	id_status INT,
	FOREIGN KEY (id_status) REFERENCES _status(id)
	);

CREATE TABLE IF NOT EXISTS _location(
	id INT(5) AUTO_INCREMENT PRIMARY KEY, 
	_location VARCHAR(64) DEFAULT NULL, 
	country VARCHAR(64) DEFAULT NULL,
	latitude FLOAT(7) DEFAULT NULL,
	longitude FLOAT(7) DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS _symptom(
	id INT(2) AUTO_INCREMENT PRIMARY KEY, 
	name CHAR(7) DEFAULT NULL 
	);

CREATE TABLE IF NOT EXISTS _status(
	id INT(1) AUTO_INCREMENT PRIMARY KEY, 
	progress VARCHAR(10) DEFAULT NULL
	);

CREATE TABLE IF NOT EXISTS person_symptom
(
	id_person INT,
	FOREIGN KEY (id_person) REFERENCES _person(id),
	id_symptom INT,
	FOREIGN KEY (id_symptom) REFERENCES _symptom(id)
);