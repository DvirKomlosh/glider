extends Node2D

signal in_hoop



var ring_scene = preload("res://Scences/Ring.tscn")
var last_update_position = 0
var next_ring_update = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for ring in get_children():
		ring.in_hoop.connect(send_in_hoop)

func send_in_hoop():
	in_hoop.emit() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var glider_position = $"../Glider".global_position.x
	if glider_position > next_ring_update:
		next_ring_update = glider_position + 4000
		_remove_rings(glider_position)
		_instentiate_ring(Vector2(next_ring_update, 2200))
		


func _instentiate_ring(new_pos: Vector2):
	'''
	generates a new ring
	'''
	var new_ring = ring_scene.instantiate()
	new_ring.position.x = new_pos.x
	new_ring.position.y = new_pos.y
	add_child(new_ring)
	new_ring.in_hoop.connect(send_in_hoop)
	
	
func _remove_rings(glider_pos):
	'''
	used to destroy hoops that are way behind us
	'''
	for ring in get_children():
		if glider_pos -10000 - ring.global_position.x > 0:
			remove_child(ring)
			return
