# Draw with lsr - demo

load_pm ime 5 0
load_pm ime 6 240

load_pm ime 3 64
load_pm ime 4 64


@start
load_pm ime 7 5

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
set_y1 6
set_col 7

# wait until the line is done
@wait_busy_1
is_busy 1
cmp ime 1 0
bne @wait_busy_1

store dir 3 10
store dir 4 11

load_dm dir 8 10
load_dm dir 9 11

asr dir 8 0
asr dir 9 0


load_pm ime 7 4

# set points
set_x0 8
set_y0 9
set_x1 5
set_y1 6
set_col 7

# wait until the line is done
@wait_busy_2
is_busy 1
cmp ime 1 0
bne @wait_busy_2

store dir 8 12
store dir 9 13

load_dm dir 10 12
load_dm dir 11 13

asr dir 10 0
asr dir 11 0

load_pm ime 7 3

# set points
set_x0 10
set_y0 11
set_x1 5
set_y1 6
set_col 7

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
