#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

void batchMode();

char* prompt="mysh> \0";

int main(int argc, char* argv[]) {

    if(argc == 2)
        batchMode();

    //else run interactive mode
    char *s = malloc(512);
    while(1) {

        write(1, prompt, sizeof(prompt));
        fgets(s, 512, stdin);

        //write(1, s, sizeof(s));
        if(!strncmp(s, "exit", 4))
            break;

    }


    free(s);
}

void batchMode() {
    write(5, "batch", 5);
}