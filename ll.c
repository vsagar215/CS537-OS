#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct aliasLL
{
	char *key;
	char *value;
	struct aliasLL *next;
};

// Adding from top
void push(struct aliasLL **head, char *key, char *value)
{
	// Making and alloc mem for newNode
	struct aliasLL *newNode = NULL;
	newNode = (struct aliasLL *)malloc(sizeof(struct aliasLL));

	if (newNode == NULL)
	{
		printf("ERROR: Cannot push element, out of memory!\n");
	}

	// Init newNode with passed value
	newNode->key = key;
	newNode->value = value;

	// Adding newNode before the head
	newNode->next = *head;

	// Making newNode the head
	*head = newNode;
}

// Returning position of element to delete
int findPos(struct aliasLL *head, char* key)
{
	struct aliasLL *curr = NULL;
	curr = head;
	int counter = 0;

	while (curr != NULL)
	{
		counter++;
		if (strcmp(curr->key, key) == 0)
		{
			return counter;
		}

		// If not element, iter till end
		curr = curr->next;
	}
	return 0;
}

// Deleting from a position
int delAtPos(struct aliasLL *head, int position)
{
	// Checking if list is empty
	if (head == NULL)
	{
		printf("ERROR: List empty\n");
		return 0;
	}

	struct aliasLL *curr, *prev;
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

	// Deleting from the front
	if (curr == head)
		head = head->next;

	prev->next = curr->next;
	curr->next = NULL;

	// Freeing the nth node
	free(curr);
	return 1;
}

// Deleting a node based on value
void delMid(struct aliasLL *head, char *passedVal)
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

// Prints the LinkedList
void printLL(struct aliasLL *head)
{
	// Noding used for iterating
	struct aliasLL *curr = NULL;
	curr = head;

	// Going until the end of the list
	while (curr != NULL)
	{

		printf("%s:%s -> ", curr->key, curr->value);
		curr = curr->next;
	}

	printf("NULL\n");
}

int main()
{
	struct aliasLL *head = NULL;

	push(&head, "key1", "foo");
	push(&head, "key2", "bar");
	push(&head, "key3", "foobar");
	push(&head, "key4", "foo-bar");

	printf("Initial Linked List\n");
	printLL(head);
	printf("\n");
	printf("Deleting key3\n");
	delMid(head, "key3");
	printLL(head);
	printf("\n");
	printf("Deleting key1\n");
	delMid(head, "key1");
	printLL(head);

	return 0;
}
