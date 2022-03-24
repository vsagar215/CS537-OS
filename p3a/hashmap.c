#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"

// Global structures
HashMap *hash;

struct args_struct {
    Mapper map;
    Getter get_func;
    char *file_name;
    char *key;
    int partition_number;
};

void MR_Emit(char *key, char *value) {
    MapPair *elt = (MapPair*) malloc(sizeof(MapPair));
    if (elt == NULL) {
    	printf("Malloc error! %s\n", strerror(errno));
    	exit(1);
    }
    elt->key = strdup(key);
    elt->value = strdup(value);

    //TODO: Insert into hash
    //TODO: something with partitions??

    //HashMap* map, char* key, void* value, int value_size
    MapPut(hash, key, value, strlen(value));
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

void *map_wrapper(struct args_struct *args) {
    Mapper mapFunc = ((struct args_struct *) args)->map;
    char *file_name = ((struct args_struct *) args)->file_name;

    if(file_name != NULL)
        mapFunc(file_name);
    return NULL;
}

void *reducer_wrapper(struct args_struct *args) {
    return NULL;
}

void MR_Run(int argc, char *argv[],
        	    Mapper map, int num_mappers,
	            Reducer reduce, int num_reducers,
	            Partitioner partition)
{

    hash = MapInit();
    pthread_t threads[num_mappers];

    if(!partition)
        partition = MR_DefaultHashPartition;

    /*Create num_mapper threads to handle the mapping*/
    for (int i = 1; i < argc; i++) {
        struct args_struct args;
        args.map = map;
        args.file_name = argv[i];
        map_wrapper(&args);
    }


    /*Wait on the threads*/
    for (int i = 1; i < argc; i++)
        pthread_join(threads[i], NULL);

    //TODO: Sort does not need to be locked

    for(int i = 1; i < argc; i++) {
        struct args_struct args;
        args.get_func = get_func;
        //TODO: key
        //TODO: partition number
        reducer_wrapper(&args);

    }

}