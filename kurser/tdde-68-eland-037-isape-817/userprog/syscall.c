#include "userprog/syscall.h"

#include "threads/interrupt.h"
#include "threads/thread.h"

#include <stdint.h>
#include <stdio.h>
#include <syscall-nr.h>
#include <devices/shutdown.h>
#include <devices/timer.h>
#include <filesys/filesys.h>
#include <filesys/file.h>
#include <lib/stdio.h>
#include <devices/input.h>
#include <userprog/process.h>
#include <stdlib.h>
#include <threads/vaddr.h>
#include <userprog/pagedir.h>

static void syscall_handler(struct intr_frame *);

void syscall_init(void)
{
	intr_register_int(0x30, 3, INTR_ON, syscall_handler, "syscall");
}
/* This array defines the number of arguments each syscall expects.
   For example, if you want to find out the number of arguments for
   the read system call you can write:

   int sys_read_arg_count = ARGC[ SYS_READ ];

   All system calls have a name such as SYS_READ defined as an enum
   type, see `lib/syscall-nr.h'. Use them instead of numbers.

   The code below uses explicit indices to make it easier to verify
   that the correct value is used for the correct syscall. The syntax
   [x] = y used below means that index x in the array will be given
   the value y. That is ARGC[x] will equal y.
 */
int const ARGC[] = {
	/* basic calls */
	[SYS_HALT] = 0,
	[SYS_EXIT] = 1,
	[SYS_EXEC] = 1,
	[SYS_WAIT] = 1,
	[SYS_CREATE] = 2,
	[SYS_REMOVE] = 1,
	[SYS_OPEN] = 1,
	[SYS_FILESIZE] = 1,
	[SYS_READ] = 3,
	[SYS_WRITE] = 3,
	[SYS_SEEK] = 2,
	[SYS_TELL] = 1,
	[SYS_CLOSE] = 1,
	/* extended, you'll add these. Uncomment when you have added them to syscall-nr. */
	/* [SYS_SLEEP] = 1, */

	/* not implemented */
	[SYS_MMAP] = 2,
	[SYS_MUNMAP] = 1,
	[SYS_CHDIR] = 1,
	[SYS_MKDIR] = 1,
	[SYS_READDIR] = 2,
	[SYS_ISDIR] = 1,
	[SYS_INUMBER] = 1,
	/* extended, you'll add these. Uncomment when you have added them to syscall-nr. */
	[SYS_SLEEP] = 1,
	/* Explicitly set NUMBER_OF_CALLS to make the array large enough and catch errors */
	[SYS_NUMBER_OF_CALLS] = 21
};

static void halt(void){
    shutdown_power_off();
    return;
}

static void exit(int status){
    struct thread* t = thread_current();
    t->pi->exit_status = status;
    thread_exit();
}

static void sleep(int milis){
    timer_msleep(milis);
    return;
}

static bool create (char const *file, unsigned initial_size){
    return filesys_create(file, initial_size);
}

static int open (char const *file) {
    struct file *tmpFile = filesys_open(file);
    if (tmpFile != NULL) {
        int tmp_fd = fd_create(tmpFile);
        if (tmp_fd == -1) {
            file_close(tmpFile);
        }
        return tmp_fd;
    }
    return -1;
}

static void close (int fd) {
    if (fd == STDIN_FILENO || fd == STDOUT_FILENO) exit(-1);
    struct file *tmpFile = fd_get(fd);
    if (tmpFile == NULL) return;
    file_close(tmpFile);
    fd_close(fd);
    return;
}

static int read (int fd, void *buffer, unsigned size) {   
    if(fd == STDOUT_FILENO){
        return -1;
    }
    else if (fd == STDIN_FILENO){
        for (unsigned int i = 0; i < size; i++){
            char letter = input_getc();
            if (letter == '\r'){
                letter = '\n';
            }
            putbuf(&letter,1);
            ((char*)buffer)[i] = letter;
        }

        return size;
    }

    struct file* file = fd_get(fd);

    if (file == NULL){
        return -1;
    }
    else{
        return file_read(file, (char*)buffer, size);
    }
}

static int write(int fd, void const *buffer, unsigned size){
    if (fd == STDIN_FILENO){
        return -1;
    }
    else if (fd == STDOUT_FILENO){
        putbuf((char*)buffer,size);
        return size;
    }

    struct file* file = fd_get(fd);

    if (file == NULL){
        return -1;
    } else {
        return file_write(file, (void*)buffer, size);
    }
}

