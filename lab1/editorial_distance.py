# - * -coding: utf - 8 - * -
from sys import getsizeof
count = 0


def Menu():
    s1 = "Choose the method:"
    s2 = "1 - Levenshtein distance by matrix"
    s3 = "2 - Levenshtein distance by recursion"
    s4 = "3 - Damerau-Levenshtein distance by matrix"
    s5 = "4 - Damerau-Levenshtein distance by recursion"
    s6 = "Press 0 for exit"
    print("\n{:<}\n{:<}\n{:<}\n{:<}\n{:<}\n{:<}".format(s1, s2, s3, s4, s5, s6))


def LevenshteinMatrix(str1, str2):
    n = len(str1) + 1
    m = len(str2) + 1
    mtr = [[(i + j) for j in range(m)] for i in range(n)]

    for i in range(1, n):
        for j in range(1, m):
            mtr[i][j] = min(mtr[i - 1][j] + 1, mtr[i][j - 1] + 1,
                            mtr[i - 1][j - 1] + int(str1[i - 1] != str2[j - 1]))
    return mtr


def DamLevenshteinMatrix(str1, str2):
    n = len(str1) + 1
    m = len(str2) + 1
    mtr = [[(i + j) for j in range(m)] for i in range(n)]

    for i in range(1, n):
        for j in range(1, m):
            mtr[i][j] = min(mtr[i - 1][j] + 1, mtr[i][j - 1] + 1,
                            mtr[i - 1][j - 1] + int(str1[i - 1] != str2[j - 1]))
            if i > 1 and j > 1 and str1[i - 1] == str2[j - 2] and str1[i - 2] == str2[j - 1]:
                mtr[i][j] = min(mtr[i][j], mtr[i - 2][j - 2] + 1)

    return mtr


def LevenshteinRecursion(str1, str2):

    if not str1:
        return len(str2)
    if not str2:
        return len(str1)

    return min(LevenshteinRecursion(str1, str2[:-1]) + 1,
               LevenshteinRecursion(str1[:-1], str2) + 1,
               LevenshteinRecursion(str1[:-1], str2[:-1]) + int(str1[-1] != str2[-1]))


def DamLevenshteinRecursion(str1, str2):
    if not str1:
        return len(str2)
    if not str2:
        return len(str1)

    dist = min(DamLevenshteinRecursion(str1, str2[:-1]) + 1,
               DamLevenshteinRecursion(str1[:-1], str2) + 1,
               DamLevenshteinRecursion(str1[:-1], str2[:-1]) + int(str1[-1] != str2[-1]))
    if (len(str1) >= 2 and len(str2) >= 2 and str1[-1] == str2[-2] and str1[-2] == str2[-1]):
        dist = min(dist, DamLevenshteinRecursion(str1[:-2], str2[:-2]) + 1)
    return dist


def PrintMatrix(mtr, str1, str2):
    n, m = len(str1), len(str2)

    if not str2:
        print("  ø  ")

    for i in range(m + 1):
        if not i:
            print("{:>6}".format("ø"), end="")
        else:
            print("{:>6}".format(str2[i - 1]), end="")

    for i in range(n + 1):
        if not i:
            print("\nø", end="    ")
        else:
            print("\n" + "{:<5}".format(str1[i - 1]), end="")
        for j in range(m + 1):
            print("{:<6}".format(mtr[i][j]), end="")
    print("\n")

    print("Editorial distance (matrix) = ", mtr[n][m])


def ReadString(str1, str2):
    str1 = input("Enter the 1st string: ")
    str2 = input("Enter the 2nd string: ")
    return str1, str2


def PrintDist(func, str1, str2):
    result = func(str1, str2)
    if func == LevenshteinMatrix or func == DamLevenshteinMatrix:
        PrintMatrix(result, str1, str2)
    else:
        print("\nEditorial distance (recursion) = {:<}\n".format(result))


def TaskMan():
    str1, str2 = '', ''
    str1, str2 = ReadString(str1, str2)
    func = [LevenshteinMatrix, LevenshteinRecursion,
            DamLevenshteinMatrix, DamLevenshteinRecursion]

    Menu()

    choice = int(input())
    while choice:
        PrintDist(func[choice - 1], str1, str2)
        Menu()
        choice = int(input())


if __name__ == "__main__":
    TaskMan()
