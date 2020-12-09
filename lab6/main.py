import psycopg2
from menu import Menu

def Main():
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

    Menu(cur, con)
    
    #Метод commit() помогает нам применить изменения, которые мы внесли в БД,
    #и эти изменения не могут быть отменены, если commit() выполнится успешно
    con.commit()

    #Метод close() закрывает соединение с базой данных.
    con.close()

if __name__ == "__main__":
    Main()
