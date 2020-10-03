from editorial_distance import *
from test import StringGen
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import time
import sys
# LevM, LevR, DLevM, DLevR = [], [], [], []


def PrintGraphAll():

    strlen = [2, 3, 4, 5, 6, 7, 8, 9]

    LevM = [7.279999999998399e-06, 1.2039999999999829e-05, 1.9000000000000126e-05, 2.6659999999998352e-05,
            3.681999999999963e-05, 4.990000000000272e-05, 6.036000000001707e-05, 7.536000000001763e-05]
    LevR = [7.239999999999469e-06, 3.403999999999963e-05, 0.00017670000000000074,
            0.0009067200000000008, 0.004972480000000001, 0.0312771, 0.14374982, 0.78298508]
    DLevM = [7.3800000000012744e-06, 1.2959999999999639e-05, 2.036000000000149e-05, 2.9799999999999826e-05,
             4.4980000000003354e-05, 6.0179999999991906e-05, 6.852000000002079e-05, 8.482000000000766e-05]
    DLevR = [8.03999999999805e-06, 3.770000000000051e-05, 0.0001908199999999982, 0.0010294800000000004,
             0.005750119999999997, 0.030408860000000003, 0.15757221999999999, 0.8673832]

    fig, ax = plt.subplots(figsize=(5, 3))

    # ax.set_title("Time Analysis")  # заголовок
    ax.set_xlabel("Длина строки")  # ось абсцисс
    ax.set_ylabel("Время (сек)")  # ось ординат
    plt.grid()      # включение отображение сетки
    ax.plot(strlen, LevM, label='Левенштейн(м)')
    ax.plot(strlen, LevR, label='Левенштейн(р)')
    ax.plot(strlen, DLevM, label='Дамерау-Левенштейн(м)')
    # построение графика
    ax.plot(strlen, DLevR, label='Дамерау-Левенштейн(р)')

    ax.legend()

    plt.show()


def PrintGraphMatrix():

    strlen = [10, 20, 30, 40, 50, 100, 200]
    LevM = [9.101800000000004e-05, 0.0003420179999999999, 0.0007154980000000002,
            0.0012879599999999999, 0.00206944, 0.0077729500000000016, 0.032426648]
    DLevM = [0.00010464399999999996, 0.000408204, 0.000861694,
             0.0015511920000000003, 0.002423160000000001, 0.009809910000000002, 0.0404802]

    fig, ax = plt.subplots(figsize=(5, 3))

    # ax.set_title("Time Analysis")  # заголовок
    ax.set_xlabel("Длина строки")  # ось абсцисс
    ax.set_ylabel("Время (сек)")  # ось ординат
    plt.grid()      # включение отображение сетки
    ax.plot(strlen, LevM, label='Левенштейн(м)')
    ax.plot(strlen, DLevM, label='Дамерау-Левенштейн(м)')
    # построение графика

    ax.legend()

    plt.show()


def TimeAnalysisAll(iter=50):

    strlen = [2, 3, 4, 5, 6, 7, 8, 9]
    LevM, LevR, DLevM, DLevR = [], [], [], []

    for i in range(len(strlen)):

        str1, str2 = StringGen(strlen[i]), StringGen(strlen[i])

        t_start = time.process_time()
        for _ in range(iter):
            LevenshteinMatrix(str1, str2)
        t_end = time.process_time()
        LevM.append((t_end - t_start) / iter)
        # print("Levenshtein (matrix) = ", t_end - t_start)

        t_start = time.process_time()
        for _ in range(iter):
            LevenshteinRecursion(str1, str2)
        t_end = time.process_time()
        LevR.append((t_end - t_start) / iter)
        # print("Levenshtein (recursion) = ", t_end - t_start)

        t_start = time.process_time()
        for _ in range(iter):
            DamLevenshteinMatrix(str1, str2)
        t_end = time.process_time()
        DLevM.append((t_end - t_start) / iter)
        # print("Damerau-Levenshtein (matrix) = ", t_end - t_start)

        t_start = time.process_time()
        for _ in range(iter):
            DamLevenshteinRecursion(str1, str2)
        t_end = time.process_time()
        DLevR.append((t_end - t_start) / iter)
        # print("Damerau-Levenshtein (recursion) = ", t_end - t_start)
    print(LevM)
    print(LevR)
    print(DLevM)
    print(DLevR)


def TimeAnalysisMatrix(iter=500):
    strlen = [10, 20, 30, 40, 50, 100, 200]
    LevM = []
    DLevM = []

    for i in range(len(strlen)):

        str1, str2 = StringGen(strlen[i]), StringGen(strlen[i])

        t_start = time.process_time()
        for _ in range(iter):
            LevenshteinMatrix(str1, str2)
        t_end = time.process_time()
        LevM.append((t_end - t_start) / iter)

        t_start = time.process_time()
        for _ in range(iter):
            DamLevenshteinMatrix(str1, str2)
        t_end = time.process_time()
        DLevM.append((t_end - t_start) / iter)

    print(LevM)
    print(DLevM)


if __name__ == "__main__":
    PrintGraphMatrix()
