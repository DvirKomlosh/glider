extends Node

var gliders = 0
var wanted_gliders = 6
var in_cleanup = false
var running = true
const AUTOPILOT_GLIDER = preload("res://Scences/autopilot_glider.tscn")

func start() -> void:
	running = true

func stop() -> void:
	for child in get_children():
		child.queue_free()
	gliders = 0
	running = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if gliders == 0 and not in_cleanup and running:
		in_cleanup = true
		for child in get_children():
			child.queue_free()
		in_cleanup = false
		while(gliders != wanted_gliders):
			_generate_glider()
			

func _generate_glider() -> void:
	gliders += 1
	var new_glider = AUTOPILOT_GLIDER.instantiate()
	add_child(new_glider)
	new_glider.position = _get_random_position()
	new_glider.scale =  _get_random_scale()
	new_glider.wanted_point = _get_random_wanted_position()
	new_glider.trail_color = _get_random_trail_color()

	new_glider.dead.connect(_on_dead_glider)

func _on_dead_glider():
	gliders -= 1

func _get_random_position() -> Vector2:
	var x = randi_range(-4000,-500)
	var y = randi_range(-1000,1000)
	return Vector2(x,y)

func _get_random_scale() -> Vector2:
	var s = randf_range(0.1, 0.4)
	return Vector2(s,s)

func _get_random_wanted_position() -> Vector2:
	var x = randi_range(0,1280)
	var y = randi_range(-1000, 1200)
	return Vector2(x, y) 

func _get_random_trail_color() -> Color:
	return Color(randf(), randf(), randf())
