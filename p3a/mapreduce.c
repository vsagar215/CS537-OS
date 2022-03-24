#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"

struct fileName{
    char *name;
};

struct vars{
    MapPair **dict;
    struct fileName names;
    int *numOfPairs;
    int pairAllocPartition;
    int *numAccPartCount;
    int partCount;
    int totalFiles;
    int numFilesProc;
};

struct MRVars {
    Mapper map;
    Getter get_func;
    char *file_name;
    char *key;
    int partition_number;
}mrVars;

void MR_Emit(char *key, char *value) {
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

void *map_wrapper(struct MRVars *args) {
    Mapper mapFunc = ((struct MRVars *) args)->map;
    char *file_name = ((struct MRVars *) args)->file_name;

    if(file_name != NULL)
        mapFunc(file_name);
    return NULL;
}

void *reducer_wrapper(struct MRVars *args) {
    return NULL;
}

void MR_Run(int argc, char *argv[],
                Mapper map, int num_mappers,
                Reducer reduce, int num_reducers,
                Partitioner partition)
{
    // Two arrays of threads, Mapping and Reducer threads
    pthread_t mapping_threads[num_mappers];
    pthread_t reducer_threads[num_reducers];

    // Partitions will depend on num of reduce threads
    mrVars.partition_number = num_reducers;
    //args.map = map;

    // TODO: Sorting files RR or SJF? 
    
    // STEP 1: MAP

    /*Create num_mapper threads to handle the mapping*/
    for (int i = 1; i < argc; i++) {
        // struct args_struct args;
        mrVars.map = map;
        mrVars.file_name = argv[i];
        //pthread_create(&mapping_threads[i], NULL, thread_wrapper, &args);
        map_wrapper(&mrVars);
    }

	/*Wait on the map threads*/
    for (int i = 1; i < argc; i++){
        pthread_join(mapping_threads[i], NULL);
    }

    // STEP 2: SORT
    // TODO: Use quick Sort to sort lexicographically

    // STEP 3: REDUCE

    /*Create num_reducers threads to handle the reducing*/
	for (int i = 0; i < num_reducers; i++){
        //pthread_create(&reducer_threads[i], NULL, thread_wrapper, &args);
	}

	/*Wait on the reduce threads*/
	for(int i = 0; i < num_reducers; i++) {
		pthread_join(reducer_threads[i], NULL);
	}

    for(int i = 1; i < argc; i++) {
        // struct args_struct args;
        mrVars.get_func = get_func;
        //TODO: key
        //TODO: partition number
        reducer_wrapper(&mrVars);

    }

}
