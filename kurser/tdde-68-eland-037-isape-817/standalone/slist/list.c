#include "list.h"
#include <stdio.h>
#include <stdlib.h>

/* Implement the functions here */
bool is_empty(struct list_elem const *root) {
    return (root->next == NULL);
}

int get(struct list_elem const *root, int idx) {
    if (is_empty(root)) return -1;
    struct list_elem *curr = root->next;
    for (int i = 0; i < idx; i++) {
        if (curr->next == NULL) {
            return -1;
        }
        curr = curr->next;
    }
    return curr->value;
}

void append(struct list_elem *root, int x){
    struct list_elem *new = malloc(sizeof *new);
    new->value = x;
    new->next = NULL;
    if (is_empty(root)){
        root->next = new;
    }else{
        struct list_elem *curr = root->next;
        while(curr->next != NULL){
            curr = curr->next;
        }
        curr->next = new;
    }
} 

void prepend(struct list_elem *root, int x) {
    struct list_elem *new = malloc(sizeof *new);
    new->value = x;
    new->next = root->next;
    root->next = new;
}

void input_sorted(struct list_elem *root, int x){
    struct list_elem *new = malloc(sizeof *new);
    new->value = x;
    struct list_elem *curr = root->next;
    if (is_empty(root)){
        new->next = NULL;
        root->next = new;
    } else if (curr->value > x){
        prepend(root,x);
        free(new);
    }
    else {
        while(curr->next != NULL && curr->next->value < x){
            curr = curr->next;
        }
        new->next = curr->next;
        curr->next = new;
    }
}

void print(struct list_elem const *root){
    struct list_elem *curr = root->next;
    while(curr != NULL){
        printf("%d", curr->value);
        curr = curr->next;
    }
}

void clear(struct list_elem *root){
    if (is_empty(root)){
        return;
    }
    struct list_elem *curr = root->next;
    struct list_elem *after = curr->next;
    while(after->next != NULL){
        free(curr);
        curr = after;
        after = after->next;
    }
    root->next = NULL;
    free(curr);
    free(after);
}
