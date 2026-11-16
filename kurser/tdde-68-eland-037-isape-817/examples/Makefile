SRCDIR = ..

# Example programs to compile, and a list of sources for each.
# To add a new test, put its name on the PROGS list
# and then add a name_SRC line that lists its source files.
PROGS = cat cmp cp echo halt hex-dump rm \
	lineup recursor stack-setup basic-syscall exec-loop exec-simple \
	printf noop

# The example files should start to work as intended in the following order: 
# Should work once the main-stack is correctly setup (Lab 1)
noop_SRC = noop.c

# Should work once the write() syscall is implemented (Lab 2)
stack-setup_SRC = stack-setup.c

# Should work once the basic system call handler is implemented (Lab 2)
basic-syscall_SRC = basic-syscall.c
printf_SRC = printf.c
cat_SRC = cat.c
cmp_SRC = cmp.c
cp_SRC = cp.c
echo_SRC = echo.c
halt_SRC = halt.c
hex-dump_SRC = hex-dump.c
lineup_SRC = lineup.c
rm_SRC = rm.c

# Should work once exec() is implemented (Lab 4)
exec-loop_SRC = exec-loop.c
exec-simple_SRC = exec-simple.c

# Should work once wait() is implemented (Lab 5)
recursor_SRC = recursor.c
#rrecursor_ng_SRC = recursor_ng.c

include $(SRCDIR)/Make.config
include $(SRCDIR)/Makefile.userprog
