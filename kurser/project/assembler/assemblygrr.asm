# ==============================================
#  3D Spinning Cube
#  W/S=pitch  A/D=yaw  Q/E=scale
#  Vertices at +-32, /64 fixed point
# ==============================================
 
# Init angles, scale, color
load_pm ime 8 0
load_pm ime 9 0
load_pm ime 10 256
load_pm ime 12 7
 
# Store cube vertices DM[0..23], half-side=32
load_pm ime 0 -32
store dir 0 0
load_pm ime 0 -32
store dir 0 1
load_pm ime 0 -32
store dir 0 2
load_pm ime 0 32
store dir 0 3
load_pm ime 0 -32
store dir 0 4
load_pm ime 0 -32
store dir 0 5
load_pm ime 0 32
store dir 0 6
load_pm ime 0 32
store dir 0 7
load_pm ime 0 -32
store dir 0 8
load_pm ime 0 -32
store dir 0 9
load_pm ime 0 32
store dir 0 10
load_pm ime 0 -32
store dir 0 11
load_pm ime 0 -32
store dir 0 12
load_pm ime 0 -32
store dir 0 13
load_pm ime 0 32
store dir 0 14
load_pm ime 0 32
store dir 0 15
load_pm ime 0 -32
store dir 0 16
load_pm ime 0 32
store dir 0 17
load_pm ime 0 32
store dir 0 18
load_pm ime 0 32
store dir 0 19
load_pm ime 0 32
store dir 0 20
load_pm ime 0 -32
store dir 0 21
load_pm ime 0 32
store dir 0 22
load_pm ime 0 32
store dir 0 23
 
# ==============================================
#  MAIN LOOP
# ==============================================
@start
 
# Read keyboard (GR11 = bitmask)
get_keyboard 11
 
cmp ime 11 1
bne @nW
sub ime 9 4
@nW
cmp ime 11 2
bne @nA
sub ime 8 4
@nA
cmp ime 11 4
bne @nS
add ime 9 4
@nS
cmp ime 11 8
bne @nD
add ime 8 4
@nD
cmp ime 11 16
bne @nQ
sub ime 10 32
@nQ
cmp ime 11 32
bne @nE
add ime 10 32
@nE
 
# Clamp scale [64,1024]
cmp ime 10 64
bne @smn
load_pm ime 10 64
@smn
cmp ime 10 1024
bne @smx
load_pm ime 10 1024
@smx
 
# Wrap yaw [0,359]
cmp ime 8 0
bne @yp
add ime 8 360
@yp
cmp ime 8 360
bne @yl
sub ime 8 360
@yl
 
# Wrap pitch [0,359]
cmp ime 9 0
bne @pp
add ime 9 360
@pp
cmp ime 9 360
bne @pl
sub ime 9 360
@pl
 
# Precompute trig
store dir 8 205
store dir 9 206
load_dm ime 13 205
cos ime 13 0
store dir 13 200
load_dm ime 13 205
sin ime 13 0
store dir 13 201
load_dm ime 13 206
cos ime 13 0
store dir 13 202
load_dm ime 13 206
sin ime 13 0
store dir 13 203
store dir 10 204
 
# ==============================================
#  Vertex loop: rotate + project 8 vertices
#  DM[106]=vert_ptr, DM[107]=proj_ptr, DM[108]=count
# ==============================================
load_pm ime 0 0
store dir 0 106
load_pm ime 0 24
store dir 0 107
load_pm ime 0 0
store dir 0 108
 
@vloop
 
# Load x via indd through DM[106]
load_dm indd 0 106
# Load y: ptr+1 via temp
load_dm ime 13 106
add ime 13 1
store dir 13 109
load_dm indd 1 109
# Load z: ptr+2
add ime 13 1
store dir 13 109
load_dm indd 2 109
 
# Save ry_raw (=y) for X-rotation later
store dir 1 102
 
# Y-rotation:
#   GR5 = rx = x*cosY/64 - z*sinY/64
add ime 0 0
mult dir 3 200
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
add ime 2 0
mult dir 4 201
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
store dir 4 100
store dir 3 109
load_dm ime 5 109
sub dir 5 100
store dir 5 101
 
#   DM[103] = rz = x*sinY/64 + z*cosY/64
add ime 0 0
mult dir 3 201
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
add ime 2 0
mult dir 4 200
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
store dir 4 100
add dir 3 100
store dir 3 103
 
# X-rotation:
#   Load ry, rz
load_dm ime 6 102
load_dm ime 7 103
 
