extends Line2D

var trail_offset = Vector2(200, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var trail_position = $"../Glider".global_position - trail_offset
	add_point(trail_position)
	
