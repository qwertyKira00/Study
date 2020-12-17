class _personClass():
    id = int()
    reporting_date = str()
    gender = str()
    age = int()
    symptom_onset = str()
    hosp_visit_date = str()
    exposure_start = str()
    exposure_end = str()
    visiting_Wuhan = int()
    from_Wuhan = int()
    id_location = int()
    id_status = int()

    def __init__(self, id, reporting_date, gender, age, symptom_onset, hosp_visit_date,
                 exposure_start, exposure_end, visiting_Wuhan, from_Wuhan, id_location, id_status):
        self.id = id
        self.reporting_date = reporting_date
        self.gender = gender
        self.age = age
        self.symptom_onset = symptom_onset
        self.hosp_visit_date = hosp_visit_date
        self.exposure_start = exposure_start
        self.exposure_end = exposure_end
        self.visiting_Wuhan = visiting_Wuhan
        self.from_Wuhan = from_Wuhan
        self.id_location = id_location
        self.id_status = id_status

    def GetDict(self):
        return {'id': self.id, 'reporting_date': self.reporting_date, 'gender': self.gender,
                'age': self.age, 'symptom_onset': self.symptom_onset, 'hosp_visit_date': self.hosp_visit_date,
                'exposure_start': self.exposure_start, 'exposure_end': self.exposure_end, 'visiting_Wuhan': self.visiting_Wuhan,
                'from_Wuhan': self.from_Wuhan, 'id_location': self.id_location, 'id_status': self.id_status}

    def __str__(self):
        return f"{self.id:<5} {self.reporting_date:15} {self.gender:<10} {self.age:<5} {self.symptom_onset:<15} {self.hosp_visit_date:<15} {self.exposure_start:<15} {self.exposure_end:<15} {self.visiting_Wuhan:<5} {self.from_Wuhan:<5} {self.id_location:<5} {self.id_status:<5}"


def get_data(file_name):
    file = open(file_name, 'r')
    _person = list()

    for line in file:
        person_array = line.split(';')

        person_array[0] = int(person_array[0])
        person_array[3] = int(person_array[3])
        person_array[8] = int(person_array[8])
        person_array[9] = int(person_array[9])
        person_array[10] = int(person_array[10])
        person_array[11] = int(person_array[11])

        _person.append(_personClass(*person_array).GetDict())

    return _person
