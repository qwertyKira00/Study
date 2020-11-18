#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#define MAXLEN 256

//Написать программу, в которой предок и потомок
//обмениваются сообщением через программный канал.
//Программные каналы имеют встроенные средства взаимоисключения —
//массив файловых дескрипторов: из канала нельзя читать,
//если в него пишут, и в канал нельзя писать, если из него читают

//[0] - выход для чтения
//[1] - выход для записи

int main()
{
    int process1, process2;
    int stat_val;
    pid_t child_pid;
    
    char str1[] = "Here should be the first text";
    char str2[] = "Here should be the second text";
    
    int fd[2];
    if (pipe(fd) == -1)
    {
        perror("Can\'t pipe.\n");
        exit(1);
    }

    if ((process1 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }

    else if (process1 == 0)
    {
         /* Child process closes up input side of pipe */
        close(fd[0]);
        write(fd[1], str1, (strlen(str1) + 1));
        
        exit(0);
    }

    if ((process2 = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    else if (process2 == 0)
    {
        
         /* Child process closes up input side of pipe */
        close(fd[0]);
        write(fd[1], str2, (strlen(str2) + 1));
        
        exit(0);
    }
    else
    {
        /* Parent process closes up output side of pipe */
        close(fd[1]);
        
        char str1[MAXLEN];
        /* Read in a string from the pipe */
        read(fd[0], str1, MAXLEN);

        char str2[MAXLEN];
        /* Read in a string from the pipe */
        read(fd[0], str2, MAXLEN);

        printf("String1 = %s, String2 = %s", str1, str2);
        
        child_pid = wait(&stat_val);
        
        if (WIFEXITED(stat_val))
            printf("\n\nChild1 (PID = %d) has terminated normally with code %d", child_pid, WEXITSTATUS(stat_val));
        
        if (WEXITSTATUS(stat_val))
            printf("\nChild1 (PID = %d) has terminated due to the receipt of a signal %d that was not caught", child_pid, WTERMSIG(stat_val));
    
        if (WIFSTOPPED(stat_val))
            printf("\nChild1 (PID = %d) is currently stopped due to the receipt of a signal %d", child_pid, WSTOPSIG(stat_val));
        
        child_pid = wait(&stat_val);
        
        if (WIFEXITED(stat_val))
            printf("\nChild2 (PID = %d) has terminated normally with code %d", child_pid, WEXITSTATUS(stat_val));
        
        if (WEXITSTATUS(stat_val))
            printf("\nChild2 (PID = %d) has terminated due to the receipt of a signal %d that was not caught", child_pid, WTERMSIG(stat_val));
    
        if (WIFSTOPPED(stat_val))
        printf("\nChild2 (PID = %d) is currently stopped due to the receipt of a signal %d", child_pid, WSTOPSIG(stat_val));
         
        printf("\nParent: PID = %d, PGID = %d, CHILD1 = %d, CHILD2 = %d\n",
        getpid(), getpgrp(), process1, process2);
    }
    return 0;
}


