extends Node2D

var save_path = "user://scores.save"


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
	

func _send_add_trail(pos, speed):
	$GliderTrail.add_trail_point(pos, speed)

func _set_game_over():
	_save_score()
	$AnimationPlayer.play("death")
	$CanvasLayer/EndScreen.set_scores(score, best_score, distance, best_distance)
	is_game_over = true

func _in_hoop():
	if not is_game_over:
		$Glider.in_hoop(combo)
		
		score += combo
		combo += 1
		
		$AnimationPlayer.play("in_hoop")
		var camera_tween = create_tween()
		
		camera_tween.tween_property($Glider/Camera2D, "zoom", Vector2(0.11, 0.11), 0.6)
		camera_tween.tween_property($Glider/Camera2D, "zoom", Vector2(0.1,0.1) , 1)
		
		#$GliderTrail.add_color()
	
func _out_hoop():
	combo = 1

func _ready() -> void:
	_load_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance = int($Glider.position.x/1000)
	# set glider UI position
	$CanvasLayer/Control/x.text = str(distance)
	$CanvasLayer/Control/y.text = str(score)
