# Draw diagonal line - demo

load_pm ime 3 16
load_pm ime 4 16
@start
load_pm ime 5 128
load_pm ime 6 5

# Keyboard
get_keyboard 2
cmp ime 2 2
bne @not_A
sub ime 3 1
@not_A
cmp ime 2 8
bne @not_D
add ime 3 1
@not_D
cmp ime 2 1
bne @not_W
sub ime 4 1
@not_W
cmp ime 2 4
bne @not_S
add ime 4 1
@not_S

# set points
set_x0 3
set_y0 4
set_x1 5
set_y1 5
set_col 6

# wait until the line is done
@wait_busy_1
is_busy 1
cmp ime 1 0
bne @wait_busy_1

load_pm ime 5 256
load_pm ime 6 3

# set points
set_x0 3
set_y0 4
set_x1 5
set_y1 4
set_col 6

# wait until the line is done
@wait_busy_2
is_busy 1
cmp ime 1 0
bne @wait_busy_2

load_pm ime 12 128
load_pm ime 14 4

store dir 3 5
load_dm dir 10 5
sin dir 10 0

store dir 3 6
load_dm dir 11 6
cos dir 11 0

sub ime 10 350
#lsl ime 11 5

# set points
set_x0 10
set_y0 11
set_x1 12
set_y1 12
set_col 14

# wait until the line is done
@wait_busy_3
is_busy 1
cmp ime 1 0
bne @wait_busy_3

# Waiting loop for new frame
@wait_new_frame
is_new_frame 0
is_new_frame 0
cmp ime 0 1
bne @wait_new_frame
bra @start
