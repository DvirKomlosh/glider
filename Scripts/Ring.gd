extends Node2D

signal in_hoop

var x_margin_size = 100
var y_margin_size = 10

var is_on_screen



@onready var indicator = $CanvasLayer/RingIndicator
@onready var indicator_label = $CanvasLayer/RingIndicator/RingDistance
@onready var indicator_size = indicator.size

func _on_in_loop(body):
	in_hoop.emit()

func set_indicator(glider_global_position):
	var origin_position = get_global_transform_with_canvas().origin
	var vp_size = get_viewport_rect().size
	
	var pos = Vector2(origin_position.x - 120, origin_position.y - 20)

	pos.x = clamp(pos.x, -100, vp_size.x - indicator_size.x - x_margin_size)
	pos.y = clamp(pos.y, y_margin_size , vp_size.y - indicator_size.y - y_margin_size)
	indicator.position = pos

	var distance = int((global_position.x - glider_global_position.x) / 1000)
	
	var base_size = Vector2(60,40)
	var scalar = 1 - distance / 800.0
	indicator.size.x = int(base_size.x * scalar)
	indicator.size.y = int(base_size.y * scalar)

	
	if distance > 100 or distance < 0:
		indicator.visible = false
		
	indicator_label.text = str(distance)
	
	
