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
char *get_next(char *key, int partition_number);
void *map_wrapper(void * ptr);
void *reducer_wrapper(void *args);
void MR_Run(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition);
void thread_Mapping(void *arg);
int pair_helper(const void *pair1, const void *pair2);
int file_helper(const void *file1, const void *file2);

int file_helper(const void *file1, const void *file2){
    // (vars.names*) file1;
    // int s1 = fseek(fp1, 0L, SEEK_END);
    // int s2 = fseek(fp2, 0L, SEEK_END);
    // fclose(fp1);
    // fclose(fp2);
    // return (s1 - s2);
    return 0;
}

int pair_helper(const void *pair1, const void *pair2){

    MapPair *u = (MapPair*) pair1; 
    MapPair *v = (MapPair*) pair2;

    if(strcmp(u->key, v->key) == 0)
        return strcmp(u->value, v->value);
    return strcmp(u->key, v->key);
}

void MR_Emit(char *key, char *value) {
    // lock
    unsigned long partitionNum = mrVars.partitioner(key, vars.numOfPartitions);
    vars.numOfPairs[partitionNum]++;
    int pairCount = vars.numOfPairs[partitionNum];
    vars.dict[partitionNum][pairCount - 1].key = (char*)malloc((strlen(key) + 1) * sizeof(char));
    vars.dict[partitionNum][pairCount - 1].value = (char*)malloc((strlen(value) + 1) * sizeof(char));
    strcpy(vars.dict[partitionNum][pairCount - 1].key, key);
    strcpy(vars.dict[partitionNum][pairCount - 1].value, value);
    //unlock
}

unsigned long MR_DefaultHashPartition(char *key, int num_partitions) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++) != '\0')
        hash = hash * 33 + c;
    return hash % num_partitions;
}

char *get_next(char *key, int partition_number){
    int i = vars.partitionIter[partition_number];
    if(i > vars.numOfPairs[partition_number] || strcmp(key, vars.dict[partition_number][i].key) != 0)
        return NULL;
    
    vars.partitionIter[partition_number]++;
    return vars.dict[partition_number][i].value;
}

void *map_wrapper(void * ptr) {
    // TODO: Working under assumption that we have one file
    // Add while loop if more than one file?
    Mapper mapFunc = mrVars.map;
    char *file_name = vars.names.name;

    if(file_name != NULL)
         mapFunc(file_name);
    return NULL;
}

void *reducer_wrapper(void *args) {
    // TODO: Add support for int array
    int partitionNum = 0;
    Reducer reduceFunc = mrVars.reduce;
    int i;
    for(i = 0; i < vars.numOfPairs[partitionNum]; ++i){
        if(i == vars.partitionIter[partitionNum])
            reduceFunc(vars.dict[partitionNum][i].key, get_next, partitionNum);
    }
    return NULL;
}

void MR_Run(int argc, char *argv[],
                Mapper map, int num_mappers,
                Reducer reduce, int num_reducers,
                Partitioner partition)
{
    /*STEP 1: Initialization*/
    pthread_t mapping_threads[num_mappers];
    pthread_t reducer_threads[num_reducers];

    /*Init mrVars struct*/
    mrVars.map = map;
    mrVars.reduce = reduce;
    if(partition == NULL){
        mrVars.partitioner = MR_DefaultHashPartition;
    } else{
        mrVars.partitioner = partition;
    }

    /*Init Vars struct*/
    vars.dict = malloc(num_reducers * sizeof(MapPair *));
    vars.partitionIter  = malloc(num_reducers * sizeof(int));
    vars.numOfPairs = malloc(num_reducers * sizeof(int));
    vars.numOfPartitions = 0;
    vars.numFilesProc = 0;
    vars.totalFiles = argc - 1;
    vars.names.name = argv[1]; // TODO: ONLY WORKS FOR 1 FILE

    // TODO: Sorting files RR or SJF?
    // qsort(&vars.names, argc - 1, sizeof(fileName), file_helper);

    // STEP 2: MAP
    int i;
    for(i = 0; i < num_mappers; i++)
        pthread_create(&mapping_threads[i], NULL, map_wrapper, NULL);

    // Wait on mapping_threads
    for(i = 0; i < num_mappers; i++)
        pthread_join(mapping_threads[i], NULL);

    // STEP 3: Sort
    // Sort files

    // Sort partitions
	for(i = 0; i < num_reducers; ++i)
		qsort(vars.dict[i], vars.numOfPairs[i], sizeof(MapPair), pair_helper);
    
    // STEP 4: Reducer
    for(i = 0; i < num_mappers; i++)
        pthread_create(&reducer_threads[i], NULL, reducer_wrapper, NULL);

    // Wait on reducer_threads
    for(i = 0; i < num_mappers; i++)
        pthread_join(reducer_threads[i], NULL);

    // STEP 5: Freeing
    free(vars.dict);
    free(vars.names.name);
}
