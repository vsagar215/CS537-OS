#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <ctype.h>

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
// char *prompt = "mysh> ";

// Function signatures
void batchMode(char *fileName);
void readCmd(FILE *stream);
void execCmd(char *cmd);
char **tokenizeCmd(char *cmd);
int parseInput(char *tokens[TOKEN_NUMBER], char *cmd); // returns number of tokens
void execRedir(char *fileName);
char **tokenizeRedir(char *cmd);
char *getFn(char *cmd);
struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[TOKEN_NUMBER], int numTokens);
void runUnalias(struct aliasLinkedList **head, char *cmd[], int numTokens);
void addNode(struct aliasLinkedList **headRef, char *key, char *value);
void removeNode(struct aliasLinkedList **headRef, char *key);
int checkRedir(char *cmd, char *redirPtr);
char *getFn2(char *cmd);
char *trimWhiteSpaces(char *s);

struct aliasLinkedList *head;
int main(int argc, char *argv[]) {
    // buffer for write
    char *buff;
    int buff_size;
    // Incorrect number of cmd line args
    if (argc > 2) {
        buff = "Usage: mysh [batch-file]\n";
        buff_size = strlen(buff);
        write(STDERR_FILENO, buff, buff_size);
        exit(1);
    }

    // Creating head of Alias Linked List
    // Initializing struct to default vals
    head = (struct aliasLinkedList*) malloc(sizeof(struct aliasLinkedList));
    struct aliasLinkedList *findAlias = NULL;
    head->key = head->value = "dummy\0";
    head->next = NULL;

    if (argc == 2)
        batchMode(argv[1]); //TODO: Trim whitespaces

    // else run interactive mode
    char *cmd = malloc(BUFFER_SIZE);

    printf("mysh> ");
    fflush(stdout);
    // TODO: Handle exiting when user presses ctrl+d
    while (fgets(cmd, BUFFER_SIZE, stdin)) {
        /* prompt user to enter & immediately exit if exit typed */
        //cmd = trimWhiteSpaces(cmd);
        if(!strcmp(cmd,"\n")) {
            printf("mysh> ");
            fflush(stdout);
            continue;
        }
        char *tokens[TOKEN_NUMBER];
        int numTokens = parseInput(tokens, cmd);
        // terminate shell if user types exit
        if (!strncmp(cmd, "exit\n", 4))
            exit(0);

        /* run appropriate program based on input */
        // check if cmd is an alias
        findAlias = head;
        while (findAlias != NULL) {
            if (!strncmp(findAlias->key, tokens[0], sizeof(*(findAlias->key)))) {
                /*Build the actual command*/
                execCmd(findAlias->value);
                goto PROMPT;
            }
            findAlias = findAlias->next;
        }

        // Feature: Alias and Unalias
        if (!strncmp(cmd, "alias", 4))
            head = runAlias(head, tokens, numTokens);
        else if (!strncmp(cmd, "unalias", 7))
            runUnalias(&head, tokens, numTokens);
        else
            execCmd(cmd);

        PROMPT: printf("mysh> ");
        fflush(stdout);
    }

    // Free the linked list
    struct aliasLinkedList *curr = head, *prev = NULL;
    while (curr != NULL) {
        prev = curr;
        curr = curr->next;
        free(prev);
    }

    free(cmd);
    return 0;
}

void batchMode(char *fileName) {
    // Opening file passed as cmdline arg
    FILE *fp = fopen(fileName, "r");

    // Checking if file opened successfully
    if (fp == NULL) {
        // Batch-file DNE
        fprintf(stderr, "Error: Cannot open file %s.\n", fileName);
        fflush(stderr);
        exit(1);
    }

    // Reading cmds from fp
    readCmd(fp);
    // Closing file
    fclose(fp);
}

