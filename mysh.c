#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/*
* Linked list/dictionary implementation of aliases
* The key is the shortcut while value is the actual command
*/
struct aliasLinkedList {
    char* key;
    char* value;
    struct aliasLinkedList *next; //if there's no other alias then this is null
};
char* prompt="mysh> \0";

void batchMode();
int parseInput(char *tokens[256], char *cmd); //returns number of tokens
struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[256], int numTokens); //TODO: change cmd to *cmd[]
void runUnalias(struct aliasLinkedList **head, char *cmd[], int numTokens);
void addNode(struct aliasLinkedList **headRef, char *key, char *value);
void removeNode(struct aliasLinkedList **headRef, char *key);

int main(int argc, char* argv[]) {
    //TODO: Handle batch mode

    struct aliasLinkedList *head = malloc(sizeof(struct aliasLinkedList));
    head->key = head->value = "\0";
    head->next = NULL;
    //struct aliasLinkedList *head = NULL;

    if(argc == 2)
        batchMode();

    //else run interactive mode
    char *cmd = malloc(512);

    //TODO: Handle exiting when user presses ctrl+d
    while(1) {

        /* prompt user to enter & immediately exit if exit typed */
        write(1, prompt, sizeof(prompt));
        fgets(cmd, 512, stdin);

        char *tokens[256];
        int numTokens = parseInput(tokens, cmd);

        //TODO: does the the prompt have to equal exit exactly?
        if(!strncmp(cmd, "exit", 4))
            break;

        /* run appropriate program based on input */
        if(!strncmp(cmd, "alias", 4)) {
            head = runAlias(head, tokens, numTokens);
            //addNode(&head, tokens[1]);
        }
        else if(!strncmp(cmd, "unalias", 7)) {
            runUnalias(&head, tokens, numTokens);
            //runUnalias(&head, tokens, numTokens);
        }
    }

    //TODO: Free the linked list??
    struct aliasLinkedList *curr = head, *prev = NULL;
    while(curr != NULL){
        prev = curr;
        curr = curr->next;
        free(prev);
    }

    free(cmd);
    return 0;
}

void batchMode() {
    write(5, "batch", 5);
}

int parseInput(char *tokens[256], char *cmd) {
    //tokenize cmd
    //TODO: maybe duplicate the cmd to preserve it
    char *token = strtok(cmd, " ");
    int currToken = 0;
    do{
        tokens[currToken] = token;
        currToken++;
        token = strtok(NULL, " "); //manuals specify this must be null
    } while(token != NULL);
    return currToken;
}

struct aliasLinkedList* runAlias(struct aliasLinkedList *head, char *tokens[256], int numTokens) {
    /*If the user only types alias*/
    //must compare with newline as it is read in by fgets(...)
    //TODO: Handle this

    //char *key = tokens[1];
    if(!strncmp(tokens[1], "alias\n", sizeof("alias")) ||
        !strncmp(tokens[1], "unalias\n", sizeof("unalias")) ||
        !strncmp(tokens[1], "exit\n", sizeof("exit"))
        ){
        write(1, "alias: Too dangerous to alias that.\n", sizeof("alias: Too dangerous to alias that.\n")); //TODO: Write to stderr
        return head;
    }

    struct aliasLinkedList *currentNode = head;
    if(!strcmp(tokens[0], "alias\n")){
        while(currentNode->next != NULL) {
            printf("%s %s", currentNode->key, currentNode->value);
            fflush(stdout);
            currentNode = currentNode->next;
        }
        return head;
    }

    /* if of form command alias <alias-name> then numTokens == 2, so then only print that one alias */
    if(numTokens == 2) {
        while(currentNode->next != NULL) {
            if(!strncmp(currentNode->key, tokens[1], sizeof(*(currentNode->key)))) {
                printf("%s %s", currentNode->key, currentNode->value);
                fflush(stdout);
                //write(1, currentNode->value, sizeof(currentNode->value));
                return head;
            }
            currentNode = currentNode->next;
        }
        return head;
    }

    /* build the value of the alias */
    char *aliasVal = "\0", *temp = malloc(sizeof(aliasVal)); //,*alias = tokens[1]; // the alias to add/replace will always be index 1
    for(int i = 2; i < numTokens; i++) {

        temp = realloc(temp, sizeof(aliasVal) + sizeof(tokens[i]));
        temp = strdup(aliasVal);
        strcat(temp, tokens[i]);

        if(i < numTokens-1) strcat(temp, " ");
        aliasVal = strdup(temp);
        //curr = realloc(curr, sizeof(aliasVal)+sizeof(tokens[i])+1); //potential issues for memory leak here, curr can be null
        //if(i < numTokens-1) strcat(strcat(curr, tokens[i]), " ");   //append the current arg with a " " at the end
        //else strcat(curr, tokens[i]);
        //aliasVal = curr;
    }

    /*
    * Iterate through nodes until
    * 1) Find a node with the current alias
    * 2) Reach the end
    */
    addNode(&head, tokens[1], aliasVal);
    free(temp);
    return head;
}

void addNode(struct aliasLinkedList **head, char *key, char *value) {
    struct aliasLinkedList *currentNode = *head;
    if(head == NULL || *head == NULL) {
        head = malloc(sizeof(struct aliasLinkedList));
        (*head)->key   = strdup(key);
        (*head)->value = strdup(value);
        (*head)->next  = NULL;
    }

    while(currentNode->next != NULL ) {
        if(!strcmp(currentNode->key, key)) break;
        currentNode = currentNode->next;
    }

    if(!strcmp(currentNode->key, key))
        currentNode->value = strdup(value);
    else {
        struct aliasLinkedList *newNode = malloc(sizeof(struct aliasLinkedList));
        newNode->key   = malloc(sizeof(key));
        newNode->value = malloc(sizeof(value));
        newNode->key   = strdup(key);
        newNode->value = strdup(value);
        newNode->next  = *head;
        *head = newNode;
    }
}


void runUnalias(struct aliasLinkedList **headRef, char *cmd[], int numTokens) {

    if(numTokens > 2) {
        write(1, "unalias: Incorrect number of arguments.\n", sizeof("unalias: Incorrect number of arguments.\n"));
        return;
    }

    char *key = cmd[1];

    /*Edge Case: remove from head*/
    struct aliasLinkedList *head = *headRef;
    if( !strncmp(head->key, key, sizeof( *(head->key) )) ) {
        *headRef = (*headRef)->next;
        free(head);
        return;
    }

    /*Remove elsewhere*/
    struct aliasLinkedList *curr = head, *prev = head;
    while(curr != NULL) {

        if(!strncmp(curr->key, key, sizeof(*(curr->key)) )) {
            prev->next = curr->next;
            free(curr->key);
            free(curr->value);
            free(curr);
            return;
        }

        prev = curr;
        curr = curr->next;
    }
}