import csv
import random

#file = csv.writer('/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/person_symptom.csv', delimiter = ";")
with open("/Users/anastasia/Desktop/5Сем/DataBase/COVID-19-kaggle/person_symptom.csv", mode="w", encoding='utf-8') as w_file:
    file = csv.writer(w_file, delimiter = ";")
    for i in range (1, 1086):
        file.writerow([str(i), str(random.randint(1, 48))])
