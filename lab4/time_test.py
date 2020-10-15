import matplotlib.pyplot as plt
import time


def PrintGraphAll():

    Threads = [1, 2, 4, 8, 16, 32]

    MtrDimension = [32, 64, 96, 128, 160, 192]

    ParallelRow1 = [0.3119, 0.1691, 0.1169, 0.0995, 0.147, 0.1222]

    ParallelRow2 = [0.0995, 0.1741, 0.2541, 0.3532, 0.4634, 0.5759]

    ParallelCol1 = [0.1858, 0.131, 0.0814, 0.0604, 0.067, 0.0813]

    ParallelCol2 = [0.0525, 0.136, 0.1951, 0.2399, 0.2977, 0.3661]
           
    StandMultRow = [0.3119, 0.3119, 0.3119, 0.3119, 0.3119, 0.3119]

    StandMultCol = [0.1858, 0.1858, 0.1858, 0.1858, 0.1858, 0.1858]

    fig, ax = plt.subplots(figsize=(5, 3))
    plt.xticks(Threads)
    
    # ax.set_title("Time Analysis")  # заголовок
    ax.set_xlabel("Количество строк")  # ось абсцисс
    ax.set_ylabel("Время (сек)")  # ось ординат
    plt.grid()      # включение отображение сетки
    #ax.plot(MtrDimension, ParallelRow2, label='Распараллеливание по строкам')
    #ax.scatter(MtrDimension, ParallelRow2, c='red')
    
    ax.plot(MtrDimension, ParallelCol2, label='Распараллеливание по столбцам')
    ax.scatter(MtrDimension, ParallelCol2, c='red')
    #ax.plot(Threads, StandMultCol, label='Однопоточный алгоритм умножения')
    #ax.scatter(Threads, StandMultCol, c='red')
    # построение графика
    

    ax.legend()

    plt.show()

if __name__ == "__main__":
    PrintGraphAll()

