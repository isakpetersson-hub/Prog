extends Node

# External nodes that this node needs access to
@onready var car: VehicleBody3D = $"../../CarM1V2"                   # The car, crazy shizz

@onready var text_layer: CanvasLayer = $"../../TrickTextLayer"               # Used to display text when
										   # performing tricks


var total_score = 0
var combo_score = 0
var combo = 1
var combo_threshhold = 2
var combo_timer = 0

@onready var score_label : Label = $Control/total_score
@onready var combo_score_label : Label = $Control/combo_score
@onready var progress_bar : ProgressBar = $Control/ProgressBar

const COMBO_VALUE = 50
const SCORE_VALUE = 10000

# -----------------------------------------------------------------------------
# Things for checking if the car is in the air
var lost_ground_contact: bool = false

var ground_timer_threshold: float = 0.2    # How long the car must remain in
										   # contact with the ground until it
										   # is considered to have landed

var ground_timer: float = 0.0              # How long the car has been on
										   # the ground

var perfect_landing_threshold: float = 0.2 # A tighter timing used for scoring
var perfect_landing_multiplier: float = 1.5
# -----------------------------------------------------------------------------
# Enum for every type of air move
enum AIR_MOVE {NONE, FRONTFLIP, BACKFLIP, BARREL_ROLL, THREESIXTY}

var scoring_dict: Dictionary = {
	AIR_MOVE.NONE: 0,
	AIR_MOVE.FRONTFLIP: 100,
	AIR_MOVE.BACKFLIP: 100,
	AIR_MOVE.BARREL_ROLL: 50,
	AIR_MOVE.THREESIXTY: 150
}

var move_text_dict: Dictionary = {
	AIR_MOVE.NONE: "",
	AIR_MOVE.FRONTFLIP: "FRONT FLIP",
	AIR_MOVE.BACKFLIP: "BACK FLIP",
	AIR_MOVE.BARREL_ROLL: "BARREL ROLL",
	AIR_MOVE.THREESIXTY: "360"
}

var tot_moves: Dictionary = {
	AIR_MOVE.NONE: 0,
	AIR_MOVE.FRONTFLIP: 0,
	AIR_MOVE.BACKFLIP: 0,
	AIR_MOVE.BARREL_ROLL: 0,
	AIR_MOVE.THREESIXTY: 0
}
# -----------------------------------------------------------------------------
# Counters that are needed to check rotation and airtime
var airtime_counter: float = 0.0           # Counts airtime, shocking

var flip_counter_x: float = 0.0            # Backwards and Forwards
var flip_counter_y: float = 0.0            # Left and Right turns (360)
var flip_counter_z: float = 0.0            # Barrel Rolls

# Accumulated rotations in every axis (godot doesn't understand circles)
var accu_x_rotation: float = 0
var accu_y_rotation: float = 0
var accu_z_rotation: float = 0

# Counters for total number of each trick performed in the air, for scoring
var tot_backflip: int = 0
var tot_frontflip: int = 0
var tot_three_sixty: int = 0
var tot_barrel_roll: int = 0

# -----------------------------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = combo_threshhold
	progress_bar.value = 0
	update_combo_score()
	score_label.text = "0"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !lost_ground_contact && !car.is_grounded():
		# The car was on the ground in the previous frame
		lost_ground_contact = true
	elif lost_ground_contact:
		if !has_landed(delta):
			handle_airtime(delta)
		else:
			lost_ground_contact = false
			
	if combo_timer > 0.01:
		if lost_ground_contact:
			combo_timer -= delta/3
		else:
			combo_timer -= delta
	else:
		combo_timer = 0
		total_score += combo_score
		reset_combo()
		combo_score = 0
	
	progress_bar.value = combo_timer
	update_combo_score()
	update_score()
	

# -----------------------------------------------------------------------------
# All of the check_*() functions are pretty self-explanatory
# 2 * PI is a full rotation
func check_frontflip() -> bool:
	if flip_counter_x > (2 * PI): return true
	return false

func check_backflip() -> bool:
	if flip_counter_x < (-2 * PI): return true
	return false
	
func check_barrel_roll() -> bool:
	if abs(flip_counter_z) > (2 * PI): return true
	return false
	
