from random import randint
from time_test import *
import numpy as np

def CreateMatrix(n, m):
    return [[int(j) for j in input().split()] for i in range(n)]

def CreateMatrixRandom(n, m):
    return [[randint(0, 100) for j in range(m)] for i in range(n)]

def PrintMatrix(mtr, n, m):
    for i in range(n):
        for j in range(m):
            print('{:<}'.format(mtr[i][j]), end='    ')
        print('\n')


def StandMultMatrix(mtr1, mtr2, n1, m1, n2, m2):
    if m1 != n2:
        return False
    res_mtr = [np.full(m2, 0) for i in range(n1)]
    for i in range(n1):
        for j in range(m2):
            for q in range(m1):
                res_mtr[i][j] = res_mtr[i][j] + mtr1[i][q] * mtr2[q][j]
    return res_mtr


'''def WinogradMult1(mtr1, mtr2, n1, m1, n2, m2):
    if m1 != n2:
        return False
    res_mtr = []

    rowFactor = []
    d = int(m1 / 2)

    for i in range(n1):
        rowFactor.append(mtr1[i][0] * mtr1[i][1])
        for j in range(1, d):
            rowFactor[i] = rowFactor[i] + mtr1[i][2 * j] * mtr1[i][2 * j + 1]

    columnFactor = []
    for i in range(m2):
        columnFactor.append(mtr2[0][i] * mtr2[1][i])
        for j in range(1, d):
            columnFactor[i] = columnFactor[i] + mtr2[2 * j][i] * mtr2[2 * j + 1][i]

    for i in range(n1):
        res_mtr.append([])
        for j in range(m2):
            res_mtr[i].append(-rowFactor[i] - columnFactor[j])
            for k in range(d):
                res_mtr[i][j] = res_mtr[i][j] + (mtr1[i][2 * k] +
                mtr2[2 * k + 1][j]) * (mtr1[i][2 * k + 1] + mtr2[2 * k][j])
    if 2 * (m1 / 2) != m1:
        for i in range(n1):
            for j in range(m2):
                res_mtr[i][j] = res_mtr[i][j] + mtr1[i][m1] * mtr2[m1][j]

    return res_mtr'''

def WinogradMult(mtr1, mtr2, n1, m1, n2, m2):
    if m1 != n2:
        return False
    res_mtr = [np.full(m2, 0) for i in range(n1)]
    d = m1

    #rowFactor = np.full(n1, 0)
    rowFactor = [0 for i in range(n1)]
    for i in range(n1):
        for j in range(1, d, 2):
            rowFactor[i] += mtr1[i][j - 1] * mtr1[i][j]

    #columnFactor = np.full(m2, 0)
    columnFactor = [0 for i in range(m2)]
    for i in range(m2):
        for j in range(1, d, 2):
            columnFactor[i] += mtr2[j - 1][i] * mtr2[j][i]

    for i in range(n1):
        for j in range(m2):
            res_mtr[i][j] = -rowFactor[i] - columnFactor[j]
            for k in range(1, d, 2):
                res_mtr[i][j] += (mtr1[i][k - 1] +
                mtr2[k][j]) * (mtr1[i][k] + mtr2[k - 1][j])
    if d % 1:
        for i in range(n1):
            for j in range(m2):
                res_mtr[i][j] += mtr1[i][d - 1] * mtr2[d - 1][j]

    return res_mtr

def WinogradOptimization(mtr1, mtr2, n1, m1, n2, m2):
    if m1 != n2:
        return False
    res_mtr = [np.full(m2, 0) for i in range(n1)]
    d = m1
    
    #Optimization: stop using numpy methods
    rowFactor = [0 for i in range(n1)]
    for i in range(n1):
        for j in range(1, d, 2):
            rowFactor[i] += mtr1[i][j - 1] * mtr1[i][j]

    columnFactor = [0 for i in range(m2)]
    for i in range(m2):
        for j in range(1, d, 2):
            columnFactor[i] += mtr2[j - 1][i] * mtr2[j][i]

    #Optimization: buffer (stop frequent memory cell access request)
    for i in range(n1):
        for j in range(m2):
            buffer = -rowFactor[i] - columnFactor[j]
            for k in range(1, d, 2):
                buffer += (mtr1[i][k - 1] +
                mtr2[k][j]) * (mtr1[i][k] + mtr2[k - 1][j])
            res_mtr[i][j] = buffer
    #Optimization: bit operation & (and) instead of %
    if d & 1:
        for i in range(n1):
            for j in range(m2):
                res_mtr[i][j] += mtr1[i][d - 1] * mtr2[d - 1][j]

    return res_mtr

def TaskMan():
    n1, m1 = map(int, input(
        'Введите размерность первой матрицы через пробел: ').split())
    n2, m2 = map(
        int, input('Введите размерность второй матрицы через пробел: ').split())
    print('Введите матрицу №1:\n')
    mtr1 = CreateMatrix(n1, m1)
    print('Введите матрицу №2:\n')
    mtr2 = CreateMatrix(n2, m2)

    print('Матрица №1:\n')
    PrintMatrix(mtr1, n1, m1)

    print('Матрица №2:\n')
    PrintMatrix(mtr2, n2, m2)

    res_mtr = StandMultMatrix(mtr1, mtr2, n1, m1, n2, m2)
    if not res_mtr:
        print('Матрицы нельзя перемножить (число столбцов первой матрицы не совпадает с числом строк второй матрицы)\n')
    else:
        print('Результирующая матрица:\n')
        PrintMatrix(res_mtr, n1, m2)

    res_mtr = WinogradMult(mtr1, mtr2, n1, m1, n2, m2)
    if not res_mtr:
        print('Матрицы нельзя перемножить (число столбцов первой матрицы не совпадает с числом строк второй матрицы)\n')
    else:
        print('Результирующая матрица:\n')
        PrintMatrix(res_mtr, n1, m2)

    res_mtr = WinogradOptimization(mtr1, mtr2, n1, m1, n2, m2)
    if not res_mtr:
        print('Матрицы нельзя перемножить (число столбцов первой матрицы не совпадает с числом строк второй матрицы)\n')
    else:
        print('Результирующая матрица:\n')
        PrintMatrix(res_mtr, n1, m2)


if __name__ == "__main__":
    TaskMan()
