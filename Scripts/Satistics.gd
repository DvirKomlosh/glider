class_name Statistics
extends SavedResource

@export var best_score: int = 0:
	set(new_best):
		if new_best > best_score:
			best_score = new_best
			save_to_file()
	get():
		return best_score

func get_best_score() -> int:
	return best_score

@export var best_distance: int = 0:
	set(new_best):
		if new_best > best_distance:
			best_distance = new_best
			save_to_file()
	get():
		return best_distance

func get_best_distance() -> int:
	return best_distance

@export var best_combo: int = 1:
	set(new_best):
		if new_best > best_combo:
			best_combo = new_best
			save_to_file()
	get():
		return best_combo

func get_best_combo() -> int:
	return best_combo

@export var max_speed: int = 0:
	set(new_max):
		if new_max > max_speed:
			max_speed = new_max
			save_to_file()
	get():
		return max_speed

@export var games_played: int = 0:
	set(new_amount):
		if new_amount > games_played:
			games_played = new_amount
			save_to_file()
	get():
		return games_played

@export var time_played: int = 0:
	set(new_amount):
		if new_amount > time_played:
			time_played = new_amount
			save_to_file()
	get():
		return time_played

@export var total_rings_gone_through: int = 0:
	set(new_amount):
		if new_amount > total_rings_gone_through:
			total_rings_gone_through = new_amount
			save_to_file()
	get():
		return total_rings_gone_through

@export var total_distance_traveled: int = 0:
	set(new_amount):
		if new_amount > total_distance_traveled:
			total_distance_traveled = new_amount
			save_to_file()
	get():
		return total_distance_traveled
		
@export var acumulated_score: int = 0:
	set(new_amount):
		if new_amount > acumulated_score:
			acumulated_score = new_amount
			save_to_file()
	get():
		return acumulated_score

@export var revives: int = 0:
	set(new_amount):
		if new_amount > revives:
			revives = new_amount
			save_to_file()
	get():
		return revives


static func load_from_file(path: String = "") -> Statistics:
	var final_path = path if path != "" else get_file_path()
	var res = ResourceLoader.load(final_path)
	res = res as Statistics
	if res == null:
		return Statistics.new()
	return res

static func get_file_path() -> String:
	return "user://statistics.tres"


func _to_string() -> String:
	return "[Statistics: score=%d, distance=%d, combo=%d, time_played=%d, games_played=%d, total_distance_traveled=%d, acumulated_score=%d, rings_gone_through=%d, max_speed=%d, revives=%d]" % [
		best_score, best_distance, best_combo, time_played, games_played, total_distance_traveled, acumulated_score, total_rings_gone_through, max_speed, revives
	]
