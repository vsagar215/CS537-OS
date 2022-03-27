#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <pthread.h>
#include "mapreduce.h"
#include "hashmap.h"

struct fileName {
	char *name;
};

struct dataStructures{
	int *pairCountInPartition;
	int *pairAllocatedInPartition;
	int *numberOfAccessInPartition;
	int numberPartitions;
	int filesProcessed;
	int totalFiles;
	struct fileName *fileNames;
	MapPair **partitions;
}structs;

struct functions{
	Partitioner p;
	Reducer r;
	Mapper m;
}funcs;

pthread_mutex_t lock, fileLock;
const int BUCKET_SIZE = 5000;

// Function Declarations
void* mapperHelper(void *arg);
char* get_next(char *key, int partition_number);
void* reducerHelper(void *arg);
int compare(const void* p1, const void* p2);
int compareFiles(const void* p1, const void* p2);
void MR_Emit(char *key, char *value);
void custodian();
unsigned long MR_DefaultHashPartition(char *key, int num_partitions);
void MR_Run(int argc, char *argv[], Mapper map, int num_mappers, Reducer reduce, int num_reducers, Partitioner partition);


// Helper function to be called by pthread_create which calls the mapper function
void* mapperHelper(void *arg) {
	while(structs.filesProcessed < structs.totalFiles) {
		pthread_mutex_lock(&fileLock);
		char *filename = NULL;
			filename = structs.fileNames[structs.filesProcessed].name;
			structs.filesProcessed++;
		pthread_mutex_unlock(&fileLock);
		if(filename != NULL)
			funcs.m(filename);
	}
	return arg;
}

char* get_next(char *key, int partition_number) {
	int num = structs.numberOfAccessInPartition[partition_number];
	if(num < structs.pairCountInPartition[partition_number] && strcmp(key, structs.partitions[partition_number][num].key) == 0) {
		structs.numberOfAccessInPartition[partition_number]++;
		return structs.partitions[partition_number][num].value;
	}
	else {
		return NULL;
	}
}

// Helper function to be called by pthread_create which calls the get_next function for each reducer
void* reducerHelper(void *arg) {
	int* partitionNumber = (int *)arg;
	for(int i = 0; i < structs.pairCountInPartition[*partitionNumber]; i++) {
		if(i == structs.numberOfAccessInPartition[*partitionNumber]) {
			funcs.r(structs.partitions[*partitionNumber][i].key, get_next, *partitionNumber);
		}
	}
	return arg;
}

// Sort the buckets by key and then by value in ascending order
int compare(const void* p1, const void* p2) {
	MapPair *pair1 = (MapPair*) p1;
	MapPair *pair2 = (MapPair*) p2;
	if(strcmp(pair1->key, pair2->key) == 0) {
		return strcmp(pair1->value, pair2->value);
	}
	return strcmp(pair1->key, pair2->key);
}

// Sort files by increasing size
int compareFiles(const void* p1, const void* p2) {
	struct fileName *f1 = (struct fileName*) p1;
	struct fileName *f2 = (struct fileName*) p2;
	struct stat st1, st2;
	stat(f1->name, &st1);
	stat(f2->name, &st2);
	long int size1 = st1.st_size;
	long int size2 = st2.st_size;
	return (size1 - size2);
}

void MR_Emit(char *key, char *value) {
	pthread_mutex_lock(&lock); 
	// Getting the partition number
	unsigned long hashPartitionNumber = funcs.p(key, structs.numberPartitions);
	structs.pairCountInPartition[hashPartitionNumber]++;
	int curCount = structs.pairCountInPartition[hashPartitionNumber];
	// Checking if allocated memory has been exceeded,if yes allocating more memory
	if (curCount > structs.pairAllocatedInPartition[hashPartitionNumber]) {
		structs.pairAllocatedInPartition[hashPartitionNumber] *= 2;
		structs.partitions[hashPartitionNumber] = (MapPair *) realloc(structs.partitions[hashPartitionNumber], structs.pairAllocatedInPartition[hashPartitionNumber] * sizeof(MapPair));
	}
	structs.partitions[hashPartitionNumber][curCount-1].key = (char*)malloc((strlen(key)+1) * sizeof(char));
	strcpy(structs.partitions[hashPartitionNumber][curCount-1].key, key);
	structs.partitions[hashPartitionNumber][curCount-1].value = (char*)malloc((strlen(value)+1) * sizeof(char));
	strcpy(structs.partitions[hashPartitionNumber][curCount-1].value, value);
	pthread_mutex_unlock(&lock); 
}

