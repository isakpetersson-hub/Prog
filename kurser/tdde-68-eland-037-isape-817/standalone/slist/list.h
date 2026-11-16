#ifndef LIST_H
#define LIST_H

#include <stdbool.h>

struct list_elem {
	int value;
	struct list_elem *next;
};

/* Returns the value found at index idx.
 * If the given index doesn't exist, returns -1. */
int get(struct list_elem const *root, int idx);

/* Return true if the list is empty, false otherwise */
bool is_empty(struct list_elem const *root);

/* Puts x at the end of the list */
void append(struct list_elem *root, int x);

/* Puts x at the start of the list */
void prepend(struct list_elem *root, int x);

/* Find the element in the list larger than x and
 * put x right before that element */
void input_sorted(struct list_elem *root, int x);

/* Prints all elements in the list */
void print(struct list_elem const *root);

/* Free everything that is dynamically allocated */
void clear(struct list_elem *root);

#endif
