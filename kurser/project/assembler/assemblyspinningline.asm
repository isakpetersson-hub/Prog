# Draw with sin & cos - demo

# Center screen
load_pm ime 4 160
load_pm ime 5 120
store dir 4 4
store dir 5 5

# t++
@start
load_dm dir 6 6
add ime 6 1
store dir 6 6 

# color
load_pm ime 7 7

# get t
load_dm dir 8 6
load_dm dir 9 6

# x coordinade
cos dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
asr dir 8 0
add ime 8 160

# y coordinate
sin dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
asr dir 9 0
add ime 9 120

# set points
set_x0 4
set_y0 5
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
