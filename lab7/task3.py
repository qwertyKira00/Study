#https://habr.com/ru/post/322086/
#http://docs.peewee-orm.com

from peewee import *

# Создаем соединение с базой данных
con = PostgresqlDatabase(
    database='postgres',
    user='kira',
    password='password',
    host='127.0.0.1', 
    port="5432"
)

# Определяем базовую модель о которой будут наследоваться остальные
class BaseModel(Model):
    class Meta:
        database = con #соединение с базой, из шаблона выше


class Person(BaseModel):
    id = IntegerField(column_name='id')
    reporting_date = CharField(column_name='reporting_date')
    gender = IntegerField(column_name='gender')
    age = IntegerField(column_name='age')
    symptom_onset = CharField(column_name='symptom_onset')
    hosp_visit_date = CharField(column_name='hosp_visit_date')
    exposure_start = CharField(column_name='exposure_start')
    exposure_end = CharField(column_name='exposure_end')
    id_location = IntegerField(column_name='id_location')
    id_status = IntegerField(column_name='id_status')
    
    class Meta:
        table_name = '_person'


class Location(BaseModel):
    id = IntegerField(column_name='id')
    _location = CharField(column_name='_location')
    country = CharField(column_name='country')
    latitude = FloatField(column_name='latitude')
    longitude = FloatField(column_name='longitude')

    class Meta:
        table_name = '_location'

class Symptom(BaseModel):
    id = IntegerField(column_name='id')
    name = CharField(column_name='name')
	
    class Meta:
        table_name = '_symptom'

class Status(BaseModel):
    id = IntegerField(column_name='id')
    progress = CharField(column_name='progress')
	
    class Meta:
        table_name = '_status'

class Person_Symptom(BaseModel):
    id_person = ForeignKeyField(Person, backref='id_person')
    id_symptom = ForeignKeyField(Symptom, backref='id_symptom')

    class Meta:
        table_name = 'person_symptom'

def Query1():
    # 1. Однотабличный запрос на выборку.
    global con 
   
    print("Однотабличный запрос на выборку")
    '''print(p.id, p.reporting_date, p.gender, p.age, p.symptom_onset, p.hosp_visit_date,
    p.exposure_start, p.exposure_end, p.visiting_Wuhan, p.from_Wuhan, p.id_location, p.id_status)
'''
    query = Symptom.select().where(Symptom.name == "cough")
    print("Запрос на симптом с названием cough:")
    print(query)

    #Выполнение запроса
    symptom = query.dicts().execute()
    for s in symptom:
        print(s)

    query = Person.select(Person.age, Person.symptom_onset).where(Person.gender == 'female' and Person.age >= 65).limit(10)
    print("\nЗапрос на первых 10 пациентов женского пола старше 65:")
    print(query)

    #Выполнение запроса
    patient_list = query.dicts().execute()
    for p in patient_list:
        print(p)

def Query2():
    #Многотабличный запрос на выборку
    global con

    print("Многотабличный запрос на выборку")
    
    query = Person.select(Person.id, Location.country).join(Location, on=(Person.id_location == Location.id)).limit(10)
    print("\nЗапрос на первых 10 пациентов, выдающий информацию об их стране проживания:")

    patients_location = query.dicts().execute()

    for p in patients_location:
        print(p)

def PrintSymptom():
    query = Symptom.select().limit(10).order_by(Symptom.id.desc())

    for s in query.dicts().execute():
        print(s)

def AddSymptom(n_id, n_name):
    global con 
	
    try:
        with con.atomic() as txn:
            Symptom.create(id=n_id, name=n_name)
            print("Symptom was successfully added!\n")
    except:
        print("Symptom was not added...\n")
        txn.rollback()

def UpdateSymptom(s_id, new_symp_name):
    symptom = Symptom.get(Symptom.id == s_id)

    symptom.name = new_symp_name
    symptom.save()	

    print("Symptom was successfully updated!\n")

def DeleteSymptom(s_id):
    symptom = Symptom.get(Symptom.id == s_id)
    symptom.delete_instance()

    print("Symptom was successfully deleted!\n")

def Query3():
    #Три запроса на добавление, изменение и удаление данных в базе данных:

    print("Три запроса на добавление, изменение и удаление данных в базе данных")

    print("Initial table:")
    PrintSymptom()

    print("\nAdd")
    AddSymptom(49, 'hallucinations')
    PrintSymptom()

    print("\nUpdate")
    UpdateSymptom(49, 'cough')
    PrintSymptom()

    print("\nDelete")
    DeleteSymptom(49)
    PrintSymptom()

def Query4():
    #Получение доступа к данным, выполняя только хранимую процедуру

    global con 
    
    cursor = con.cursor()

    print("Получение доступа к данным, выполняя только хранимую процедуру")

    AddSymptom(49, 'hallucinations')

    print("Initial table:")
    PrintSymptom()

    cursor.execute("CALL UpdateSymptom();")
	
    con.commit()

    print("\nAfter procedure was executed:")
    PrintSymptom()

    
    DeleteSymptom(49)
    cursor.close()
    
def main():
	global con 

	Query1()
	Query2()
	Query3()
	Query4()

	con.close()

if __name__ == "__main__":
    main()    