void custodian(){
	pthread_mutex_destroy(&lock);
	pthread_mutex_destroy(&fileLock);
	free(structs.partitions);
	free(structs.fileNames);
	free(structs.pairCountInPartition);
	free(structs.pairAllocatedInPartition);
	free(structs.numberOfAccessInPartition);
}

// TODO: Init in a method?
// void init(int num_reducers){
// }

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
	// Initialising all the required variables
	pthread_t mapperThreads[num_mappers];
	pthread_t reducerThreads[num_reducers];
	pthread_mutex_init(&lock, NULL);
	pthread_mutex_init(&fileLock, NULL);
	funcs.p = partition;
	funcs.m = map;
	funcs.r = reduce;
	structs.numberPartitions = num_reducers;
	structs.partitions = malloc(num_reducers * sizeof(struct pairs*));
	structs.fileNames = malloc((argc - 1) * sizeof(struct fileName));
	structs.pairCountInPartition = malloc(num_reducers * sizeof(int));
	structs.pairAllocatedInPartition = malloc(num_reducers * sizeof(int));
	structs.numberOfAccessInPartition = malloc(num_reducers * sizeof(int));
	structs.filesProcessed = 0;
	structs.totalFiles = argc - 1;
	int arrayPosition[num_reducers];
	int i;

	// Initialising the arrays needed to store the key value pairs in the partitions
	for(i = 0; i < num_reducers; i++) {
		structs.partitions[i] = malloc(BUCKET_SIZE * sizeof(MapPair));
		structs.pairCountInPartition[i] = 0;
		structs.pairAllocatedInPartition[i] = BUCKET_SIZE;
		arrayPosition[i] = i;
		structs.numberOfAccessInPartition[i] = 0;
	}

	// Copying files for sorting in struct
	for(i = 0; i <structs.totalFiles; i++) {
		structs.fileNames[i].name = malloc((strlen(argv[i+1])+1) * sizeof(char));
		strcpy(structs.fileNames[i].name, argv[i+1]);
	}

	// Sorting files as Shortest File first
	qsort(&structs.fileNames[0], structs.totalFiles, sizeof(struct fileName), compareFiles);

	// Creating the threads for the number of mappers
	for (i = 0; i < num_mappers; i++) {
		pthread_create(&mapperThreads[i], NULL, mapperHelper, NULL);
	}

	// Waiting for threads to finish
	for(i = 0; i < num_mappers; i++) {
		pthread_join(mapperThreads[i], NULL); 
	}

	// Sorting the partitions
	for(i = 0; i < num_reducers; i++) {
		qsort(structs.partitions[i], structs.pairCountInPartition[i], sizeof(MapPair), compare);
	}

	//Printing to debug
	// for(int i = 0; i < num_reducers; i++) {
	// 	printf("Reducer number: %d\n", i);
	// 	for(int j = 0; j < pairCountInPartition[i]; j++) {
	// 		printf("%s ", (partitions[i][j].key));
	// 		printf("%s\n", (partitions[i][j].value));
	// 	}
	// }

	// Creating the threads for the number of reducers
	for (i = 0; i < num_reducers; i++){
	    if(pthread_create(&reducerThreads[i], NULL, reducerHelper, &arrayPosition[i])) {
	    	printf("Error\n");
	    }
	}

	//Waiting for the threads to finish
	for(i = 0; i < num_reducers; i++) {
		pthread_join(reducerThreads[i], NULL); 
	}

	custodian();
}