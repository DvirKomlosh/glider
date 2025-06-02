extends Node2D

signal in_hoop
signal out_hoop

var ring_scene = preload("res://Scences/Ring.tscn")

var active_rings = []
var rings = []

func unset_all_indicators() -> void:
	for ring in rings:
		ring.unset_indicator()

func set_all_indicators() -> void:
	active_rings[0].reset_indicator()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ring in get_children():
		ring.in_hoop.connect(send_in_hoop)


func send_in_hoop() -> void:
	active_rings[0].unset_indicator()
	active_rings.remove_at(0)
	in_hoop.emit()

	
func send_out_hoop() -> void:
	active_rings[0].unset_indicator()
	active_rings.remove_at(0)
	out_hoop.emit()

func update_indicator(glider_position: Vector2) -> void:
	if len(active_rings) > 0:
		active_rings[0].set_indicator(glider_position)
	

func instentiate_ring(new_pos: Vector2) -> void:
	'''
	generates a new ring
	'''
	
	var new_ring = ring_scene.instantiate()
	new_ring.global_position.x = new_pos.x
	new_ring.global_position.y = new_pos.y
	add_child(new_ring)
	new_ring.in_hoop.connect(send_in_hoop)
	new_ring.out_hoop.connect(send_out_hoop)
	rings.append(new_ring)
	active_rings.append(new_ring)


	
func remove_rings(x_position: float) -> void:
	'''
	used to destroy hoops that are way behind us.
	removes the first ring still in the game, if the ring is behind x_position.
	otherwise does nothing.
	'''
	if len(rings) <= 0:
		return
	var ring = rings[0]
	if x_position > ring.global_position.x:
		remove_child(ring)
		rings.remove_at(0)
		return
