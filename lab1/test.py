import string
import random
from editorial_distance import *
from sys import getsizeof
n = 0


def StringGen(strlen):
    l = string.ascii_lowercase
    return ''.join(random.choice(l) for i in range(strlen))


def EmptyString(func):
    strlen = int(input("Enter the string length: "))
    s = StringGen(strlen)

    if func == LevenshteinMatrix or func == DamLevenshteinMatrix:
        mtr = func(s, "")
        return int(mtr[len(mtr) - 1][len(mtr[len(mtr) - 1]) - 1] == len(s))
    dist = func(s, "")
    return int(dist == len(s))


def EqualStrings(func):
    strlen = int(input("Enter the string length: "))
    s = StringGen(strlen)

    if func == LevenshteinMatrix or func == DamLevenshteinMatrix:
        mtr = func(s, s)
        return int(mtr[len(mtr) - 1][len(mtr[len(mtr) - 1]) - 1] == 0)
    dist = func(s, s)
    return int(dist == 0)


def PrintRes(flag):
    global n

    n += 1
    if flag:
        print("\033[0m{:<}    ".format(n) +
              "\033[32m\033[01m{:<}\n".format(" √"))
        print("\033[0m")
    else:
        print("\033[0m{:<}    ".format(n) +
              "\033[31m\033[01m{:<}\n".format(" -"))
        print("\033[0m")


def cmp_Lev_matrix_recursion():

    print("\033[33m{:<}\n".format(
        "*****Levenshtein distance (matrix/recursion)*****"))
    print("\033[0m")

    t = int(input("Enter the number of tests: "))

    for i in range(t):
        count = 0

        strlen = int(input("Enter the string length: "))
        str1, str2 = StringGen(strlen), StringGen(strlen)
        mtr, dist = LevenshteinMatrix(
            str1, str2), LevenshteinRecursion(str1, str2)
        count += int(mtr[len(mtr) - 1][len(mtr[len(mtr) - 1]) - 1] == dist)
        PrintRes(count)


def cmp_DamLev_matrix_recursion():

    print("\033[33m{:<}\n".format(
        "*****Damerau-Levenshtein distance (matrix/recursion)*****"))
    print("\033[0m")

    t = int(input("Enter the number of tests: "))

    for i in range(t):
        count = 0

        strlen = int(input("Enter the string length: "))
        str1, str2 = StringGen(strlen), StringGen(strlen)
        mtr, dist = DamLevenshteinMatrix(
            str1, str2), DamLevenshteinRecursion(str1, str2)
        count += int(mtr[len(mtr) - 1][len(mtr[len(mtr) - 1]) - 1] == dist)
        PrintRes(count)


def test_empty_string():
    print("\033[33m{:<}\n".format(
        "*****Empty string: Levenshtein distance (matrix)*****"))
    print("\033[0m")
    count = EmptyString(LevenshteinMatrix)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Empty string: Levenshtein distance (recursion)*****"))
    print("\033[0m")
    count = EmptyString(LevenshteinRecursion)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Empty string: Damerau-Levenshtein distance (matrix)*****"))
    print("\033[0m")
    count = EmptyString(DamLevenshteinMatrix)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Empty string: Damerau-Levenshtein distance (recursion)*****"))
    print("\033[0m")
    count = EmptyString(DamLevenshteinRecursion)
    PrintRes(count)


def test_equal_strings():
    print("\033[33m{:<}\n".format(
        "*****Equal strings: Levenshtein distance (matrix)*****"))
    print("\033[0m")
    count = EqualStrings(LevenshteinMatrix)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Equal strings: Levenshtein distance (recursion)*****"))
    print("\033[0m")
    count = EqualStrings(LevenshteinRecursion)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Equal strings: Damerau-Levenshtein distance (matrix)*****"))
    print("\033[0m")
    count = EqualStrings(DamLevenshteinMatrix)
    PrintRes(count)

    print("\033[33m{:<}\n".format(
        "*****Equal strings: Damerau-Levenshtein distance (recursion)*****"))
    print("\033[0m")
    count = EqualStrings(DamLevenshteinRecursion)
    PrintRes(count)


def test_memory():
    str1, str2 = input(), input()
    LevenshteinRecursion(str1, str2)


def Test():

    cmp_Lev_matrix_recursion()
    cmp_DamLev_matrix_recursion()
    test_empty_string()
    test_equal_strings()


if __name__ == "__main__":
    Test()
