class_name SavedResource
extends Resource

@export var version: int = 1



func save_to_file(path: String = "") -> void:
	var final_path = path if path != "" else get_file_path()
	if final_path == "":
		push_error("No file path specified for saving.")
		return
	var err = ResourceSaver.save(self, final_path)
	if err != OK:
		push_error("Save failed: %s" % error_string(err))

# Virtual loader — subclasses must override this 
# (change: return value, cast, and instantiation in case of no load)
static func load_from_file(path: String = "") -> SavedResource:
	push_error("load_from_file() must be overridden in child class.")
	var final_path = path if path != "" else get_file_path()
	if FileAccess.file_exists(final_path):
		var res = ResourceLoader.load(final_path)
		res = res as SavedResource
		if res != null:
			return res
	return SavedResource.new()

# Virtual getter — subclasses must override this
static func get_file_path() -> String:
	push_error("get_file_path() must be overridden in child class.")
	return ""
