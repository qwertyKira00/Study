#include <windows.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>

#define WHITE "\033[0m"
#define GREEN "\033[0;32m"

#define WRITERS 5
#define READERS 3
#define ITERATIONS_NUMBER 100
#define HANDLE_ERROR 1
#define THREAD_ERROR 2

HANDLE CanWrite;
HANDLE CanRead;
HANDLE MUTEX;
LONG SHARED_RESOURCE = 0;

bool active_writer = false;
LONG active_readers = 0;
LONG writers_queue = 0;  //quantity of writers waiting for CanWrite
LONG readers_queue = 0;  //quantity of readers waiting for CanRead

HANDLE writerThreads[WRITERS], readerThreads[READERS];
int writerID[WRITERS], readerID[READERS];
int value = 0;

void Start_Write()
{
    InterlockedIncrement(&writers_queue);
    
    if (active_readers > 0 || active_writer)
        WaitForSingleObject(CanWrite, INFINITE);
    
    InterlockedDecrement(&writers_queue);
    active_writer = true;
}

void Stop_Write()
{
  
    active_writer = false;
    
    if (WaitForSingleObject(CanRead, 0) != WAIT_OBJECT_0)
        SetEvent(CanRead);
    else
        SetEvent(CanWrite);
}

DWORD WINAPI Write(LPVOID Id)
{
    int id = *(int *)Id;
    
    for (int i = 0; i < ITERATIONS_NUMBER; i++)
    {
        int delay = rand() % 200;
        
        Start_Write();
        value++;
        printf("%sWriter with id = %d wrote %d. Delay = %d\n", GREEN, id, value, delay);
        Stop_Write();

        Sleep(delay);
    }
}

void Start_Read()
{
  
    InterlockedIncrement(&readers_queue);
  
    if (active_writer || WaitForSingleObject(CanWrite, 0) == WAIT_OBJECT_0)
        WaitForSingleObject(CanRead, INFINITE);
    
    WaitForSingleObject(MUTEX, INFINITE);
    
    InterlockedDecrement(&readers_queue);
    InterlockedIncrement(&active_readers);
    SetEvent(CanRead);
    
    ReleaseMutex(MUTEX);
}

void Stop_Read()
{
    InterlockedDecrement(&active_readers);
  
    if (active_readers == 0)
        SetEvent(CanWrite);
}

DWORD WINAPI Read(LPVOID Id)
{
    int id = *(int *)Id;
    
    for (int i = 0; i < ITERATIONS_NUMBER; i++)
    {
        int delay = rand() % 200;
        
        Start_Read();
        printf("%sReader with id = %d read %d. Delay = %d\n", WHITE, id, value, delay);
        Stop_Read();
        
        Sleep(delay);
    }
}

int Create_Threads()
{
    DWORD id = 0; //thread id
    
    for (int i = 0; i < WRITERS; i++)
    {
        writerID[i] = i;
        if (!(writerThreads[i] = CreateThread(NULL, 0, &Write, writerID + i, 0, &id)))
            return THREAD_ERROR;
    }

    for (int i = 0; i < READERS; i++)
    {
        readerID[i] = i;
        if (!(readerThreads[i] = CreateThread(NULL, 0, &Read, readerID + i, 0, &id)))
            return THREAD_ERROR;
    }
    return 0;
}


int main()
{
    setbuf(stdout, NULL);
    srand(time(NULL));
    
    // 2ой аргумент == FALSE значит мьютекс свободный.
    if (!(MUTEX = CreateMutex(NULL, FALSE, NULL)))
        return HANDLE_ERROR;
    // 2ой аргумент == FALSE значит автоматический сброс.
    // 3ий аргумент == FALSE значит, что объект не в сигнальном состоянии.
    if (!(CanWrite = CreateEvent(NULL, FALSE, FALSE, NULL)))
        return HANDLE_ERROR;
    if (!(CanRead = CreateEvent(NULL, FALSE, FALSE, NULL)))
        return HANDLE_ERROR;
    
    if (Create_Threads() == THREAD_ERROR)
        return THREAD_ERROR;
  
    WaitForMultipleObjects(WRITERS, writerThreads, TRUE, INFINITE);
    WaitForMultipleObjects(READERS, readerThreads, TRUE, INFINITE);
    
    for (int i = 0; i < WRITERS; i++)
        CloseHandle(writerThreads[i]);

    for (int i = 0; i < READERS; i++)
        CloseHandle(readerThreads[i]);

    CloseHandle(CanWrite);
    CloseHandle(CanRead);
    CloseHandle(MUTEX);
    
  return 0;
}
