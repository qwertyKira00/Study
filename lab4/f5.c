#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <signal.h>
#define MAXLEN 256

int sig_receipt = 0;

//В программу с программным каналом включить собственный обработчик сигнала.
//Использовать сигнал для изменения хода выполнения программы.

void catch_sig(int sig_numb)
{
    signal(sig_numb, catch_sig);
    printf("\nCTRL-C pressed, caught signal = %d\n", sig_numb);
    sig_receipt = 1;
}

int main()
{
    int process1, process2;
    int stat_val;
    pid_t child_pid;
    
    char str1[] = "Here should be the first text";
    char str2[] = "Here should be the second text";
    
    /* Выставляем реакцию процесса на
    сигнал SIGINT */
    signal(SIGINT, catch_sig);
    
    printf("Press CTRL-C if you want to write messages\n");
    sleep(5);
   
    if (!sig_receipt)
    {
        printf("Exiting...\n");
        sleep(2);
        return 0;
    }
    
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
