#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void batchMode();

char* prompt="mysh> \0";

int main(int argc, char* argv[]) {

    if(argc == 2)
        batchMode();

    //else run interactive mode
    //char* y = "hi";
    //int x = write(1, "int", sizeof(y));

    char *s = malloc(512);
    while(1) {
       write(1, prompt, sizeof(prompt));
       fgets(s, 512, stdin);
       //printf("%s", s);
       break;
    }


    free(s);
}

void batchMode() {
    write(5, "batch", 5);
}
