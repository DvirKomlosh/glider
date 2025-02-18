extends ColorRect

var x_margin_size = 100
var y_margin_size = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func nan():
	var parent_pos = get_node("../..").get_global_transform_with_canvas().origin
	var vp_size = get_viewport_rect().size
	
	var pos = Vector2(parent_pos.x - 120, parent_pos.y - 20)

	pos.x = clamp(pos.x, -100, vp_size.x - size.x - x_margin_size)
	pos.y = clamp(pos.y, y_margin_size , vp_size.y - size.y - y_margin_size)
	position = pos
	
