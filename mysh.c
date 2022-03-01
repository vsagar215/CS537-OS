#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

void batchMode();
void parseInput(char *cmd); //TODO: Figure out actual return type
void runAlias(char *cmd);

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

int main(int argc, char* argv[]) {

    //TODO: Handle batch mode
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
            runAlias(cmd);
    }
    free(cmd);
    return 0;
}

void batchMode() {
    write(5, "batch", 5);
}

void parseInput(char *cmd) {
    //char *t = strtok(cmd, " ");
    //printf("%s", t);
    //fflush(stdout);
}

void runAlias(char *cmd) {

    /*If the user only types alias*/
    //must compare with newline as it is read in by fgets(...)
    //TODO: Handle this
    if(!strcmp(cmd, "alias\n")){
        write(1, "cool", sizeof("cool"));
        return;
    }


    parseInput(cmd);

    return;
}