func check_three_sixty() -> bool:
	if abs(flip_counter_y) > (2 * PI): return true
	return false

# Uses the check_*() function for every air_move type
# The function then uses text_layer to display the move type
func get_air_move(delta: float) -> AIR_MOVE:
	var ang = car.angular_velocity * car.basis * delta
	flip_counter_x += ang.x
	flip_counter_y += ang.y
	flip_counter_z += ang.z
	
	if check_backflip(): return AIR_MOVE.BACKFLIP
	elif check_frontflip(): return AIR_MOVE.FRONTFLIP
	elif check_barrel_roll(): return AIR_MOVE.BARREL_ROLL
	elif check_three_sixty(): return AIR_MOVE.THREESIXTY
	
	return AIR_MOVE.NONE

func perfect_landing():
	text_layer.show_trick("PERFECT LANDING!", 0.3)
	
func increase_combo():
	combo += 1
	text_layer.show_trick("x" + str(combo),  float(combo) / float(COMBO_VALUE))
	
func reset_combo():
	combo = 1

func update_combo_score():
	combo_score_label.text = str(combo_score) + " x" + str(combo)
	
func update_score():
	score_label.text = str(total_score)

# -----------------------------------------------------------------------------
# Returns true if the car has been on the ground for long enough after
# having been airborne
func has_landed(delta: float) -> bool:
	#print("Lin Vel Y: ", -car.linear_velocity.y)
	var score : int = 0
	if car.is_grounded():
		ground_timer += delta
		if (ground_timer >= ground_timer_threshold):
			score = get_score(false) * combo
			text_layer.show_trick(str(score), float(score) / float(SCORE_VALUE))
			
			combo_score += score
			increase_combo()
			update_combo_score()
			combo_timer = combo_threshhold
			
			reset_all_counters()
			return true
		elif check_perfect_landing():
			perfect_landing()
			score = get_score(false) * combo
			text_layer.show_trick(str(score), float(score) / float(SCORE_VALUE))
			
			combo_score += score
			increase_combo()
			update_combo_score()
			combo_timer = combo_threshhold
			
			reset_all_counters()
			return true
	elif ground_timer > 0:
		ground_timer = 0
	return false

func check_perfect_landing() -> bool:
	# Adjust the timing threshold based on speed
	var adjusted_thres: float = (perfect_landing_threshold /
						clamp(-car.linear_velocity.y, 2, 7))
	
	var timing_check: bool = ground_timer <= adjusted_thres
	return timing_check && car.all_wheels_grounded()

# -----------------------------------------------------------------------------
# Do all of the processing necessary for scoring while in the air
func handle_airtime(delta: float) -> void:
	var move_type: AIR_MOVE = get_air_move(delta)
	var move_text: String = move_text_dict[move_type]
	
	if move_type != AIR_MOVE.NONE:
		tot_moves[move_type] += 1
	
	if tot_moves[move_type] > 1:
		move_text += " x" + str(tot_moves[move_type])
	
	if move_type == AIR_MOVE.FRONTFLIP || move_type == AIR_MOVE.BACKFLIP:
		flip_counter_x = 0
	elif move_type == AIR_MOVE.BARREL_ROLL:
		flip_counter_z = 0
	elif move_type == AIR_MOVE.THREESIXTY:
		flip_counter_y = 0
	
	if !move_text.is_empty():
		combo_timer = combo_threshhold
		text_layer.show_trick(move_text, 0.3)

	airtime_counter += delta

# -----------------------------------------------------------------------------
#
func get_score(landed_perfectly: bool) -> int:
	var score: float = 0
	
	for key in tot_moves:
		score += scoring_dict[key] * tot_moves[key]
	
	score += get_airtime_score()
	
	score = score * perfect_landing_multiplier if landed_perfectly else score
	score = clamp(score, 0, INF)
	return int(floor(score))

func get_airtime_score() -> float:
	return log(airtime_counter * 100)

# -----------------------------------------------------------------------------
# Just resets every single counter, used when car has landed
func reset_all_counters():
	for key in tot_moves:
		tot_moves[key] = 0
	
	flip_counter_x = 0
	flip_counter_y = 0
	flip_counter_z = 0
	
	accu_x_rotation = 0
	accu_y_rotation = 0
	accu_z_rotation = 0
	
	airtime_counter = 0
