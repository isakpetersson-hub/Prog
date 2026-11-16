/* Simple program that opens a file an purposfully crashes before
 * calling SYS_EXIT
 */

#include "files.h"
#include "tests/lib.h"

#include <syscall.h>

char const *test_name = "no-close";

int main(void)
{
	int fd = open(FILE_NAME);
	if (fd == -1) {
		fail("open %s", FILE_NAME);
	}

	msg("Will crash now. This is expected.");
	msg("The message about page fault will be ignored by the tests.");
	int volatile *ptr = NULL;
	*ptr = 1; // Writes to NULL, will crash.
	fail("should have exited with -1");
}
