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
struct aliasLinkedList* runAlias(struct aliasLinkedList *head, char *cmd);

int main(int argc, char* argv[]) {

    //TODO: Handle batch mode

    struct aliasLinkedList *head = malloc(sizeof(struct aliasLinkedList));
    head->key = head->value = "\0";
    head->next = NULL;

    if(argc == 2)
        batchMode();

    //else run interactive mode
    char *cmd = malloc(512);

    //TODO: Handle exiting when user presses ctrl+d
    while(1) {

        /* prompt user to enter & immediately exit if exit typed */
        write(1, prompt, sizeof(prompt));
        fgets(cmd, 512, stdin);

        //write(1, s, sizeof(s));
        //TODO: does the the prompt have to equal exit exactly?
        if(!strncmp(cmd, "exit", 4))
            break;

        /* run appropriate program based on input */
        if(!strncmp(cmd, "alias", 4))
            head = runAlias(head, cmd);
    }

    //TODO: Free the linked list??

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

struct aliasLinkedList* runAlias(struct aliasLinkedList *head, char *cmd) {
    /*If the user only types alias*/
    //must compare with newline as it is read in by fgets(...)
    //TODO: Handle this
    struct aliasLinkedList *currentNode = head;
    if(!strcmp(cmd, "alias\n")){
        while(currentNode->next != NULL) {
            printf("%s %s", currentNode->key, currentNode->value);
            fflush(stdout);
            currentNode = currentNode->next;
        }
        return head;
    }

    char *tokens[256];
    tokens[1] = NULL;
    int numTokens = parseInput(tokens, cmd);
    if(tokens[1] == NULL) {
        write(1, "alias parsing error", sizeof("alias parsing error"));
        return head;
    }

    /* if command alias val -> numTokens == 2, so then only print that one alias */
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
    char *aliasVal = "\0", *curr=NULL; //,*alias = tokens[1]; // the alias to add/replace will always be index 1
    for(int i = 2; i < numTokens; i++) {
        curr = realloc(curr, sizeof(aliasVal)+sizeof(tokens[i])+1); //potential issues for memory leak here, curr can be null
        if(i < numTokens-1) strcat(strcat(curr, tokens[i]), " ");   //append the current arg with a " " at the end
        else strcat(curr, tokens[i]);
        aliasVal = curr;
    }

    /*
    * Iterate through nodes until
    * 1) Find a node with the current alias
    * 2) Reach the end
    */
    while(currentNode->next != NULL ) {
        if(!strcmp(currentNode->key, tokens[1])) break;
        currentNode = currentNode->next;
    }

    if(!strcmp(currentNode->key, tokens[1]))
        currentNode->value = strdup(aliasVal);
    else {
        struct aliasLinkedList *newNode = malloc(sizeof(struct aliasLinkedList));
        newNode->key   = strdup(tokens[1]);
        newNode->value = strdup(aliasVal);
        newNode->next  = head;
        head = newNode;
    }
    free(curr);
    return head;
}