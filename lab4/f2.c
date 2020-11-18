#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
//Написать программу по схеме первого задания,
//но в процессе-предке выполнить системный вызов wait().
//Убедиться, что в этом случае идентификатор процесса потомка
//на 1 больше идентификатора процесса-предка.

int main()
{
    int process1, process2;
    int stat_val;
    pid_t child_pid;

    if ((process1 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }

    else if (process1 == 0)
    {
        printf( "Child1: PID = %d, PGID = %d, PPID = %d\n",
        getpid(), getpgrp(), getppid());

        exit(0);
    }

    if ((process2 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    else if (process2 == 0)
    {
        printf( "Child2: PID = %d, PGID = %d, PPID = %d\n",
        getpid(), getpgrp(), getppid());

        exit(0);
    }
    else
    {
        child_pid = wait(&stat_val);
        
        if (WIFEXITED(stat_val))
            printf("Child1 (PID = %d) has terminated normally with code %d\n", child_pid, WEXITSTATUS(stat_val));
        
        if (WEXITSTATUS(stat_val))
            printf("Child1 (PID = %d) has terminated due to the receipt of a signal %d\n that was not caught", child_pid, WTERMSIG(stat_val));
    
        if (WIFSTOPPED(stat_val))
            printf("Child1 (PID = %d) is currently stopped due to the receipt of a signal %d\n", child_pid, WSTOPSIG(stat_val));
        
        child_pid = wait(&stat_val);
        
        if (WIFEXITED(stat_val))
            printf("Child2 (PID = %d) has terminated normally with code %d\n", child_pid, WEXITSTATUS(stat_val));
        
        if (WEXITSTATUS(stat_val))
            printf("Child2 (PID = %d) has terminated due to the receipt of a signal %d\n that was not caught", child_pid, WTERMSIG(stat_val));
    
        if (WIFSTOPPED(stat_val))
        printf("Child2 (PID = %d) is currently stopped due to the receipt of a signal %d\n", child_pid, WSTOPSIG(stat_val));
         
        printf("Parent: PID = %d, PGID = %d, CHILD1 = %d, CHILD2 = %d\n",
        getpid(), getpgrp(), process1, process2);
    }
    return 0;
}
