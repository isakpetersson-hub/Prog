#ifndef __LIB_SYSCALL_NR_H
#define __LIB_SYSCALL_NR_H

/* System call numbers. */
enum {
<<<<<<< HEAD
	/* Projects 2 and later. */
    SYS_SLEEP,     /* Sleep for x amount of ms */
=======
>>>>>>> c729e4de56dd29b9e233e64323761395fafa4584
	SYS_HALT,     /* Halt the operating system. */
	SYS_EXIT,     /* Terminate this process. */
	SYS_EXEC,     /* Start another process. */
	SYS_WAIT,     /* Wait for a child process to die. */
	SYS_CREATE,   /* Create a file. */
	SYS_REMOVE,   /* Delete a file. */
	SYS_OPEN,     /* Open a file. */
	SYS_FILESIZE, /* Obtain a file's size. */
	SYS_READ,     /* Read from a file. */
	SYS_WRITE,    /* Write to a file. */
	SYS_SEEK,     /* Change position in a file. */
	SYS_TELL,     /* Report current position in a file. */
	SYS_CLOSE,    /* Close a file. */

	// Not needed to be implemented for the labs
	SYS_MMAP,    /* Map a file into memory. */
	SYS_MUNMAP,  /* Remove a memory mapping. */
	SYS_CHDIR,   /* Change the current directory. */
	SYS_MKDIR,   /* Create a directory. */
	SYS_READDIR, /* Reads a directory entry. */
	SYS_ISDIR,   /* Tests if a fd represents a directory. */
	SYS_INUMBER, /* Returns the inode number for a fd. */

	SYS_NUMBER_OF_CALLS /* Needs to be last to be correct */
};

#endif /* lib/syscall-nr.h */
