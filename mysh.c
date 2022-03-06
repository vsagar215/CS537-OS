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
struct aliasLinkedList *runUnalias(struct aliasLinkedList *head, char *cmd[], int numTokens);
void addNode(struct aliasLinkedList **head, char *key, char *value);
void removeNode(struct aliasLinkedList **head, char *key);
int delAtPos(struct aliasLinkedList *head, int position);
void delMid(struct aliasLinkedList *head, char *passedVal);
int findPos(struct aliasLinkedList *head, char* key);


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
            runUnalias(head, tokens, numTokens);
        }
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

struct aliasLinkedList* runAlias(struct aliasLinkedList *head, char *tokens[256], int numTokens) {
    /*If the user only types alias*/
    //must compare with newline as it is read in by fgets(...)
    //TODO: Handle this
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
    addNode(&head, tokens[1], aliasVal);
    free(curr);
    return head;
}

struct aliasLinkedList *runUnalias(struct aliasLinkedList *head, char *cmd[], int numTokens) {
    if(numTokens > 2) {
        write(1, "unalias: Incorrect number of arguments.\n", sizeof("unalias: Incorrect number of arguments.\n"));
        return head;
    }
    //removeNode(&head, cmd[1]);

    delMid(head, cmd[1]);

    return head;
}


void addNode(struct aliasLinkedList **head, char *key, char *value) {
    struct aliasLinkedList *currentNode = *head;
    if(head == NULL) {
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
        newNode->key   = strdup(key);
        newNode->value = strdup(value);
        newNode->next  = *head;
        *head = newNode;
    }
}


void removeNode(struct aliasLinkedList **head, char *key) {
    if(head == NULL || *head == NULL || key == NULL)
        return;

    struct aliasLinkedList *curr = *head, *prev = NULL;
    /*Edge case: removing head*/
    if(curr !=NULL && !strncmp(curr->key, key, sizeof(*(curr->key))) ) {
        *head = curr->next;
        free(curr);
        return;
    }

    while(curr != NULL && !strncmp(curr->key, key, sizeof(*(curr->key)))) {
        prev = curr;
        curr = curr->next;
    }

    if(curr == NULL)
        return;
    prev->next = curr->next;


    //while(curr != NULL && curr->next != NULL) {
        //if(!strcmp(curr->next->key, key)) {
            //printf("curr: %s %s \n", curr->key, curr->value);
            //printf("to remove: %s %s \n\n", curr->next->key, curr->next->value);

            //curr->next = curr->next->next;
            //return;
        //}
        //curr = curr->next;
    //}
    free(curr);
}


int delAtPos(struct aliasLinkedList *head, int position)
{
	// Checking if list is empty
	if (head == NULL)
	{
		printf("ERROR: List empty\n");
		return 0;
	}

	struct aliasLinkedList *curr, *prev;
	int i; // index for both pointers
	// Assigning both pointers to head
	curr = head;
	prev = head;

	// Iterating till the position of iterest
	for (i = 2; i < position + 1; ++i)
	{
		// Iterating untill one before node to delete
		prev = curr;
		// Iterating to the node to delete
		curr = curr->next;

		// Reaching end of list
		if (curr == NULL)
		{
			break;
		}
	}

    //if(curr !=NULL && !strncmp(curr->key, key, sizeof(*(curr->key))) ) {
        //*head = curr->next;
        //free(curr);
        //return 1;
    //}
	// Deleting from the front
	if (curr == head) {
		head = curr->next;
        free(curr);
        return 1;
    }

	prev->next = curr->next;
	curr->next = NULL;

	// Freeing the nth node
	free(curr);
	return 1;
}

// Deleting a node based on value
void delMid(struct aliasLinkedList *head, char *passedVal)
{
	int pos = findPos(head, passedVal);
	if (pos == 0)
	{
		printf("ERROR: Node to be deleted not in List\n");
		return;
	}

	if (1 == delAtPos(head, pos))
	{
		printf("Deleted successfully\n");
	}
	else
	{
		printf("Position invalid\n");
	}
}

// Returning position of element to delete
int findPos(struct aliasLinkedList *head, char* key)
{
	struct aliasLinkedList *curr = NULL;
	curr = head;
	int counter = 0;

	while (curr != NULL)
	{
		counter++;
		if (strncmp(curr->key, key, sizeof(*(curr->key))) == 0)
		{
			return counter;
		}

		// If not element, iter till end
		curr = curr->next;
	}
	return 0;
}