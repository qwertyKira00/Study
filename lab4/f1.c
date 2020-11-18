#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//Написать программу, запускающую не мене двух новых процессов
//системным вызовом fork().
//В предке вывести
//собственный идентификатор (функция getpid()),
//идентификатор группы ( функция getpgrp())
//и идентификаторы потомков.

//В процессе-потомке вывести собственный идентификатор,
//идентификатор предка (функция getppid()) и идентификатор группы.
//Убедиться, что при завершении процесса-предка потомок,
//который продолжает выполняться, получает идентификатор предка (PPID),
//равный 1 или идентификатор процесса-посредника.

int main()
{
    int process1;
    if ((process1 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }

    else if (process1 == 0)
    {
        //Код первого процесса-потомка
        sleep(3);
        printf("Child1: PID = %d, PGID = %d, PPID = %d\n",
        getpid(), getpgrp(), getppid());

        exit(0);
    }


    int process2;
    if ((process2 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    else if (process2 == 0)
    {
        //Код второго процесса-потомка
        sleep(3);
        printf("Child2: PID = %d, PGID = %d, PPID = %d\n",
        getpid(), getpgrp(), getppid());

        exit(0);
    }
    else
    {
    //Код процесса-потомка
    printf("Parent: PID = %d, PGID = %d, CHILD1 = %d, CHILD2 = %d\n",
        getpid(), getpgrp(), process1, process2);
    }
    return 0;
}
