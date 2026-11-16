#include <syscall.h>

/* Now this is a fun file to read. If you find this, you've been told a white
 * lie about the fact that `main()` is called first when starting a program,
 * technically true, but the OS drops you into this (or similar) entry point,
 * which in turn calls main(). 
 *
 * Task for the reader, why though?
 */

int main(int, char *[]);
void _start(int argc, char *argv[]);

void _start(int argc, char *argv[])
{
	exit(main(argc, argv));
}
