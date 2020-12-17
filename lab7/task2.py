from person import _personClass
import json
import psycopg2
row_count = 10

def read_from_json(cur):
    cur.execute("SELECT * FROM person_json")
    print(cur)

    #Массив кортежей, состоящих из одного словаря (тип  Json, хранящий информацию о пациенте)
    rows = cur.fetchmany(row_count)

    patients_array = []
    for row in rows:
        patients_array.append(_personClass(row[0]['id'], row[0]['reporting_date'],
        row[0]['gender'], row[0]['age'], row[0]['symptom_onset'], row[0]['hosp_visit_date'],
        row[0]['exposure_start'], row[0]['exposure_end'], row[0]['visiting_wuhan'],
        row[0]['from_wuhan'], row[0]['id_location'], row[0]['id_status']))

    for i in range(row_count):
        print(patients_array[i])

    return patients_array

def update_json(patients, id):
# У заданного (с помощью id) пациента ключ symptom_onset меняется на "0", если изначально был равен "null" (информация отсутствует)
    for p in patients:
        if p.id == id:
            if p.symptom_onset == 'null':
                p.symptom_onset = '0'         
    for p in patients:
        print(json.dumps(p.GetDict()))

    return patients

def add_record(patients, new_patient):
    patients.append(new_patient)

    for p in patients:
        print(json.dumps(p.GetDict()))
    
def main():
    try:
        con = psycopg2.connect(
          database="postgres",      #Имя базы данных, к которой нужно подключиться
          user="kira",              #Имя пользователя которое будет использоваться для аутентификации
          password="password",      #Пароль базы данных для пользователя
          host="127.0.0.1",         #Адрес сервера базы данных. Например, имя домена, «localhost» или IP-адрес
          port="5432"               #Номер порта. Если вы не предоставите это, будет использоваться значение по умолчанию, а именно 5432
        )
    except:
        print("Database opening error\n")
        return

    print("Database opened successfully\n")

    #Объект cursor используется для фактического выполнения ваших команд
    cur = con.cursor()

    print("Чтение из JSON документа\n")
    patients = read_from_json(cur)

    print("Обновление JSON документа.\n")
    id = int(input("Enter the id of the patient whoose symptom_onset needs to be checked: "))
    patients = update_json(patients, id)

    print("Запись (Добавление) JSON документ.\n")
    new_patient = _personClass(11, '12/17/2020', 'male', 55, '12/14/2020', '12/15/2020', '12/15/2020', 'null', 0, 0, 896, 2)
    patients = add_record(patients, new_patient)


    #Метод close() закрывает соединение с базой данных.
    cur.close()
    con.close()

if __name__ == "__main__":
    main()
