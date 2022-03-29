#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "hashmap.h"
#include <pthread.h>
#include <stddef.h>

#define FNV_OFFSET 14695981039346656037UL
#define FNV_PRIME 1099511628211UL
// pthread_mutex_t lock;
pthread_rwlock_t lock;

// No need to lock?
HashMap *MapInit(void)
{
    HashMap *hashmap = (HashMap *)malloc(sizeof(HashMap));
    hashmap->contents = (MapPair **)calloc(MAP_INIT_CAPACITY, sizeof(MapPair *));
    hashmap->capacity = MAP_INIT_CAPACITY;
    hashmap->size = 0;
    return hashmap;
}

void MapPut(HashMap *hashmap, char *key, void *value, int value_size)
{
    // pthread_mutex_lock(&lock);
    // lock this
    // pthread_mutex_lock(&lock);
    if (hashmap->size > (hashmap->capacity / 2))
    {
        if (resize_map(hashmap) < 0)
        {
            exit(0);
        }
    }
    // pthread_mutex_unlock(&lock);
    // No need to lock
    MapPair *newpair = (MapPair *)malloc(sizeof(MapPair));
    int h;

    newpair->key = strdup(key);
    newpair->value = (void *)malloc(value_size);
    memcpy(newpair->value, value, value_size);

    h = Hash(key, hashmap->capacity);
    
    while (hashmap->contents[h] != NULL)
    {
        // if lock the if and h incr
        // if keys are equal, update
        // pthread_mutex_lock(&lock);
        if (!strcmp(key, hashmap->contents[h]->key))
        {
            pthread_rwlock_rdlock(&lock);
            free(hashmap->contents[h]);
            hashmap->contents[h] = newpair;
            pthread_rwlock_unlock(&lock);
            return;
        }
        h++;
        // pthread_mutex_unlock(&lock);
        if (h == hashmap->capacity)
            h = 0;
    }

    // lock this
    // key not found in hashmap, h is an empty slot
    pthread_rwlock_rdlock(&lock);
    // pthread_mutex_lock(&lock);
    hashmap->contents[h] = newpair;
    hashmap->size += 1;
    // pthread_mutex_unlock(&lock);
    pthread_rwlock_unlock(&lock);
}

char *MapGet(HashMap *hashmap, char *key)
{
    int h = Hash(key, hashmap->capacity);
    while (hashmap->contents[h] != NULL)
    {
    pthread_rwlock_wrlock(&lock);
        // pthread_mutex_lock(&lock);
        if (!strcmp(key, hashmap->contents[h]->key))
        {
            pthread_rwlock_unlock(&lock);
            return hashmap->contents[h]->value;
        }
        h++;
    pthread_rwlock_unlock(&lock);
        // pthread_mutex_unlock(&lock);
        if (h == hashmap->capacity)
        {
            h = 0;
        }
    }
    return NULL;
}

size_t MapSize(HashMap *map)
{
    return map->size;
}

int resize_map(HashMap *map)
{
    MapPair **temp;
    size_t newcapacity = map->capacity * 2; // double the capacity

    // allocate a new hashmap table
    temp = (MapPair **)calloc(newcapacity, sizeof(MapPair *));
    if (temp == NULL)
    {
        printf("Malloc error! %s\n", strerror(errno));
        return -1;
    }

    size_t i;
    int h;
    MapPair *entry;
    // rehash all the old entries to fit the new table
    for (i = 0; i < map->capacity; i++)
    {
        if (map->contents[i] != NULL)
            entry = map->contents[i];
        else
            continue;
        h = Hash(entry->key, newcapacity);
        while (temp[h] != NULL)
        {
            h++;
            if (h == newcapacity)
                h = 0;
        }
        temp[h] = entry;
    }

    // free the old table
    free(map->contents);
    // update contents with the new table, increase hashmap capacity
    map->contents = temp;
    map->capacity = newcapacity;
    return 0;
}

// FNV-1a hashing algorithm
// https://en.wikipedia.org/wiki/Fowler-Noll-Vo_hash_function#FNV-1a_hash
size_t Hash(char *key, size_t capacity)
{
    // pthread_mutex_lock(&lock);
    size_t hash = FNV_OFFSET;
    for (const char *p = key; *p; p++)
    {
        hash ^= (size_t)(unsigned char)(*p);
        hash *= FNV_PRIME;
        hash ^= (size_t)(*p);
    }
    // pthread_mutex_unlock(&lock);
    return (hash % capacity);
}
