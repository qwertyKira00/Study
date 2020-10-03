from random import randint
from time_test import *
import numpy as np

def CreateArray(n):
    arr = []
    for i in range(n):
        arr.append(int(input()))
    return arr

def CreateArrayRandom(n):
    return [randint(0, 100) for i in range(n)]

def PrintArray(arr, n):
    for i in range(n):
        print('{:<}'.format(arr[i]), end=' ')
    print('\n')

def BubbleSort(arr, n):
    for i in range(n - 1):
        for j in range(n - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
        #PrintArray(arr, n)
    return arr

def InsertSort(arr, n):
    for i in range(1, n):
        j = i - 1 
        key = arr[i]
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    #PrintArray(arr, n)
    return arr

######QuickSort######

def Partition(arr, low, high):  
    # Выбираем средний элемент в качестве опорного
    # Также возможен выбор первого, последнего
    # или произвольного элементов в качестве опорного
    pivot = arr[(low + high) // 2]
    i = low - 1
    j = high + 1
    while True:
        i += 1
        while arr[i] < pivot:
            i += 1

        j -= 1
        while arr[j] > pivot:
            j -= 1

        if i >= j:
            return j

        # Если элемент с индексом i (слева от опорного) больше, чем
        # элемент с индексом j (справа от опорного), меняем их местами
        arr[i], arr[j] = arr[j], arr[i]

# Создадим вспомогательную функцию, которая вызывается рекурсивно
def QuickSortRecursive(items, low, high):
        if low < high:
            #Индекс после опорного элемента
            split_index = Partition(items, low, high)
            QuickSortRecursive(items, low, split_index)
            QuickSortRecursive(items, split_index + 1, high)

def QuickSort(arr, n):  

    QuickSortRecursive(arr, 0, n - 1)
    #PrintArray(arr, n)

    return arr
    
######QuickSort######

def TaskMan():
    n = int(input('Введите размер масисва: '))

    print('Введите элементы массива: \n')
    arr = CreateArray(n)
   
    arr1 = BubbleSort(arr, n)
    arr2 = InsertSort(arr, n)
    arr3 = QuickSort(arr, n)

if __name__ == "__main__":
    TimeAnalysis(100)
