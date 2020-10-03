import matplotlib.pyplot as plt
import time
from sort import *

def TimeAnalysis(iter = 100):

    ArrDimension = [5, 10, 15, 20]
    Arrays = [[1, 3, 2, 4, 5], [10, 9, 8, 7, 6, 5, 1, 2, 3, 4],
              [10, 1, 3, 2, 4, 5, 6, 8, 7, 9, 12, 11, 15, 13, 14],
              [1, 2, 3, 4, 5, 10, 9, 8, 7, 6, 5, 11, 13, 12, 14, 15, 20,
               19, 16, 18, 17]]
    #Arrays = [[1, 3, 2, 4, 5], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              #[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
             # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
              # 18, 19, 20]]
    #Arrays = [[5, 4, 3, 2, 1], [10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
              #[15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
              #[20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]]
       
    Bubble, Ins, Quick = [], [], []

    for i in range(0, len(ArrDimension)):

        n = ArrDimension[i]
        arr = Arrays[i]
        #PrintArray(arr, n)

        t_start = time.process_time()
        for _ in range(iter):
            BubbleSort(arr, n)
        t_end = time.process_time()
        Bubble.append((t_end - t_start) / iter)

        t_start = time.process_time()
        for _ in range(iter):
            InsertSort(arr, n)
        t_end = time.process_time()
        Ins.append((t_end - t_start) / iter)

        t_start = time.process_time()
        for _ in range(iter):
            QuickSort(arr, n)
        t_end = time.process_time()
        Quick.append((t_end - t_start) / iter)

    print(Bubble)
    print('\n')
    print(Ins)
    print('\n')
    print(Quick)

    PrintGraphAll(Bubble, Ins, Quick)

def PrintGraphAll(Bubble, Ins, Quick):

    ArrDimension = [5, 10, 15, 20]

    Bubble = [3.030000000000532e-06, 1.0419999999999873e-05, 1.850999999999936e-05, 3.209999999999935e-05]

    Ins = [9.999999999998898e-07, 2.0399999999998195e-06, 2.40000000000018e-06, 3.130000000000077e-06]

           
    Quick = [3.3300000000002773e-06, 7.4800000000008195e-06, 1.1109999999999731e-05, 1.677999999999957e-05]

    fig, ax = plt.subplots(figsize=(5, 3))

    # ax.set_title("Time Analysis")  # заголовок
    ax.set_xlabel("Размерность")  # ось абсцисс
    ax.set_ylabel("Время (сек)")  # ось ординат
    plt.grid()      # включение отображение сетки
    ax.plot(ArrDimension, Bubble, label='Сортировки"пузырьком')
    ax.plot(ArrDimension, Ins, label='Сортировка вставками')
    ax.plot(ArrDimension, Quick, label='Быстрая сортировка')
    # построение графика
    

    ax.legend()

    plt.show()


        