static bool remove (char const *file_name) {
    return filesys_remove(file_name);
}

static int filesize (int fd) {
    struct file *tmpFile = fd_get(fd);
    if (tmpFile == NULL) return -1;
    return file_length(tmpFile);
}

static void seek (int fd, unsigned position){
    struct file *tmpFile = fd_get(fd);
    if(tmpFile != NULL && position < (unsigned)filesize(fd) ) {
        file_seek(tmpFile,position);
    }
}

static unsigned tell (int fd){
    struct file *tmpFile = fd_get(fd);
    if(tmpFile != NULL) {
        return file_tell(tmpFile);
    }
    return -1;
}

static pid_t exec (char const *cmd_line){ 
    int temp = process_execute(cmd_line);
    return temp;
}

static int wait (pid_t pid) {
    return process_wait(pid);
}

/*
static bool is_vailid_pointer(const void* pointer){
    if (pointer == NULL || !is_user_vaddr(pointer)) {
        return false;
    }

    const uint8_t *byte_potiner = (const uint8_t *) pointer;
    
    for (int i = 0; i < 4; i++){
        if (pagedir_get_page(thread_current()->pagedir, byte_potiner + i) == NULL){
            return false;
        }
    }
    
    return true;
}
*/

static void valid_byte(const void *byte) {
    if (byte == NULL || !is_user_vaddr (byte) || pagedir_get_page(thread_current()->pagedir, byte) == NULL){
        exit(-1);
    }
}

static void vailid_buffer(void *buffer, unsigned size){
    if (buffer == NULL){
        exit(-1);
    }

    void* start = pg_round_down(buffer);
    void* end = pg_round_up(buffer + size - 1);

    for (void* page = start; page < end; page += PGSIZE){
        valid_byte(page);
    }
}

static void vailid_string(const char *string){
    void* currentPage = pg_round_down(string);
    valid_byte(string);
    while (*string != '\0')
    {
        if (pg_round_down(string) != currentPage){
            valid_byte(string);
            currentPage = pg_round_down(string);
        }
        string++;
    }
}

static void validate_stack(int32_t * esp, struct intr_frame *f){
    //valid_byte(f->esp);
    vailid_buffer(f->esp, 4);
    if(esp[0]<0 || esp[0] >= SYS_NUMBER_OF_CALLS) exit(-1);
    vailid_buffer(f->esp, ((1+ARGC[esp[0]]) * 4));
}

static void syscall_handler(struct intr_frame *f)
{
    int32_t *esp = (int32_t *) f->esp;
    validate_stack(esp,f);

    switch (esp[0])
    {
    case SYS_SLEEP:
        sleep(esp[1]);
        break;
    case SYS_HALT:
        halt();
        break;
    case SYS_EXIT:
        exit(esp[1]);
        break;
    case SYS_EXEC:
        vailid_string((const char *)esp[1]);
        f->eax = exec((const char *)esp[1]);
        break;
    case SYS_WAIT:
        f->eax = wait(esp[1]);
        break;
    case SYS_CREATE:
        vailid_string((const char *)esp[1]);
        f->eax = create((const char *)esp[1],esp[2]);
        break;
    case SYS_REMOVE:
        vailid_string((const char *)esp[1]);
        f->eax = remove((const char *)esp[1]);
        break;
    case SYS_OPEN:
        vailid_string((const char *)esp[1]);
        f->eax = open((const char *)esp[1]);
        break;
    case SYS_FILESIZE:
        f->eax = filesize(esp[1]);
        break;
    case SYS_READ:
        vailid_buffer((void *)esp[2], esp[3]);
        f->eax = read(esp[1],(void *)esp[2],esp[3]);
        break;
    case SYS_WRITE:
        vailid_buffer((void *)esp[2], esp[3]);
        f->eax = write(esp[1],(void *)esp[2],esp[3]);
        break;
    case SYS_SEEK:
        seek(esp[1],esp[2]);
        break;
    case SYS_TELL:
        f->eax = tell(esp[1]);
        break;
    case SYS_CLOSE:
        close(esp[1]);
        break;
    default:
        thread_exit();
        break;
    }
	//printf("system call!\n");
	// Consider: esp[1] is just syntactic sugar for
	// *(esp + 1 * sizeof(int32_t))
	// Which one is easier to read?
	//printf("Stack top + 0: %d\n", esp[0]);
	
}
