#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/*
 * Linked list/dictionary implementation of aliases
 * The key is the shortcut while value is the actual command
 */
struct aliasLinkedList
{
    char *key;
    char *value;
    struct aliasLinkedList *next; // if there's no other alias then this is null
};
const int BUFFER_SIZE = 512;
const int TOKEN_NUMBER = 256;
char *prompt = "mysh> \0";

// Function signatures
void batchMode(char *fileName);
void readCmd(FILE *stream);
void execCmd(char *cmd);
int parseInput(char *tokens[TOKEN_NUMBER], char *cmd);                                                       // returns number of tokens
struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[TOKEN_NUMBER], int numTokens);
void runUnalias(struct aliasLinkedList **head, char *cmd[], int numTokens);
void addNode(struct aliasLinkedList **headRef, char *key, char *value);
void removeNode(struct aliasLinkedList **headRef, char *key);

int main(int argc, char *argv[])
{
    // buffer for write
    char *buff;
    int buff_size;

    // Incorrect number of cmd line args
    if (argc > 2)
    {
        buff = "Usage: mysh [batch-file]\n";
        buff_size = strlen(buff);
        write(STDERR_FILENO, buff, buff_size);
        exit(1);
    }

    // Creating head of Alias Linked List
    struct aliasLinkedList *head = malloc(sizeof(struct aliasLinkedList));
    // Initializing struct to default vals
    head->key = head->value = "\0";
    head->next = NULL;

    if (argc == 2)
        batchMode(argv[1]);

    // else run interactive mode
    char *cmd = malloc(BUFFER_SIZE);

    // TODO: Handle exiting when user presses ctrl+d
    while (1)
    {
        /* prompt user to enter & immediately exit if exit typed */
        write(1, prompt, sizeof(prompt));
        fgets(cmd, BUFFER_SIZE, stdin);

        char *tokens[TOKEN_NUMBER];
        int numTokens = parseInput(tokens, cmd);

        // terminate shell if user types exit
        if (!strncmp(cmd, "exit", 4))
            exit(0);

        /* run appropriate program based on input */
        // Feature: Alias and Unalias
        if(!strncmp(cmd, "alias", 4))
            head = runAlias(head, tokens, numTokens);
        else if(!strncmp(cmd, "unalias", 7))
            runUnalias(&head, tokens, numTokens);
    }

    //Free the linked list
    struct aliasLinkedList *curr = head, *prev = NULL;
    while(curr != NULL){
        prev = curr;
        curr = curr->next;
        free(prev);
    }

    free(cmd);
    return 0;
}

void batchMode(char *fileName)
{
    // buffer for write
    char *buff;
    int buff_size;

    // Opening file passed as cmdline arg
    FILE *fp = fopen(fileName, "r");

    // Checking if file opened successfully
    if (fp == NULL)
    {
        // Batch-file DNE
        buff = "Error: Cannot open file <filename>\n";
        buff_size = strlen(buff);
        write(STDERR_FILENO, buff, buff_size);
        exit(1);
    }

    // Reading cmds from fp
    readCmd(fp);
    // Closing file
    fclose(fp);
}

// Prints line with appropirate prefix string
void readCmd(FILE *stream)
{
    char s[BUFFER_SIZE];
    while (fgets(s, BUFFER_SIZE, stream) != NULL)
    {
        if (strcmp(s, "exit") == 0)
        {
            exit(0);
        }
        printf("%s", s);
        execCmd(s);
    }
    // End of file reached
    exit(0);
}

void execCmd(char *cmd)
{
    printf("Executing command:\t%s", cmd);
    fflush(stdout);
    // TODO: Execute commands
}

int parseInput(char *tokens[TOKEN_NUMBER], char *cmd)
{
    // tokenize cmd
    // TODO: maybe duplicate the cmd to preserve it
    char *token = strtok(cmd, " ");
    int currToken = 0;
    do
    {
        tokens[currToken] = token;
        currToken++;
        token = strtok(NULL, " "); // manuals specify this must be null
    } while (token != NULL);
    return currToken;
}

struct aliasLinkedList* runAlias(struct aliasLinkedList *head, char *tokens[256], int numTokens) {
    /*If the user only types alias*/
    if(!strncmp(tokens[1], "alias\n", sizeof("alias")) ||
        !strncmp(tokens[1], "unalias\n", sizeof("unalias")) ||
        !strncmp(tokens[1], "exit\n", sizeof("exit"))
        ){
        write(2, "alias: Too dangerous to alias that.\n", sizeof("alias: Too dangerous to alias that.\n"));
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
                return head;
            }
            currentNode = currentNode->next;
        }
        return head;
    }

    /* build the value of the alias */
    char *aliasVal = "\0", *temp = malloc(sizeof(aliasVal));

    if(temp == NULL){
        write(2, "Error not enough memory\n", sizeof("Error not enough memory\n"));
        return head;
    }

    for(int i = 2; i < numTokens; i++) {

        temp = realloc(temp, sizeof(aliasVal) + sizeof(tokens[i]));
        if(temp == NULL){
            write(2, "Error not enough memory\n", sizeof("Error not enough memory\n"));
            return head;
        }
        temp = strdup(aliasVal);
        strcat(temp, tokens[i]);

        if(i < numTokens-1) strcat(temp, " ");
        aliasVal = strdup(temp);
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

    /*Edge Case: remove from head*/
    char *key = cmd[1];
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