#   GR3 = ry*cosX/64
add ime 6 0
mult dir 3 202
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
asr ime 3 1
 
#   GR4 = rz*sinX/64
add ime 7 0
mult dir 4 203
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
asr ime 4 1
 
#   ry2 = GR3 - GR4 -> GR6
store dir 4 100
store dir 3 109
load_dm ime 6 109
sub dir 6 100
 
# Project: screen_x = rx2*scale/64 + 320
#          screen_y = ry2*scale/64 + 240
#   rx2 is in DM[101] (= rx from Y-rotation, unchanged by X-rot)
load_dm ime 5 101
add ime 5 0
mult dir 0 204
asr ime 0 1
asr ime 0 1
asr ime 0 1
asr ime 0 1
asr ime 0 1
asr ime 0 1
add ime 0 320
add ime 6 0
mult dir 1 204
asr ime 1 1
asr ime 1 1
asr ime 1 1
asr ime 1 1
asr ime 1 1
asr ime 1 1
add ime 1 240
 
# Store projected coords via proj_ptr
load_dm ime 13 107
store dir 0 109
store indd 0 107
# proj_ptr+1 for py
add ime 13 1
store dir 13 109
store indd 1 109
 
# Advance pointers
load_dm ime 13 106
add ime 13 3
store dir 13 106
load_dm ime 13 107
add ime 13 2
store dir 13 107
load_dm ime 13 108
add ime 13 1
store dir 13 108
 
# Loop 8 times
cmp ime 13 8
bne @vloop
 
# ==============================================
#  Draw 12 edges (unrolled for simplicity)
# ==============================================
# Edge 0: v0->v1
load_dm ime 0 24
load_dm ime 1 25
load_dm ime 2 26
load_dm ime 3 27
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e0
is_busy 15
cmp ime 15 0
bne @wb_e0
 
# Edge 1: v1->v2
load_dm ime 0 26
load_dm ime 1 27
load_dm ime 2 28
load_dm ime 3 29
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e1
is_busy 15
cmp ime 15 0
bne @wb_e1
 
# Edge 2: v2->v3
load_dm ime 0 28
load_dm ime 1 29
load_dm ime 2 30
load_dm ime 3 31
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e2
is_busy 15
cmp ime 15 0
bne @wb_e2
 
# Edge 3: v3->v0
load_dm ime 0 30
load_dm ime 1 31
load_dm ime 2 24
load_dm ime 3 25
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e3
is_busy 15
cmp ime 15 0
bne @wb_e3
 
# Edge 4: v4->v5
load_dm ime 0 32
load_dm ime 1 33
load_dm ime 2 34
load_dm ime 3 35
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e4
is_busy 15
cmp ime 15 0
bne @wb_e4
 
# Edge 5: v5->v6
load_dm ime 0 34
load_dm ime 1 35
load_dm ime 2 36
load_dm ime 3 37
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e5
is_busy 15
cmp ime 15 0
bne @wb_e5
 
# Edge 6: v6->v7
load_dm ime 0 36
load_dm ime 1 37
load_dm ime 2 38
load_dm ime 3 39
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e6
is_busy 15
cmp ime 15 0
bne @wb_e6
 
# Edge 7: v7->v4
load_dm ime 0 38
load_dm ime 1 39
load_dm ime 2 32
load_dm ime 3 33
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e7
is_busy 15
cmp ime 15 0
bne @wb_e7
 
# Edge 8: v0->v4
load_dm ime 0 24
load_dm ime 1 25
load_dm ime 2 32
load_dm ime 3 33
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e8
is_busy 15
cmp ime 15 0
bne @wb_e8
 
# Edge 9: v1->v5
load_dm ime 0 26
load_dm ime 1 27
load_dm ime 2 34
load_dm ime 3 35
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e9
is_busy 15
cmp ime 15 0
bne @wb_e9
 
# Edge 10: v2->v6
load_dm ime 0 28
load_dm ime 1 29
load_dm ime 2 36
load_dm ime 3 37
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e10
is_busy 15
cmp ime 15 0
bne @wb_e10
 
# Edge 11: v3->v7
load_dm ime 0 30
load_dm ime 1 31
load_dm ime 2 38
load_dm ime 3 39
set_x0 0
set_y0 1
set_x1 2
set_y1 3
set_col 12
@wb_e11
is_busy 15
cmp ime 15 0
bne @wb_e11
 
# Wait for new frame before next update
@wnf
is_new_frame 11
cmp ime 11 1
bne @wnf
 
bra @start
