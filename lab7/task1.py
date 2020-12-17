from py_linq import Enumerable
from person import *

# Пример использования метода select:
# students = Enumerable([{'name': 'Joe Smith', 'mark': 80}, {'name': 'Joanne Smith', 'mark': 90}])
# names = students.select(lambda x: x['name'])
# results in ['Joe Smith', 'Joanne Smith']
#В качестве источника данных может выступать объект, реализующий интерфейс IEnumerable


def Query1(patients):
    #Список несовершеннолетних пациентов, отсортированный по дате начала проявления симптомов
    result = patients.where(lambda x: x['age'] < 18).order_by(lambda x: x['symptom_onset']).select(lambda x: {x['id'], x['gender'], x['age'], x['symptom_onset'], x['hosp_visit_date']})
    for i in result:
        print(i)

    # Кортеж, выбранный по следующему принципу: из списка, описанного выше, выбирается первый пациент,
    # посетивший Ухань (из всех пациентов из списка, посещавших Ухань, выбирается тот, у кого симптомы появились раньше остальных)
    
    #result = patients.where(lambda x: x['age'] < 5).first_or_default(lambda x: x['visiting_Wuhan'] == '1')
    #for i in result:
        #print(i, ': ', result[i])

def Query2(patients):
    #Возраст самого старшего пациента женского пола        
    result = patients.where(lambda x: x['gender'] == 'female').max(lambda x: x['age'])
    print('\n', result)

def Query3(patients):
    #Количество пациентов каждого пола (группировка по полу) 
    result = patients.group_by(key_names=['gender'], key=lambda x: x['gender']).select(
        lambda g: { 'key': g.key.gender, 'quantity': g.count()}).to_list()
    for i in range(len(result)):
        print('\n', result[i])

def Query4(patients):
    #Значение True или False в зависимости от условия all(): True, если в каждой группе по полу количество пациентов больше 100
    groups = patients.group_by(key_names=['gender'], key=lambda x: x['gender']).select(
        lambda g: { 'key': g.key.gender, 'quantity': g.count()})
    result = groups.all(lambda x: x['quantity'] > 100)

    print('\n', result)

def Query5(patients):
    #Join

    location = Enumerable([{'id':10, 'country':'Russia'}, {'id':515, 'country':'USA'}, {'id':87, 'country':'China'}])

    result = patients.join(location, lambda s1: s1['id_location'], lambda s2: s2['id'], lambda result: result).to_list()
    for i in range(len(result)):
        print('\n', result[i])


def main():
    patients = Enumerable(get_data("data/person.csv"))

    Query1(patients)
    Query2(patients)
    Query3(patients)
    Query4(patients)
    Query5(patients)


if __name__ == "__main__":
    main()
