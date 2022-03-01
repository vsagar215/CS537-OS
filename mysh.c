#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

void batchMode();
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

    if(argc == 2)
        batchMode();

    //else run interactive mode
    char *s = malloc(512);
    //char *eof = malloc(4);

    //TODO: Handle breaking when user presses ctrl+d
    while(1) {

        /* prompt user to enter & immediately exit if exit typed */
        write(1, prompt, sizeof(prompt));
        fgets(s, 512, stdin);
        //eof = fgets(s, 512, stdin);

        //write(1, s, sizeof(s));
        if(!strncmp(s, "exit", 4))
            break;

        /* run appropriate program based on input */
        if(!strncmp(s, "alias", 4))
            runAlias(s);


    }


    free(s);
    //free(eof);
}

void batchMode() {
    write(5, "batch", 5);
}

void runAlias(char *cmd) {


    return;
}