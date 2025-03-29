extends Node2D

var save_path = "user://scores.save"
var starting_glider_position

@onready var glider: CharacterBody2D = $Glider
@onready var controller: VSlider = $CanvasLayer/Controller
@onready var rings: Node2D = $Environment/Rings
@onready var glider_trail: Line2D = $GliderTrail
@onready var end_screen: Control = $CanvasLayer/EndScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Glider/Camera2D


var score = 0
var best_score = 0
var distance = 0
var best_distance = 0

var combo = 1
var is_game_over = false



func _load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		best_distance = file.get_var(best_distance)
		best_score = file.get_var(best_score)
	else:
		print("no data saved...")
		best_distance = 0
		best_score = 0

func _save_score():
	best_distance = max(distance, best_distance)
	best_score = max(score, best_score)
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(best_distance)
	file.store_var(best_score)
	

func update_glider_position(pos, speed):
	glider_trail.add_trail_point(pos, speed)
	rings.update_indicator(pos)
	

func _set_game_over():
	_save_score()
	animation_player.play("death")
	end_screen.set_scores(score, best_score, distance, best_distance)
	is_game_over = true

func _in_hoop():
	if not is_game_over:
		glider.in_hoop(combo)
		score += combo
		combo += 1
		
		animation_player.play("in_hoop")
					
func _out_hoop():
	combo = 1

func _ready() -> void:
	_load_score()
	glider.position = starting_glider_position

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	glider.set_glider_rotation(controller.value)
	distance = int(glider.position.x/1000)
	# set glider UI position
	$CanvasLayer/Control/x.text = str(distance)
	$CanvasLayer/Control/y.text = str(score)


func _on_ready_to_set_glider_position(pos_x: float, pos_y: float) -> void:
	starting_glider_position = Vector2(pos_x, pos_y + 500)
