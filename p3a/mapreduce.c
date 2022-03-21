#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include "mapreduce.h"
#include "hashmap.h"
#include <pthread.h>

int threadCounter = 0;

struct kv
{
	char *key;
	char *value;
};

struct kv_list
{
	struct kv **elements;
	size_t num_elements;
	size_t size;
};

struct arg_struct {
    void *map;
    void *arg;
};

struct kv_list kvl;
size_t kvl_counter;

struct arg_struct mapArgs;

void init_kv_list(size_t size) {
    kvl.elements = (struct kv**) malloc(size * sizeof(struct kv*));
    kvl.num_elements = 0;
    kvl.size = size;
}

// TODO: Fix it for threads
void add_to_list(struct kv* elt) {
    // Lock 1
	if (kvl.num_elements == kvl.size) {
	kvl.size *= 2;
	kvl.elements = realloc(kvl.elements, kvl.size * sizeof(struct kv*));
    }
	// Lock 2
    kvl.elements[kvl.num_elements++] = elt;
}

int cmp(const void* a, const void* b) {
    char* str1 = (*(struct kv **)a)->key;
    char* str2 = (*(struct kv **)b)->key;
    return strcmp(str1, str2);
}

char* get_func(char* key, int partition_number) {
    if (kvl_counter == kvl.num_elements) {
	return NULL;
    }
    struct kv *curr_elt = kvl.elements[kvl_counter];
    if (!strcmp(curr_elt->key, key)) {
	kvl_counter++;
	return curr_elt->value;
    }
    return NULL;
}

void MR_Emit(char *key, char *value)
{
}

unsigned long MR_DefaultHashPartition(char *key, int num_partitions)
{
	unsigned long hash = 5381;
	int c;
	while ((c = *key++) != '\0')
		hash = hash * 33 + c;
	return hash % num_partitions;
}

void *thread_wrapper(void *args) {
    //pthread_exit((void *) (intptr_t) sum(ps->x, ps->y));
    //Mapper mArg = args;
    //pthread_exit( (void *) mArg(args[1]) );
    Mapper mapFunc = (void *)((struct arg_struct *) args)->map;
    pthread_exit( mapFunc( ((struct arg_struct *) args)->arg) );
}

void MR_Run(int argc, char *argv[],
			Mapper map, int num_mappers,
			Reducer reduce, int num_reducers,
			Partitioner partition)
{
	init_kv_list(10);
	int i;
    //void *args[2];
    //args[0] = map;
    mapArgs.map = map;
	for (i = 1; i < argc; i++)
	{
		pthread_t t;
		//pthread_create(&t, NULL, map, argv[i]);
        //args[1] = argv[i];
        //pthread_create(&t, NULL, thread_wrapper, args);
        mapArgs.arg = argv[i];
        pthread_create(&t, NULL, thread_wrapper, &mapArgs);
		(*map)(argv[i]);
	}

	qsort(kvl.elements, kvl.num_elements, sizeof(struct kv *), cmp);

	// note that in the single-threaded version, we don't really have
	// partitions. We just use a global counter to keep it really simple
	kvl_counter = 0;
	while (kvl_counter < kvl.num_elements)
	{
		(*reduce)((kvl.elements[kvl_counter])->key, get_func, 0);
	}
}
