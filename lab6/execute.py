#Следует создать новый курсор, вызвав метод cursor().
#Созданный объект курсора можно затем использовать для
#выполнения оператора запроса данных из базы данных SELECT.

#1Выполнить скалярный запрос
#Получить максимальный возраст пациентов среди мужчин
def Task1(cur):
    try:
        cur.execute("SELECT MAX(age) as MaxAge\
                    FROM _person\
                    WHERE gender = 'male'")
        
        rows = cur.fetchone()
        print("MaxAge (male) =", rows[0])

        print("Task1............success!\n\n")
        return
    except:
        print("Task1............fail.\n\n")
        return

    
#2Выполнить запрос с несколькими соединениями (JOIN)
#Для каждого жителя Ухани, в описании симптомов которого
#присутствует слово 'head', получить его возраст, дату проявления симптомов,
#симптом и статус здоровья (если он известен)

def Task2(cur):
    try:
        cur.execute("SELECT P.age AS Age, symptom_onset, name AS symptom, S.progress AS status\
                    FROM _person P\
                    JOIN _status S ON P.id_status = S.id\
                    JOIN person_symptom PS ON PS.id_person = P.id\
                    JOIN _symptom SYMP ON PS.id_symptom = SYMP.id\
                    WHERE P.from_Wuhan = 1 AND SYMP.name LIKE '%head%'\
                    AND S.progress NOT LIKE '%UNKNOWN%'")
        
        rows = cur.fetchall()
        for row in rows:
            print("age =", row[0])
            print("symptom_onset =", row[1])
            print("symptom =", row[2])
            print("status =", row[3], "\n")

        print("Task2............success!\n\n")
        return
    except:
        print("Task2............fail.\n\n")
        return

#3Выполнить запрос с ОТВ(CTE) и оконными функциями
#Получить максимальный средний возраст, позднюю дату начала появления симптомов,
#максимальную широту и максимальную долготу среди обоих полов
def Task3(cur):
    try:
        cur.execute("WITH CTE(gender, AverageAge, EarliestSymptomOnset, MaxLatitude, MaxLongitude)\
                    AS (\
                    SELECT DISTINCT P.gender,\
                    AVG(P.age) OVER (PARTITION BY P.gender) AS AverageAge,\
                    MIN(P.symptom_onset) OVER (PARTITION BY P.gender) AS EarliestSymptomOnset,\
                    MAX(L.latitude) OVER (PARTITION BY P.gender) AS MaxLatitude,\
                    MAX(L.longitude) OVER (PARTITION BY P.gender) AS MaxLongitude\
                    FROM _person P JOIN _location L ON P.id_location = L.id)\
                    SELECT MAX(AverageAge) AS Max_Avg_Age, MAX(EarliestSymptomOnset) AS Later_Symp_Onset,\
                    MAX(MaxLatitude), MAX(MaxLongitude)\
                    FROM CTE")
        
        rows = cur.fetchone()
        print("AverageAge (all) =", rows[0])
        print("EarliestSymptomOnset (all) =", rows[1])
        print("MaxLatitude (all) =", rows[2])
        print("MaxLongitude (all) =", rows[3], "\n")
        

        print("Task3............success!\n\n")
        return
    except:
        print("Task3............fail.\n\n")
        return

#4Выполнить запрос к метаданным
#Выдает тип всех атрибутов таблицы,
#имя которой передано в качестве параметра    
def Task4(cur):

    name = input("Enter the name of the table which columns" +
                " data type you want to know: ")
    
    try:
        cur.execute(f"SELECT data_type\
                    FROM information_schema.columns\
                    WHERE table_name = '{name}'")

        rows = cur.fetchall()
        if not rows:
            print("Table name is wrong!\n\n")
            return
        
        i = 0
        for row in rows:
            print("Column #", i, "data type is", row[0])
            i += 1

        print("Task4............success!\n\n")
        return
    except:
        print("Task4............fail.\n\n")
        return
#5Вызвать скалярную функцию (написанную в третьей лабораторной работе)

#Результатом функции будет строковое значение: страна, в которой
# умерло от коронавирусной инфекции больше всего человек 
def Task5(cur):
    try:
        cur.execute("SELECT get_max_died() AS MaxDied")
        
        rows = cur.fetchone()

        print("Country with max number of people died of infection: ", rows[0], "\n")

        print("Task5............success!\n\n")
        return
    except:
        print("Task5............fail.\n\n")
        return
#6Вызвать многооператорную или табличную функцию (написанную в третьей
#лабораторной работе)

#Результатом функции будет таблица, в которой каждая первая строка
# в каждой группе стран будет содержать самую позднюю дату появления симптомов и
# максимальный возраст пациентов, проживающих в данной стране
def Task6(cur):
    try:
        cur.execute("SELECT * FROM TotalByCountry();")
        
        rows = cur.fetchall()
        row_count = 20
        i = 0
        while row_count:
            print(rows[i])
            row_count -= 1
            i += 1

        print("Task6............success!\n\n")
        return
    except:
        print("Task6............fail.\n\n")
        return

#7Вызвать хранимую процедуру (написанную в третьей лабораторной работе)
#Вызов процедуры, добавляющей новый статус здоровья в таблицу _status
def Task7(cur, con):

    st = input("Enter the status you want to add into <_status> table: ")
    try:
        cur.execute("CALL AddNewStatus(%s)", [st])
        con.commit()

        print("Task7............success!\n\n")
        return
    except:
        print("Task7............fail.\n\n")
        return

#8Вызвать системную функцию или процедуру
#https://postgrespro.ru/docs/postgrespro/10/functions-info
def Task8(cur):
    
    try:
        cur.execute("SELECT current_database()")
        rows = cur.fetchone()
        print("Current database name = ", rows[0])

        cur.execute("SELECT current_user")
        rows = cur.fetchone()
        print("Current user name = ", rows[0])

        print("Task8............success!\n\n")
        return
    except:
        print("Task8............fail.\n\n")
        return

#9Создать таблицу в базе данных, соответствующую тематике БД
#Создатеся таблица, идентифицирующая контакт между людьми
def Task9(cur, con):
    
    try:
        cur.execute("CREATE TABLE IF NOT EXISTS contagious\
                    (id INT NOT NULL PRIMARY KEY,\
                    id_contagious INT,\
                    reporting_date VARCHAR);")
        print("Table created successfully\n")
        con.commit()

    except:
        print("Task9............fail.\n\n")
        return
    print("Task9............success!\n\n")
    return

#10Выполнить вставку данных в созданную таблицу с использованием
#инструкции INSERT или COPY

def Task10(cur, con):

    cur.execute("SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'contagious'")
    if not cur.fetchone():
        print("Table was not created\n")
        return
    
    new_data = list()
    n = int(input("Enter the number of new records in table <contagious>: "))
    print("Enter the records:\n")
    for i in range(n):
        new_data.append(list())
        new_data[i].append(int(input("id = ")))
        new_data[i].append(int(input("id_contagious = ")))
        new_data[i].append(input("reporting_date = "))
        
    try:
        for i in range(n):
            cur.execute("INSERT INTO contagious\
                        (id, id_contagious, reporting_date)\
                        VALUES(%s, %s, %s)", (new_data[i][0],
                        new_data[i][1], new_data[i][2]))
            con.commit()

        print("Records inserted successfully\n")

    except:
        print("Task10............fail.\n\n")
        return
    print("Task10............success!\n\n")
    return