// Prints line with appropirate prefix string
// Prints line with appropirate prefix string
void readCmd(FILE *stream) {
    char s[BUFFER_SIZE];
    while (fgets(s, BUFFER_SIZE, stream) != NULL) {
        printf("%s", s);
        fflush(stdout);

        //printf("d%sd", s);
        //fflush(stdout);
        if(!strcmp(s,"\n")) continue;
        if (strcmp(s, "exit") == 0 || strcmp(s, "exit\n") == 0)
            exit(0);

        char *tokens[TOKEN_NUMBER];
        int numTokens = parseInput(tokens, s);

        struct aliasLinkedList *findAlias = head;
        int foundAlias = 0;
        while (findAlias != NULL) {
            if (!strncmp(findAlias->key, tokens[0], strlen((findAlias->key)))) {
                /*Build the actual command*/
                execCmd(findAlias->value);
                foundAlias = 1;
            }
            findAlias = findAlias->next;
        }
         //Feature: Alias and Unalias
        if (!strncmp(s, "alias", 4))
            head = runAlias(head, tokens, numTokens);
        else if (!strncmp(s, "unalias", 7))
            runUnalias(&head, tokens, numTokens);
        else if (foundAlias == 0)
            execCmd(s);
    }
    // End of file reached
    exit(0);
}

void execCmd(char *cmd) {
    // populating executCmd with cmd
    // printf("cmd: %s\n", cmd);
    // fflush(stdout);
    char **executCmd;
    executCmd = tokenizeCmd(cmd);
    // printf("executCmd[0]: %s\n", executCmd[0]);
    // fflush(stdout);
    char *fileName = malloc(0);
    int toRedir = checkRedir(cmd, fileName);
    // printf("toRedir: %d\n", toRedir);
    // fflush(stdout);
    if(toRedir == 0){
        fileName = getFn2(cmd); // Function using new type of splitting
        // printf("fileName: %s\n", fileName);
        // fflush(stdout);
    }
    if (toRedir < 0)
        return;

    int PID = fork();
    int status;
    // Checking if fork fails
    if (PID == -1) {
        free(fileName);
        exit(1);
    }
    // Fork succeeds: enter 1) Child Process
    int execRV;
    if (PID == 0) {
        // This is the child process exec does not return if it succeeds
        // returns (and sets errno) -1 if fails
        if (toRedir == 0) {
            char *newCmd = strtok(strdup(cmd), ">"), *tokNewCmd[TOKEN_NUMBER];
            int numTok = parseInput(tokNewCmd, newCmd);
            // printf("newCmd: %s\nnumTok: %d\n", newCmd, numTok);
            // fflush(stdout);
            tokNewCmd[numTok] = NULL;
            execRedir(fileName); //close stdout
            // printf("tokNewCmd[0]: %s\n", tokNewCmd[0]);
            // fflush(stdout);
            // int k = 0;
            // while(tokNewCmd[k] != NULL){
            //     printf("tokNewCmd: %s\n", tokNewCmd[k]);
            //     fflush(stdout);
            //     k++;
            // }
            execRV = execv(tokNewCmd[0], tokNewCmd);
        }
        else    execRV = execv(executCmd[0], executCmd);

        if (execRV == -1) {
            fprintf(stderr, "%s: Command not found.\n", executCmd[0]);
            fflush(stderr);
            // child process terminates itself
            _exit(1);
        }
    }
    // 2) Parents Process
    else {
        // This is the parent process; Waits for the child to finish
        waitpid(PID, &status, 0);
        free(executCmd);
    }
}

char **tokenizeRedir(char *cmd) {
    int dumCount = 0, tokCount = 0;
    // terminating in \n
    cmd[strcspn(cmd, "\n")] = 0;
    char *dummy = strdup(cmd);
    char *dummy2 = strdup(cmd);
    // splitting on spaces
    char *token = strtok(dummy, ">");

    // counting tokens
    while (token != NULL) {
        token = strtok(NULL, ">");
        dumCount++;
    }

    // tokenized pointer to string
    char **tokenized = malloc(sizeof(char *) * dumCount + 1);
    char *tokBuf = strtok(dummy2, ">");

    // Populating tokenized array
    while (tokBuf != NULL) {
        tokenized[tokCount] = strdup(tokBuf);
        tokBuf = strtok(NULL, ">");
        tokCount++;
    }

    // append null terminator to end of myargv
    tokenized[tokCount] = NULL;
    free(dummy);
    free(dummy2);
    return tokenized;
}

