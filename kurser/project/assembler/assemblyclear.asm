@loop
store dir 1 0

add ime 0 1
cmp ime 0 1024
bne @out
bra @loop

@out


set_x0 0
set_y0 0
set_x1 0
set_y1 0
set_col 0

load_pm ime 0 0
load_pm ime 1 0
load_pm ime 2 0
load_pm ime 3 0
load_pm ime 4 0
load_pm ime 5 0
load_pm ime 6 0
load_pm ime 7 0
load_pm ime 8 0
load_pm ime 9 0
load_pm ime 10 0
load_pm ime 11 0
load_pm ime 12 0
load_pm ime 13 0
load_pm ime 14 0
load_pm ime 15 0
