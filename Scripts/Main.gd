extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Rings.in_hoop.connect(_in_hoop)



func _in_hoop():
	print("adding")
	$Glider.in_hoop()
	var camera_tween = create_tween()
	camera_tween.tween_property($Glider/Camera2D, "Zoom", 0.5, 1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$CanvasLayer/x.text = str(int($Glider.position.x/1000))
	$CanvasLayer/y.text = str(int($Glider.position.y/1000))
	
	if int($Glider.position.y) >= 10000:
		get_tree().paused = true

func _draw():
	var min_x = 0
	var min_y = 0
	var max_x = 1000000
	var max_y = 1000000
	
	for i in range(11):
		if i >= 10: 
			draw_line(Vector2(min_x,i*1000), Vector2(max_x,i*1000), Color.RED)
			draw_rect(Rect2(Vector2(min_x,i*1000),Vector2(max_x,max_x)),Color.BROWN)
		else:
			draw_line(Vector2(min_x,i*1000), Vector2(max_x,i*1000), Color.WHITE)

	
	for i in range(1000):
		draw_line(Vector2(i*1000,min_y), Vector2(i*1000,max_y), Color.WHITE)
