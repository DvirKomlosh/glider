extends Node2D

var score = 0
var combo = 1


func _in_hoop():
	$Glider.in_hoop(combo)
	
	
	score += combo
	combo += 1
	
	var camera_tween = create_tween()
	
	camera_tween.tween_property($Glider/Camera2D, "zoom", Vector2(0.11, 0.11), 0.6)
	camera_tween.tween_property($Glider/Camera2D, "zoom", Vector2(0.1,0.1) , 1)
	
func _out_hoop():
	combo = 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# set glider UI position
	$CanvasLayer/Control/x.text = str(int($Glider.position.x/1000))
	$CanvasLayer/Control/y.text = str(score)

	
	if not $Glider.is_alive:
		var current_scene = get_tree().current_scene.scene_file_path
		$"CanvasLayer/Final Score".text = str(score)
		$CanvasLayer/Control/y.text = ""
		$CanvasLayer/Control/x.text = ""
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file(current_scene)
		

func _draw():
	
	# draw grid, temporary:
	var min_x = 0
	var min_y = 0
	var max_x = 2000000
	var max_y = 2000000
	
	for i in range(11):
		if i >= 10: 
			draw_line(Vector2(min_x,i*1000), Vector2(max_x,i*1000), Color.RED)
		else:
			draw_line(Vector2(min_x,i*1000), Vector2(max_x,i*1000), Color.WHITE)

	
	for i in range(1000):
		draw_line(Vector2(i*1000,min_y), Vector2(i*1000,max_y), Color.WHITE)
