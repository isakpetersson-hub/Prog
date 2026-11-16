#include "list.h"

#include <stdio.h>
#include <stdlib.h>

#undef ASSERT
#define ASSERT(CONDITION)                               \
	if (CONDITION) {}                                   \
	else {                                              \
		printf("assertion `%s' failed.\n", #CONDITION); \
		exit(-1);                                       \
	}

/* Simple test to make sure that an empty list is treated as an empty list */
static void test_empty_list(void)
{
	/*  This is called a sentinel node. It's not really a part of the list,
	 *  it's just used to hold on to the list to be able to avoid certain
	 *  special cases in the list implementation, and to make the solution
	 *  slightly eaiser.
	 */
	struct list_elem root;
	root.value = -10;
	root.next = NULL;

	// Check that the list is seen as empty
	ASSERT(is_empty(&root));

	// Check to make sure get() returns -1 on empty list
	// 0 should be the first index
	ASSERT(get(&root, 0) == -1);
}

/*Test funtion for a list*/
static void test_list(void){
    struct list_elem root;
	root.value = -10;
	root.next = NULL;

    append(&root, 2);
    ASSERT(is_empty(&root) == false);
    ASSERT(get(&root,0) == 2);
    prepend(&root,8);
    print(&root);
    append(&root,5);
    print(&root);
    ASSERT(get(&root,1) == 2);
    ASSERT(get(&root,0) == 8);
    clear(&root);
    ASSERT(is_empty(&root));
}

static void test_sort_list(void){
    struct list_elem root;
	root.value = -10;
	root.next = NULL;

    input_sorted(&root,3);
    input_sorted(&root,1);
    input_sorted(&root,8);
    input_sorted(&root,6);
    input_sorted(&root,24);

    ASSERT(get(&root,0) == 1);
    ASSERT(get(&root,1) == 3);
    ASSERT(get(&root,2) == 6);
    ASSERT(get(&root,3) == 8);
    ASSERT(get(&root,4) == 24);
    clear(&root);

}

int main(void)
{
	/* Using functions to seperate out the test so they aren't affecting each
	 * other. */
	test_empty_list();
    test_list();
    test_sort_list();
	// Add calls to your test functions here!



	/* Strategy when writing tests:
	 * You will want to avoid having to type anything in when running the
	 * tests, so make sure your tests can run without user input.
	 * Avoid having the user visually confirm if something worked or not. (In
	 * other words: avoid using print() and asking the user to confirm.)
	 *
	 * With that said, writing automatic tests for the print function is fairly
	 * tricky and out of scope, so for that specific function, have the user of
	 * the test verify that the printed list matches some expected string.
	 *
	 * Once you have written some tests, you will want to keep them around, so
	 * that you build up your test suite over time. Hence why you want to build
	 * them without needing user input.
	 * Either use if-statements or the ASSERT macro to check the result.
	 *
	 * Keep in mind that ASSERT will terminate the program if the condition
	 * doesn't evaluate to true.
	 *
	 * Use seperate functions to test a specific function of your implenetation.
	 * Feel free to use the "test_empty_list()" function as an initial template.
	 *
	 * Remember to check with Valgrind for memory leaks!
	 */

	return 0;
}
