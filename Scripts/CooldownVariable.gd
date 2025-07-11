extends Resource
class_name CooldownVariable

var _cooldown: int:
	set(value):
		if value >= 0:
			_cooldown = value
@export var _last_reset: int # in seconds since epoch

func _init() -> void:
	if _last_reset == null:
		_last_reset = 0
	if _cooldown == null:
		_cooldown = 0

func is_cooldown_over() -> bool:
	var current_time: int = int(Time.get_unix_time_from_system())
	return current_time > _last_reset + _cooldown

func reset() -> bool:
	var current_time: int = int(Time.get_unix_time_from_system())
	if current_time > _last_reset + _cooldown:
		_last_reset = current_time
		return true 
	return false
