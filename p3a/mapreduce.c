#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"
#include <sys/stat.h>

// Globals and Structures
pthread_mutex_t lock; 
pthread_mutex_t file;
const int BUCKET_SIZE = 5000;

struct fileHelper {
	char *name;
};

struct CentralDataStructure{
	MapPair **bucket;
	int *numOfKVs;
	int *allocedKVs;
	int *KVpointerInBucket;
	int numOfBuckets;
	int filesConsumed;
	int totalNumOfFiles;
	struct fileHelper *fileNames;
}cds;

struct MapReduceFunctions{
	Mapper map;
	Reducer reduce;
	Partitioner partition;
}mrf;

// Function Declarations
void MR_Run(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition);
void MR_Emit(char *key, char *value);
unsigned long MR_DefaultHashPartition(char *key, int num_partitions);
void init_cds(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition, int *bucketPointer);
int SFF(const void* p, const void* q);
void *map_wrapper(void *ptr);
int cmp(const void* p, const void* q);
char *get_next(char *key, int partition_number);
void *reducer_wrapper(void *ptr);
void custodian();

void MR_Emit(char *key, char *value) {
	pthread_mutex_lock(&lock);			// Preventing incomplete memory reallocation
	// Getting bucket corresponding to passed key
	unsigned long hashPartitionNumber = mrf.partition(key, cds.numOfBuckets);
	int numOfKV = ++cds.numOfKVs[hashPartitionNumber]; // Getting updated number of KVs in given bucket
	// If space in bucket, simply copy KVs
	if(numOfKV <= cds.allocedKVs[hashPartitionNumber]){
		// Making space 
		cds.bucket[hashPartitionNumber][numOfKV - 1].key = (char *)malloc( (strlen(key) + 1) * sizeof(char));
		cds.bucket[hashPartitionNumber][numOfKV - 1].value = (char *)malloc( (strlen(value) + 1) * sizeof(char));
	
		// Storing keys and values
		strcpy(cds.bucket[hashPartitionNumber][numOfKV - 1].key, key);
		strcpy(cds.bucket[hashPartitionNumber][numOfKV - 1].value, value);
	} else{ // Otherwise alloc space in bucket first
		cds.allocedKVs[hashPartitionNumber] *= 2; // double the size of bucket
		cds.bucket[hashPartitionNumber] = (MapPair *) realloc(cds.bucket[hashPartitionNumber], cds.allocedKVs[hashPartitionNumber] * sizeof(MapPair));

		cds.bucket[hashPartitionNumber][numOfKV - 1].key = (char *)malloc( (strlen(key) + 1) * sizeof(char));
		cds.bucket[hashPartitionNumber][numOfKV - 1].value = (char *)malloc( (strlen(value) + 1) * sizeof(char));

		strcpy(cds.bucket[hashPartitionNumber][numOfKV - 1].key, key);
		strcpy(cds.bucket[hashPartitionNumber][numOfKV - 1].value, value);
	}

	pthread_mutex_unlock(&lock); 
}

unsigned long MR_DefaultHashPartition(char *key, int num_partitions) {
    unsigned long hash = 5381;
    int c;
    while ((c = *key++) != '\0')
        hash = hash * 33 + c;
    return hash % num_partitions;
}

void MR_Run(int argc, char *argv[], 
			Mapper map, int num_mappers, 
			Reducer reduce, int num_reducers, 
			Partitioner partition) 
{	
	/*STEP 1: Initialization*/
	// Initializing locks and local vars 
	pthread_mutex_init(&lock, NULL);
	pthread_mutex_init(&file, NULL);
	pthread_t mapperThreads[num_mappers];
	pthread_t reducerThreads[num_reducers];
	int bucketPointer[num_reducers];
	int i;

	// Initializing Central Data Structure and MapReduce Functions
	init_cds(argc, argv, map, num_mappers, reduce, num_reducers, partition, bucketPointer);

	// Sorting files by file size
	qsort(&cds.fileNames[0], cds.totalNumOfFiles, sizeof(struct fileHelper), SFF);

	/*STEP 2: Map*/
	// Create mapping threads
	for (i = 0; i < num_mappers; ++i) {
		pthread_create(&mapperThreads[i], NULL, map_wrapper, NULL);
	}
	// Join mapping threads
	for(i = 0; i < num_mappers; ++i) {
		pthread_join(mapperThreads[i], NULL); 
	}

	/*STEP 3: Sorting*/
	// Sort partitions
	for(i = 0; i < cds.numOfBuckets; ++i) {
		qsort(cds.bucket[i], cds.numOfKVs[i], sizeof(MapPair), cmp);
	}

	/*STEP 4: Reduce*/
	// Create reducing threads
	for (i = 0; i < num_reducers; ++i){
	    pthread_create(&reducerThreads[i], NULL, reducer_wrapper, &bucketPointer[i]);
	}
	// Join reducing threads
	for(i = 0; i < num_reducers; ++i) {
		pthread_join(reducerThreads[i], NULL); 
	}

	/*STEP 5: Cleanup*/
	custodian();
}

