extends Node2D

signal in_hoop



var ring_scene = preload("res://Scences/Ring.tscn")
var last_update_position = 0
var next_ring_update = 100
var ring_distance = 2000
var next_ring= null
# Called when the node enters the scene tree for the first time.
func _ready():
	for ring in get_children():
		ring.in_hoop.connect(send_in_hoop)

func send_in_hoop():
	in_hoop.emit() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var glider_position = $"../Glider".global_position
	if glider_position.x > next_ring_update:
		_remove_rings(glider_position.x)
		
		if len(get_children()) == 0:
			next_ring_update += ring_distance
			ring_distance += 2000
			print("instans", next_ring_update, glider_position.x)
			_instentiate_ring(Vector2(next_ring_update, 1800 + 1 * randf_range(-500, 500)))
	
	var rings = get_children()
		
		
	if len(rings) > 0:
		var min = rings[0].global_position
		var min_local = rings[0].position 
		for ring in rings:
			var pos = ring.global_position
			if min.x > pos.x and pos.x > $"../Glider".global_position.x:
				min = pos
				min_local = ring.position
				
				

		var screen_coord = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * min_local
		$"../CanvasLayer/ColorRect".position.y = screen_coord.y


func _instentiate_ring(new_pos: Vector2):
	'''
	generates a new ring
	'''
	var new_ring = ring_scene.instantiate()
	new_ring.global_position.x = new_pos.x
	new_ring.global_position.y = new_pos.y
	add_child(new_ring)
	new_ring.in_hoop.connect(send_in_hoop)
	next_ring = new_ring
	
	
func _remove_rings(glider_pos):
	'''
	used to destroy hoops that are way behind us
	'''
	for ring in get_children():
		if glider_pos -5000 - ring.global_position.x > 0:
			remove_child(ring)
			return
