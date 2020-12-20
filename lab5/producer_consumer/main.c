#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <unistd.h>

#include <pthread.h>
#include <stdio.h>

#define N 24 //buffer size
#define LETTERS "abcdefghijklmnopqrstuvwxyz"
#define OBJECT_QTY 1
#define PROC_COUNT 3

#define BS 0 //bin_sem
#define BF 1 //buffer_full
#define BE 2 //buffer_empty

#define P -1
#define V 1

struct sembuf producerStart[2] = {{BE, P, 0}, {BS, P, 0}};
struct sembuf producerStop [2] = {{BS, V, 0}, {BF, V, 0}};
struct sembuf consumerStart[2] = {{BF, P, 0}, {BS, P, 0}};
struct sembuf consumerStop [2] = {{BS, V, 0}, {BE, V, 0}};

int *prod_pos = NULL;
int *cons_pos = NULL;
char *buff_pos = NULL;

const int size = sizeof(int) * 2 + sizeof(char) * N;

void ProducerRoutine(const int semid, const int prod_id)
{
    //Random delays
    sleep(rand() % 3);
    
    if (semop(semid, producerStart, 2) == -1)
    {
        perror("Producer's semop failed (couldn't enter the critical zone)\n");
        exit(1);
    }
    printf("Producer with id = %d is in the critical zone\n", prod_id);
    
    buff_pos[*prod_pos] = LETTERS[*prod_pos];
    
    printf("Producer with id = %d posed at %d produced %c\n", prod_id, *prod_pos, buff_pos[*prod_pos]);
    (*prod_pos)++;
    
    if (semop(semid, producerStop, 2) == -1)
    {
        perror("Producer's semop failed (couldn't escape the critical zone)\n");
        exit(1);
    }
}

void ConsumerRoutine(const int semid, const int cons_id)
{
    //Random delays
    sleep(rand() % 3);
    
    if (semop(semid, consumerStart, 2) == -1)
    {
        perror("Consumer's semop failed (couldn't enter the critical zone)\n");
        exit(1);
    }
    
    printf("Consumer with id = %d posed at %d consumed %c\n", cons_id, *cons_pos, buff_pos[*cons_pos]);
    (*cons_pos)++;

    if (semop(semid, consumerStop, 2) == -1)
    {
        perror("Consumer's semop failed (couldn't escape the critical zone)\n");
        exit(1);
    }
}

void ProducerCreation(const int semid, const int id)
{
    int process;
    if ((process = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    
    else if (process == 0)
    {
        printf("Producer(child process) with id = %d (PID = %d) was created\n", id, getpid());
        
        ProducerRoutine(semid, id);
    
        printf("Producer with id = %d executed\n\n", id);
        exit(0);
    }
}

void ConsumerCreation(const int semid, const int id)
{
    int process;
    if ((process = fork()) == -1)
    {
        perror("Can\'t fork.\n");
        exit(1);
    }
    
    else if (process == 0)
    {
        printf("Consumer(child process) with id = %d (PID = %d) was created\n", id, getpid());
    
        ConsumerRoutine(semid, id);

        printf("Consumer with id = %d executed\n\n", id);
        exit(0);
    }
}

int main()
{
    srand(time(NULL));
    
    printf("Parent: PID = %d\n", getpid());
    
    int shm_perms = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
    int fd = shmget(IPC_PRIVATE, size, shm_perms);
    if (fd == -1)
    {
        perror("New shared memory segment could not be created\n");
        return 1;
    }
    // Прототип shmat: void *shmat(int shmid, const void *shmaddr, int shmflg);
    //Если значение shmaddr равно NULL, то система выбирает подходящий(неиспользуемый)
    //адрес для подключения сегмента.
    //addr - указатель на разделяемый сегмент памяти
    int *addr = shmat(fd, NULL, 0);
    if ((char *)addr == (char*) -1)
    {
        perror("Shared memory segment could not be attached to the address space of the calling process\n");
        return 1;
    }
    
    prod_pos = addr;
    cons_pos = addr + sizeof(int);
    buff_pos = (char *)(addr + sizeof(int) * 2);
    
    *prod_pos = 0;
    *cons_pos = 0;

    //Создание набора из 3-х семафоров, значение идентификатора которого
    //являестя макрос IPC_PRIVATE (что охначает, что создается набор семафоров, который
    //смогут использовать только процессы, порожденные процессом, создавшим семафор)
    //sem_perms содержит права доступа к набору семафоров
    int sem_perms = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
    int semid = semget(IPC_PRIVATE, 3, IPC_CREAT | IPC_EXCL | sem_perms);
    if (semid == -1)
    {
        perror("New semaphore set could not be created\n");
        return 1;
    }
    
    int init_BS = semctl(semid, BS, SETVAL, 1);
    if (init_BS == -1)
    {
        perror("SETVAL command could not be applied to semaphore BS\n");
        return 1;
    }

    int init_BF = semctl(semid, BF, SETVAL, 0);
    if (init_BF == -1)
    {
        perror("SETVAL command could not be applied to semaphore BF\n");
        return 1;
    }

    int init_BE = semctl(semid, BE, SETVAL, N);
    if (init_BE == -1)
    {
        perror("SETVAL command could not be applied to semaphore BE\n");
        return 1;
    }

    for (int i = 0; i < PROC_COUNT; i++)
    {
        ProducerCreation(semid, i);
        ConsumerCreation(semid, i);
    }
    
    int status;
    for (int i = 0; i < PROC_COUNT * 2; i++)
        wait(&status);
    
    if (shmdt(addr) == -1)
        perror("Shared memory segment could not be detached from the address space of the calling process\n");
    return 0;

}