// Initializes all fields with meaningful values
void init_cds(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition, int *bucketPointer){
	
	// Central Data Structure
	cds.fileNames = malloc((cds.totalNumOfFiles) * sizeof(struct fileHelper));
	cds.bucket = malloc(cds.numOfBuckets * sizeof(struct pairs*));
	cds.allocedKVs = malloc(cds.numOfBuckets * sizeof(int));
	cds.numOfKVs = malloc(cds.numOfBuckets * sizeof(int));
	cds.KVpointerInBucket = malloc(cds.numOfBuckets * sizeof(int));
	cds.totalNumOfFiles = argc - 1;
	cds.filesConsumed = 0;
	int i;
	cds.numOfBuckets = num_reducers;

	// MapReduce Functions
	mrf.map = map;
	mrf.reduce = reduce;
	mrf.partition = partition;

	// Allocing space for bucket data structures 
	for(i = 0; i < num_reducers; i++) {
		cds.bucket[i] = malloc(BUCKET_SIZE * sizeof(MapPair));
		bucketPointer[i] = i;
		cds.allocedKVs[i] = BUCKET_SIZE;
		cds.numOfKVs[i] = 0;
		cds.KVpointerInBucket[i] = 0;
	}

	// Copying file names
	for(i = 0; i <cds.totalNumOfFiles; i++) {
		cds.fileNames[i].name = malloc((strlen(argv[i+1])+1) * sizeof(char));
		strcpy(cds.fileNames[i].name, argv[i+1]);
	}
}

// Using Shortest-File-First
int SFF(const void* p, const void* q) {
	struct fileHelper *a = (struct fileHelper*) p;
	struct stat infoA;
	stat(a->name, &infoA);
	long int sizeOfA = infoA.st_size;
	
	struct fileHelper *b = (struct fileHelper*) q;
	struct stat infoB;
	stat(b->name, &infoB);
	long int sizeOfB = infoB.st_size;
	return (sizeOfA - sizeOfB);
}

// Sorting partition based on values and keys
int cmp(const void* p, const void* q) {
	MapPair *dictA = (MapPair *) p;
	MapPair *dictB = (MapPair *) q;
	
	// if unique keys, only do 1 comparison
	int keysRV = strcmp(dictA->key, dictB->key);
	
	if(0 == keysRV) // If same keys exist, also compare values
		return strcmp(dictA->value, dictB->value);
	
	return keysRV;
}

void *map_wrapper(void *ptr) {
	// looping until total files mapped
	while(cds.filesConsumed < cds.totalNumOfFiles) { 
		// preventing incorrect counter update
		pthread_mutex_lock(&file);					 
		char *name = cds.fileNames[cds.filesConsumed].name;
		cds.filesConsumed++;
		pthread_mutex_unlock(&file);
		if(name == NULL){
			continue;
		} else{
			mrf.map(name);							// only map if valid file name
		}
	}
	return ptr;
}

char *get_next(char *key, int partition_number) {
	
	int curr_KV = cds.KVpointerInBucket[partition_number];
	// Reached end of bucket
	if(curr_KV >= cds.numOfKVs[partition_number])
		return NULL;
	
	// If key exists in the bucket, return value 
	if(strcmp(key, cds.bucket[partition_number][curr_KV].key) == 0) {
			cds.KVpointerInBucket[partition_number]++; 
			return cds.bucket[partition_number][curr_KV].value;
	}

	return NULL;
}

void *reducer_wrapper(void *ptr) {
	int *partitionNumber = (int *)ptr;
	int i;
	for(i = 0; i < cds.numOfKVs[*partitionNumber]; ++i) {
		if(i == cds.KVpointerInBucket[*partitionNumber]) {
			mrf.reduce(cds.bucket[*partitionNumber][i].key, get_next, *partitionNumber);
		}
	}
	return ptr;
}

// Destroying locks and freeing memory
void custodian(){
	// Locks
	pthread_mutex_destroy(&lock);
	pthread_mutex_destroy(&file);
	
	// Central Data Structure
	free(cds.bucket);
	free(cds.numOfKVs);
	free(cds.fileNames);
	free(cds.allocedKVs);
	free(cds.KVpointerInBucket);
}