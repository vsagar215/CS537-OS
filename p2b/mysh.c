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
int parseInput(char *tokens[TOKEN_NUMBER], char *cmd);													   // returns number of tokens
struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[TOKEN_NUMBER], int numTokens); // TODO: change cmd to *cmd[]
struct aliasLinkedList *runUnalias(struct aliasLinkedList *head, char *cmd[], int numTokens);

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
		if (!strncmp(cmd, "alias", 5))
			head = runAlias(head, tokens, numTokens);
		else if (!strncmp(cmd, "unalias", 7))
		{
			head = runUnalias(head, tokens, numTokens);
		}
	}

	// TODO: Free the linked list??

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

struct aliasLinkedList *runAlias(struct aliasLinkedList *head, char *tokens[TOKEN_NUMBER], int numTokens)
{
	/*If the user only types alias*/
	// must compare with newline as it is read in by fgets(...)
	// TODO: Handle this
	struct aliasLinkedList *currentNode = head;
	if (!strcmp(tokens[0], "alias\n"))
	{
		while (currentNode->next != NULL)
		{
			printf("%s %s", currentNode->key, currentNode->value);
			fflush(stdout);
			currentNode = currentNode->next;
		}
		return head;
	}

	/* if of form command alias <alias-name> then numTokens == 2, so then only print that one alias */
	if (numTokens == 2)
	{
		while (currentNode->next != NULL)
		{
			if (!strncmp(currentNode->key, tokens[1], sizeof(*(currentNode->key))))
			{
				printf("%s %s", currentNode->key, currentNode->value);
				fflush(stdout);
				// write(1, currentNode->value, sizeof(currentNode->value));
				return head;
			}
			currentNode = currentNode->next;
		}
		return head;
	}

	/* build the value of the alias */
	char *aliasVal = "\0", *curr = NULL; //,*alias = tokens[1]; // the alias to add/replace will always be index 1
	for (int i = 2; i < numTokens; i++)
	{
		curr = realloc(curr, sizeof(aliasVal) + sizeof(tokens[i]) + 1); // potential issues for memory leak here, curr can be null
		if (i < numTokens - 1)
			strcat(strcat(curr, tokens[i]), " "); // append the current arg with a " " at the end
		else
			strcat(curr, tokens[i]);
		aliasVal = curr;
	}

	/*
	 * Iterate through nodes until
	 * 1) Find a node with the current alias
	 * 2) Reach the end
	 */

	if (head == NULL)
	{
		head = malloc(sizeof(struct aliasLinkedList));
		head->key = strdup(tokens[1]);
		head->value = strdup(aliasVal);
		head->next = NULL;
		return head;
	}

	while (currentNode->next != NULL)
	{
		if (!strcmp(currentNode->key, tokens[1]))
			break;
		currentNode = currentNode->next;
	}

	if (!strcmp(currentNode->key, tokens[1]))
		currentNode->value = strdup(aliasVal);
	else
	{
		struct aliasLinkedList *newNode = malloc(sizeof(struct aliasLinkedList));
		newNode->key = strdup(tokens[1]);
		newNode->value = strdup(aliasVal);
		newNode->next = head;
		head = newNode;
	}
	free(curr);
	return head;
}

struct aliasLinkedList *runUnalias(struct aliasLinkedList *head, char *cmd[], int numTokens)
{
	struct aliasLinkedList *currentNode = head, *previous = head;
	if (numTokens > 2)
	{
		write(1, "unalias: Incorrect number of arguments.\n", sizeof("unalias: Incorrect number of arguments.\n"));
		return head;
	}

	while (currentNode->next != NULL)
	{
		if (!strncmp(currentNode->key, cmd[1], sizeof(*(currentNode->key))))
		{
			/*found the thing to unalias*/

			if (previous == currentNode)
			{
				previous = currentNode->next;
				return head;
			}

			previous->next = currentNode->next;
			free(currentNode);
			return head;
		}
		previous = currentNode;
		currentNode = currentNode->next;
	}
	return head;
}