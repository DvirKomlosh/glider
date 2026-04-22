extends Camera2D


var shake_amount = 0.0
var default_offset = Vector2(2000,2000)
var screenshake

func _process(delta: float) -> void:
	if shake_amount > 0:
		offset = default_offset + Vector2(randf_range(-7, 7), randf_range(-7, 7)) * shake_amount
		shake_amount = lerp(shake_amount, 0.0, delta * 10)
	else:
		offset = default_offset

func set_screenshake(is_screenshake: bool) -> void:
	screenshake = is_screenshake

func start_screen_shake(amount: float) -> void:
	if not screenshake:
		return
	shake_amount = amount
