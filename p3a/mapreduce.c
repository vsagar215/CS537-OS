#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"

// Simplifying fileName reading
struct fileName{
    char *name;
};

// Holding all important data structures
struct Vars{
    MapPair **dict; // dict holding array of KV pairs
    struct fileName names; // Names of the files passed
    int *partitionIter; // keeps track of next entry in partition
    int *numOfPairs; // Number of KVs in a partition
    int *pairAllocPartition;
    int numOfPartitions; // Count of partitions
    int numFilesProc; // Number of files processed by a thread
    int totalFiles; // Total count of files
}vars;

// Creating locks
pthread_mutex_t genLock;
pthread_mutex_t singleFileLock;

// Creating data structure for MR_Run
struct MRVars {
    Mapper map;
    Reducer reduce;
    Getter get_func;
    Partitioner partitioner;
}mrVars;

// List of Functions
void MR_Emit(char *key, char *value);
unsigned long MR_DefaultHashPartition(char *key, int num_partitions);
char *get_func(char *key, int partition_number);
void *map_wrapper(void * ptr);
void *reducer_wrapper(struct MRVars *args);
void MR_Run(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition);
void thread_Mapping(void *arg);

void *reducer_wrapper(struct MRVars *args) {
    return NULL;
}

void MR_Emit(char *key, char *value) {
    // TODO:
}

unsigned long MR_DefaultHashPartition(char *key, int num_partitions) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++) != '\0')
        hash = hash * 33 + c;
    return hash % num_partitions;
}

char *get_func(char *key, int partition_number){
    return NULL;
}

void *map_wrapper(void * ptr) {
    // Mapper mapFunc = ((struct MRVars *) args)->map;
    // char *file_name = ((struct MRVars *) args)->file_name;

    // if(file_name != NULL)
    //     mapFunc(file_name);
    return NULL;
}

void MR_Run(int argc, char *argv[],
                Mapper map, int num_mappers,
                Reducer reduce, int num_reducers,
                Partitioner partition)
{
    /*STEP 1: Initialization*/
    pthread_t mapping_threads[num_mappers];
    //pthread_t reducer_threads[num_reducers];

    /*Init mrVars struct*/
    mrVars.map = map;
    mrVars.reduce = reduce;
    mrVars.partitioner = partition;

    /*Init Vars struct*/
    vars.dict = malloc(num_reducers * sizeof(MapPair *));
    vars.partitionIter  = malloc(num_reducers * sizeof(int));
    vars.numOfPairs = malloc(num_reducers * sizeof(int));
    vars.numOfPartitions = 0;
    vars.numFilesProc = 0;
    vars.totalFiles = argc-1;
    vars.names.name = argv[1]; // TODO: ONLY WORKS FOR 1 FILE


    // TODO: Sorting files RR or SJF?
    // STEP 2: MAP
    for(int i = 0; i < num_mappers; i++)
        pthread_create(&mapping_threads[i], NULL, map_wrapper, NULL);

    for(int i = 0; i < num_mappers; i++)
        pthread_join(mapping_threads[i], NULL);

    // STEP 3: Sort
    // Sort files

    // Sort partitions

    // STEP 4: Reducer

    // STEP 5: Freeing
}
