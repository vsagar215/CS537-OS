#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"


struct args_struct {
    Mapper map;
    char *file_name;
};

void MR_Emit(char *key, char *value) {

}

unsigned long MR_DefaultHashPartition(char *key, int num_partitions) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++) != '\0')
        hash = hash * 33 + c;
    return hash % num_partitions;
}

void *thread_wrapper(void *args) {
    Mapper mapFunc = ((struct args_struct *) args)->map;
    char *file_name = ((struct args_struct *) args)->file_name;
    mapFunc(file_name);
    return NULL;
}

void MR_Run(int argc, char *argv[],
        	    Mapper map, int num_mappers,
	            Reducer reduce, int num_reducers,
	            Partitioner partition)
{
    pthread_t threads[num_mappers];
    //args.map = map;

    /*Create num_mapper threads to handle the mapping*/
    for (int i = 1; i < argc; i++) {
        struct args_struct args;
        args.map = map;
        args.file_name = argv[i];
        pthread_create(&threads[i], NULL, thread_wrapper, &args);
    }


    /*Wait on the threads*/
    for (int i = 1; i < argc; i++)
        pthread_join(threads[i], NULL);
}
