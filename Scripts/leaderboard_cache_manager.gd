extends Node

signal request_data

var modes
var is_set

var version

@onready var player_remote_data: PlayerRemoteData = PlayerRemoteData.load_from_file()

const BASE_PATH: String = "user://leaderboard_cache_"

func set_cache(set_modes: Dictionary, new_version: int):
	is_set = true
	modes = set_modes
	version = new_version



func save_data(data: Dictionary,  player_name: String) -> void:
	'''
	for each mode saves all relavent data to a sorted binary file
	saves a remote_data file of the player's data
	'''
	if not is_set:
		return
	
	if player_name in data:
		player_remote_data.data = data[player_name]
		data.erase(player_name)
	
	var entry_list: Array = data.values()
	for mode in modes.values():
		save_binary_mode_file(entry_list, mode)
	
	
func save_binary_mode_file(entry_list: Array, mode: LeaderboardMode) -> void:	
	'''
	each binary mode file is saved in the format:
	version (32 bin int)
	number of entries (32 bin int)
	sorted list of entries:
		player name, new line
		value
	'''
	var path = BASE_PATH + mode.name + ".save"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_32(version)
		file.store_32(len(entry_list))
		entry_list.sort_custom(func(a, b): return (0 < (b[mode.name] - a[mode.name])) != mode.decending_order)

		for entry in entry_list:
			if entry['Version'] == version: #if the version is not compatible the mode might not exist in the entry 
				file.store_string(entry['Name']+'\n')
				file.store_64(entry[mode.name])
		file.close()

func load_data() -> Dictionary:
	var data = {}
	var should_request_new_data = false
	if not is_set:
		return {}
	
	for mode in modes.values():
		var res =  load_binary_mode_file(mode)
		if len(res) == 0:
			should_request_new_data = true
		data[mode.name] = res
	
	if should_request_new_data:
		request_data.emit()
	return data
	
func load_binary_mode_file(mode: LeaderboardMode) -> Array:
	'''
	if a binary mode file is of the wrong version, a batch of new data is requested.
	'''
	var data = []
	var path = BASE_PATH + mode.name + ".save"
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		if file.get_32() != version:
			print("bad version!")
		else:
			var entries: int = file.get_32()
			for i in entries:
				data.append([file.get_line(), file.get_64()])
	if len(data) == 0:
		request_data.emit()
	return data
