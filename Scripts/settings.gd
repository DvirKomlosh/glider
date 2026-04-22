extends SavedResource
class_name Settings

@export var player_name: String = "":
	set(name):
		player_name = name
		

@export var sfx_volume: float = 50.0
@export var music_volume: float = 50.0

@export var mute: bool = false
@export var vibrations: bool = true
@export var screenshake: bool = true
@export var speedometer: bool = true

func _to_string() -> String:
	return "[Settings: name=%s, sfx_volume=%.2f, music_volume=%.2f\n" % [
		player_name, sfx_volume, music_volume
	]

static func load_from_file(path: String = "") -> Settings:
	var final_path = path if path != "" else get_file_path()
	if FileAccess.file_exists(final_path):
		var res = ResourceLoader.load(final_path)
		res = res as Settings
		if res != null:
			return res
	return Settings.new()



static func get_file_path() -> String:
	return "user://settings.tres"
