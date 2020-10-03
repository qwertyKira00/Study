import matplotlib.pyplot as plt
import time
from matrix import *

def TimeAnalysis(iter = 100):

    MtrDimension = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    MtrNM = [[5, 2], [2, 5], [2, 10], [10, 2], [3, 10], [10, 3],
             [4, 10], [10, 4], [5, 10], [10, 5],
             [6, 10], [10, 6], [7, 10], [10, 7], [8, 10], [10, 8],
             [9, 10], [10, 9], [10, 10], [10, 10]]
    #MtrDimension = [10, 20]
    #MtrNM = [[2, 5], [5, 2], [4, 5], [5, 4]]
    Stand, Win, WinOpt = [], [], []

    for i in range(0, len(MtrNM), 2):

        n1, m1 = MtrNM[i][0], MtrNM[i][1]
        n2, m2 = MtrNM[i + 1][0], MtrNM[i + 1][1]
        mtr1 = CreateMatrixRandom(n1, m1)
        #PrintMatrix(mtr1, n1, m1)
        mtr2 = CreateMatrixRandom(n2, m2)
        #PrintMatrix(mtr2, n2, m2)

        t_start = time.process_time()
        for _ in range(iter):
            StandMultMatrix(mtr1, mtr2, n1, m1, n2, m2)
        t_end = time.process_time()
        Stand.append((t_end - t_start) / iter)

        t_start = time.process_time()
        for _ in range(iter):
            WinogradMult(mtr1, mtr2, n1, m1, n2, m2)
        t_end = time.process_time()
        Win.append((t_end - t_start) / iter)

        t_start = time.process_time()
        for _ in range(iter):
            WinogradOptimization(mtr1, mtr2, n1, m1, n2, m2)
        t_end = time.process_time()
        WinOpt.append((t_end - t_start) / iter)

    print(Stand)
    print('\n')
    print(Win)
    print('\n')
    print(WinOpt)

    PrintGraphAll(Stand, Win, WinOpt)

def PrintGraphAll(Stand, Win, WinOpt):

    MtrDimension = [20, 30, 40, 50, 60, 70, 80, 90, 100]

    Stand = [3.6490000000000133e-05, 7.278000000000007e-05,
             0.00012365999999999988, 0.0001880599999999999, 0.0002652900000000003,
             0.00035358, 0.00044519000000000085, 0.0005672600000000005,
             0.0006748299999999996]

    Win = [3.306000000000031e-05, 6.666999999999978e-05,
           9.894999999999987e-05, 0.0001438700000000004, 0.00020148000000000054,
           0.0002633699999999994, 0.00033620000000000096, 0.0004162500000000002,
           0.0005135699999999988]

           
    WinOpt = [2.6800000000000157e-05, 4.040000000000043e-05,
              6.19600000000009e-05, 8.92599999999999e-05, 0.00011889999999999956,
              0.00015573999999999978, 0.00018542999999999977, 0.00022216000000000014,
              0.0002653099999999986]

    fig, ax = plt.subplots(figsize=(5, 3))

    # ax.set_title("Time Analysis")  # заголовок
    ax.set_xlabel("Размерность")  # ось абсцисс
    ax.set_ylabel("Время (сек)")  # ось ординат
    plt.grid()      # включение отображение сетки
    ax.plot(MtrDimension, Stand, label='Стандартный алгоритм')
    ax.plot(MtrDimension, Win, label='Алгоритм Винограда')
    ax.plot(MtrDimension, WinOpt, label='Алгоритм Винограда (оптимизации)')
    # построение графика
    

    ax.legend()

    plt.show()


        