// TODO: Use parseInput to compute duplicate?
char **tokenizeCmd(char *cmd) {
    int dumCount = 0, tokCount = 0;
    // terminating in \n
    cmd[strcspn(cmd, "\n")] = 0;
    char *dummy = strdup(cmd);
    char *dummy2 = strdup(cmd);
    // splitting on spaces
    char *token = strtok(dummy, " ");

    // counting tokens
    while (token != NULL) {
        token = strtok(NULL, " ");
        dumCount++;
    }

    // tokenized pointer to string
    char **tokenized = malloc(sizeof(char *) * dumCount + 1);
    char *tokBuf = strtok(dummy2, " ");

    // Populating tokenized array
    while (tokBuf != NULL) {
        tokenized[tokCount] = trimWhiteSpaces(strdup(tokBuf));
        tokBuf = strtok(NULL, " ");
        tokCount++;
    }
    tokenized[tokCount] = NULL; // append null terminator to end of myargv
    free(dummy);
    free(dummy2);
    return tokenized;
}

int parseInput(char *tokens[TOKEN_NUMBER], char *cmd) {
    // tokenize cmd
    char *tempCmd = strdup(cmd);
    char *token = strtok(tempCmd, " ");
    int currToken = 0;
    do {
        tokens[currToken] = strdup(token);
        currToken++;
        token = strtok(NULL, " "); // manuals specify this must be null
    } while (token != NULL);
    free(tempCmd);
    return currToken;
}

// Older version
char *getFn(char *cmd) {
    char **tokCmd = tokenizeCmd(cmd);
    int i = 0;
    while (tokCmd[i] != NULL)
        ++i;
    char* redirPtr = strdup(tokCmd[i-1]); // the file to open
    return redirPtr;
}

// New version
char *getFn2(char *cmd) {
    char **tokCmd = tokenizeRedir(cmd);
    int i = 0;
    while (tokCmd[i] != NULL)
        ++i;
    char* redirPtr = strdup(tokCmd[i-1]); // the file to open
    return redirPtr;
}

int checkRedir(char *cmd, char *redirPtr){
    if (cmd == NULL) return -1;

    if (strchr(cmd, '>') == NULL) return 1;
    // 1) check if starts w/ >
    // 2) check if end w/ >
    char last = cmd[strlen(cmd) - 1], first = cmd[0];
    if (last == '>' || first == '>') {
        fprintf(stderr, "Redirection misformatted.\n");
        fflush(stderr);
        // write(1, "Redirection misformatted.\n", sizeof("Redirection misformatted.\n"));
        return -1;
    }
    // Split by >
    char **tokCmd = tokenizeRedir(cmd);
    // 3) Check multiple signs
    int num = 0;
    while(tokCmd[num] != NULL){
       num ++;
    }
    if(num > 2){
        fprintf(stderr, "Redirection misformatted.\n");
        fflush(stderr);
        return -1;
    }
    // Assigning filename
    redirPtr = strdup(tokCmd[num - 1]);
    // Split by " "
    char **dstFile = tokenizeCmd(tokCmd[1]);
    // 4) Check multiple dst files
    num = 0;
    while(dstFile[num] != NULL){
      num ++;
    }
    // printf("num (2nd time): %d\n", num);
    // printf("1: %s,\n 2: %s,\n 3: %s\n", dstFile[0], dstFile[1], dstFile[2]);
    if(num > 1){
        // printf("DEBUG: entring if\n");
        fprintf(stderr, "Redirection misformatted.\n");
        fflush(stderr);
        return -1;
    }
    // Terminating correctly
    return 0;
}

// Performs in place white space trimming
char *trimWhiteSpaces(char *s)
{
    // Second pointer for the end
    char *ep;
    // Trimming left side white space
    while (isspace((unsigned char)*s)) //using isspace
        s++;

    // If string contains nothing but white spaces
    if (*s == 0)
        return s;

    // Trimming right side white space
    ep = s + strlen(s) - 1;
    while (ep > s && isspace((unsigned char)*ep))
        ep--;

    // Writing '\0' to the end
    ep[1] = '\0';
    // Trimmed string
    return s;
}

