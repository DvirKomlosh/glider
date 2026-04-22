extends SavedResource
class_name Cooldowns

@export var _write_leaderboard_stats: CooldownVariable = CooldownVariable.new()
@export var _write_other_stats: CooldownVariable = CooldownVariable.new()
@export var _read_leaderboard_stats: CooldownVariable = CooldownVariable.new()

func reset_write_leaderboard_stats() -> bool:
	if _write_leaderboard_stats.reset():
		self.save_to_file()
		return true
	return false

func can_reset_write_leaderboard_stats() -> bool:
	return _write_leaderboard_stats.is_cooldown_over()

func reset_write_other_stats() -> bool:
	if _write_other_stats.reset():
		self.save_to_file()
		return true
	return false

func can_reset_write_other_stats() -> bool:
	return _write_other_stats.is_cooldown_over()

func reset_read_leaderboard_stats() -> bool:
	if _read_leaderboard_stats.reset():
		self.save_to_file()
		return true
	return false

func can_reset_read_leaderboard_stats() -> bool:
	return _read_leaderboard_stats.is_cooldown_over()

static func load_from_file(path: String = "") -> Cooldowns:
	var final_path = path if path != "" else get_file_path()
	var res = null
	if FileAccess.file_exists(final_path):
		res = ResourceLoader.load(final_path)
		res = res as Cooldowns
	if res == null:
		res = Cooldowns.new()
	set_timeouts(res)
	return(res)
	
static func set_timeouts(cooldowns: Cooldowns) -> void:
	cooldowns._read_leaderboard_stats._cooldown = 5400 # 1.5 hours
	cooldowns._write_leaderboard_stats._cooldown = 3 * 3600
	cooldowns._write_other_stats._cooldown = 16 * 3600
		
static func get_file_path() -> String:
	return "user://cooldowns.tres"


func _to_string() -> String:
	return "[Cooldowns SavedResource]"
