# Center screen
load_pm ime 4 160
load_pm ime 5 120
store dir 4 4
store dir 5 5

# a++
@start
load_dm dir 6 6

# load x y pos
load_dm dir 10 10
load_dm dir 11 11

# Keyboard
get_keyboard 2
cmp ime 2 2
bne @not_A
sub ime 6 3
@not_A
cmp ime 2 8
bne @not_D
add ime 6 3
@not_D

store dir 6 6 
# calculate move direction
load_dm dir 12 6
cos dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0
asr dir 12 0

load_dm dir 13 6
sin dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0
asr dir 13 0

store dir 12 12
store dir 13 13

# more keyboard W S
cmp ime 2 1
bne @not_W
add dir 10 12
add dir 11 13
@not_W
cmp ime 2 4
bne @not_S
sub dir 10 12
sub dir 11 13
@not_S

# more keyboard Q E
cmp ime 2 16
bne @not_Q
add dir 10 13
sub dir 11 12
@not_Q
cmp ime 2 32
bne @not_E
sub dir 10 13
add dir 11 12
@not_E

# st0re x y pos
store dir 10 10
store dir 11 11

# color
load_pm ime 7 7

# get a
load_dm dir 8 6
load_dm dir 9 6

# x coordinade
cos dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
add dir 8 10 # add offset pos
add dir 8 4 # add offset center screen

# y coordinate
sin dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
add dir 9 11 # add offset pos
add dir 9 5  # add offset center screen

load_dm dir 14 4
load_dm dir 15 5
add dir 14 10
add dir 15 11

# set points
set_x0 14
set_y0 15
set_x1 8
set_y1 9
set_col 7


# Waiting loop for new frame
@wait_new_frame
is_new_frame 0
is_new_frame 0
cmp ime 0 1
bne @wait_new_frame
bra @start
