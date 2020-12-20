#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <sys/shm.h>
#include <stdlib.h>
#include <unistd.h>

#include <pthread.h>
#include <stdio.h>

int delete_segment(int seg_id)
{
    if ((shmctl(seg_id,IPC_RMID,0))==-1)
    {
        printf("ERROR\n");
        return -1;
    }
    else//on success
        return 0;
}

void clean_segments(int startId, int endId)
{
for (int i = startId; i <= endId; ++i)
{
    struct shmid_ds shm_segment;
    int shm_id = shmctl(i, SHM_STAT, &shm_segment);
    delete_segment(shm_id);
    printf("Segment %d has been deleted\n", shm_id);
}
}

int main()
{
    for (int i = 65539; i < 65558; i++)
        shmctl(i, IPC_RMID, NULL);
    
    for (int i = 65540; i < 65551; i++)
        semctl(i, 0, IPC_RMID);
    clean_segments(65539, 65558);
    
    return 0;
}
