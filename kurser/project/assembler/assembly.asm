# Draw diagonal line - demo

load_pm ime 3 16
load_pm ime 4 16
@start
load_pm ime 5 128
load_pm ime 6 6

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

load_pm ime 6 6
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
load_pm ime 6 7

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

load_pm ime 12 200
load_pm ime 14 6

# set points
load_pm ime 5 256
set_x0 5
set_y0 4
load_pm ime 5 128
set_x1 12
set_y1 5
set_col 14

# wait until the line is done
@wait_busy_3
is_busy 1
cmp ime 1 0
bne @wait_busy_3

# set points
load_pm ime 0 128
set_x0 0
set_y0 0
set_y1 0
load_pm ime 0 200
set_x1 0
load_pm ime 0 1
set_col 0

# wait until the line is done
@wait_busy_4
is_busy 1
cmp ime 1 0
bne @wait_busy_4


# Waiting loop for new frame
@wait_new_frame
is_new_frame 0
is_new_frame 0
cmp ime 0 1
bne @wait_new_frame
bra @start
