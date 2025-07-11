class_name PlayerRemoteData
extends SavedResource

@export var data: Dictionary = {}:
	set(new_data):
		data = new_data
		save_to_file()
	get():
		return data


static func load_from_file(path: String = "") -> PlayerRemoteData:
	var final_path = path if path != "" else get_file_path()
	if FileAccess.file_exists(final_path):
		var res = ResourceLoader.load(final_path)
		res = res as PlayerRemoteData
		if res != null:
			return res
	return PlayerRemoteData.new()

''
static func get_file_path() -> String:
	return "user://player_remote_data.tres"


func _to_string() -> String:
	return "playerdata: " + str(data)

func equals(other: Dictionary) -> bool:
	for key in other.keys():
		if not data.has(key) or data[key] != other[key]:
			return false
	for key in data.keys():
		if not other.has(key):
			return false
	return true
