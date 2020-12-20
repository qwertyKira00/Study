#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <unistd.h>

#include <pthread.h>
#include <stdio.h>

#define WHITE "\033[0m"
#define GREEN "\033[0;32m"

#define WRITERS 5
#define READERS 3
#define FLG 0

#define AW 0 //active_writer (logical)
#define AR 1 //active_readers
#define QW 2 //writers_queue
#define QR 3 //readers_queue

#define D -1 //decrement
#define I 1 //increment
#define W 0 //wait (sleep()) while semaphore is not 0

struct sembuf start_read[5] = {
    {QR, I, FLG},   //readers_queue + 1 (увеличение очереди читателей)
    {QW, W, FLG},   //ожидание, пока writers_queue не станет равным 0
    {AW, W, FLG},   //ожидание, пока active_writer не станет равным 0
    {QR, D, FLG},   //readers_queue - 1 (уменьшение очереди читателей)
    {AR, I, FLG}};  //active_readers + 1 (увеличение кол-ва активных читателей
struct sembuf stop_read[1] = {{AR, D, FLG}};
struct sembuf start_write[5] = {
    {QW, I, FLG},  //writers_queue + 1 (увеличение очереди писателей)
    {AR, W, FLG},  //ожидание, пока active_readers не станет равным 0
    {AW, W, FLG},  //ожидание, пока active_writer не станет равным 0
    {AW, I, FLG},  //active_writer = 1
    {QW, D, FLG}   //writers_queue - 1 (уменьшение очереди писателей)
};
struct sembuf stop_write[1] = {{AW, D, FLG}}; //active_writer = 0

int *addr = NULL;

void Reader(const int semid, const int id)
{
    int process;
    if ((process = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    
    else if (process == 0)
    {
        while(1)
        {
            if (semop(semid, start_read, 5) == -1)
            {
                perror("Reader's semop failed (couldn't enter the critical zone)\n");
                exit(1);
            }
            
            printf("%sReader(child process) with id = %d (PID = %d) read %d\n", WHITE, id, getpid(), *addr);
            
            if (semop(semid, stop_read, 1) == -1)
            {
                perror("Reader's semop failed (couldn't escape the critical zone)\n");
                exit(1);
            }
            sleep(1);
        }
        exit(0);
    }
}

void Writer(const int semid, const int id)
{
    int process;
    if ((process = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    
    else if (process == 0)
    {
        while(1)
        {
            if (semop(semid, start_write, 5) == -1)
            {
                perror("Writer's semop failed (couldn't enter the critical zone)\n");
                exit(1);
            }
            
            (*addr)++;
            printf("%sWriter(child process) with id = %d (PID = %d) wrote %d\n", GREEN, id, getpid(), *addr);
            
            if (semop(semid, stop_write, 1) == -1)
            {
                perror("Writer's semop failed (couldn't escape the critical zone)\n");
                exit(1);
            }
            sleep(2);
        }
        exit(0);
    }
}

int main()
{
    printf("Parent: PID = %d\n", getpid());

    int shm_perms = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
    int fd = shmget(IPC_PRIVATE, sizeof(int), shm_perms);
    if (fd == -1)
    {
        perror("New shared memory segment could not be created\n");
        return 1;
    }

    addr = shmat(fd, NULL, 0);
    if ((char *)addr == (char*) -1)
    {
        perror("Shared memory segment could not be attached to the address space of the calling process\n");
        return 1;
    }
    
    *addr = 0;

    int sem_perms = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
    int semid = semget(IPC_PRIVATE, 4, IPC_CREAT | IPC_EXCL | sem_perms);
    if (semid == -1)
    {
        perror("New semaphore set could not be created\n");
        return 1;
    }
    
    for (int i = 0; i < WRITERS; i++)
        Writer(semid, i);
    
    for (int i = 0; i < READERS; i++)
    Reader(semid, i);
    
    int status;

    for (int i = 0; i < WRITERS + READERS; i++)
        wait(&status);
   
    if (shmdt(addr) == -1)
        perror("Shared memory segment could not be detached from the address space of the calling process\n");
    return 0;

}