void execRedir(char *fileName) {
    // Closing stdout & Handling FileIO

    char *cpyStr = trimWhiteSpaces(fileName);
    // printf("strncmp: %d\n", strcmp(cpyStr, "tests-out/tmp.txt"));
    // fflush(stdout);
    // char *dupFn = strdup(fileName);
    // int fptr = open(dupFn, O_WRONLY | O_TRUNC | O_CREAT, 00700);
    int fptr = open(cpyStr, O_WRONLY | O_TRUNC | O_CREAT, 00700);
    if(fptr == -1) {
        // printf("Don't Print!\n");
        // fflush(stdout);
        fprintf(stderr, "Cannot write to file %s.\n", fileName);
        fflush(stderr);
    }
    dup2(fptr, STDOUT_FILENO);
    // printf("fileName: %s\n fptr: %d\n", fileName, fptr);
    // fflush(stdout);
}

struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[256], int numTokens) {
    struct aliasLinkedList *currentNode = head;
    if (!strcmp(tokens[0], "alias\n")) {
        while (currentNode->next != NULL) {
            printf("%s %s", currentNode->key, currentNode->value);
            fflush(stdout);
            currentNode = currentNode->next;
        }
        return head;
    }

    /*If the user only types alias*/
    if (!strncmp(tokens[1], "alias\n", sizeof("alias")) ||
        !strncmp(tokens[1], "unalias\n", sizeof("unalias")) ||
        !strncmp(tokens[1], "exit\n", sizeof("exit"))) {
        write(2, "alias: Too dangerous to alias that.\n", sizeof("alias: Too dangerous to alias that.\n"));
        return head;
    }

    /* if of form command alias <alias-name> then numTokens == 2, so then only print that one alias */
    if (numTokens == 2) {
        while (currentNode->next != NULL) {
            if (!strncmp(currentNode->key, tokens[1], strlen((currentNode->key)) )) {
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
    if (temp == NULL) {
        write(2, "Error not enough memory\n", sizeof("Error not enough memory\n"));
        return head;
    }

    for (int i = 2; i < numTokens; i++) {
        temp = realloc(temp, strlen(aliasVal) + strlen(tokens[i]));
        if (temp == NULL) {
            write(2, "Error not enough memory\n", sizeof("Error not enough memory\n"));
            return head;
        }
        temp = strdup(aliasVal);
        strcat(temp, tokens[i]);

        if (i < numTokens - 1)
            strcat(temp, " ");
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
    if (head == NULL || *head == NULL) {
        head = malloc(sizeof(struct aliasLinkedList));
        (*head)->key = strdup(key);
        (*head)->value = strdup(value);
        (*head)->next = NULL;
    }

    while (currentNode->next != NULL) {
        if (!strcmp(currentNode->key, key)) break;
        currentNode = currentNode->next;
    }

    if (!strcmp(currentNode->key, key))
        currentNode->value = strdup(value);
    else {
        struct aliasLinkedList *newNode = malloc(sizeof(struct aliasLinkedList));
        newNode->key = malloc(sizeof(key));
        newNode->value = malloc(sizeof(value));
        newNode->key = strdup(key);
        newNode->value = strdup(value);
        newNode->next = *head;
        *head = newNode;
    }
}

void runUnalias(struct aliasLinkedList **headRef, char *cmd[], int numTokens) {
    if (numTokens > 2) {
        write(1, "unalias: Incorrect number of arguments.\n", sizeof("unalias: Incorrect number of arguments.\n"));
        return;
    }

    /*Edge Case: remove from head*/
    char *key = cmd[1];
    struct aliasLinkedList *head = *headRef;
    if (!strncmp(head->key, key, sizeof(*(head->key)))) {
        *headRef = (*headRef)->next;
        free(head);
        return;
    }

    /*Remove elsewhere*/
    struct aliasLinkedList *curr = head, *prev = head;
    while (curr != NULL) {
        if (!strncmp(curr->key, key, sizeof(*(curr->key)))) {
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
