extends Node

@onready var cooldowns: Cooldowns = Cooldowns.load_from_file()
@onready var statistics: Statistics = Statistics.load_from_file()

@onready var leaderboard: Control = $"../CanvasLayer/Leaderboard"

@onready var put_leaderboard: HTTPRequest = $PutLeaderboard
@onready var put_statistics: HTTPRequest = $PutStatistics
@onready var get_leaderboard: HTTPRequest = $GetLeaderboard
@onready var get_player_exists: HTTPRequest = $GetPlayerExists

signal new_data(data: Variant)
signal name_taken(is_taken: bool)

var PUT_HEADERS: Array = ["Content-Type: application/json"]
var checking_name = false

const BASE_URL: String = "https://idk-glider-default-rtdb.europe-west1.firebasedatabase.app/"


func _send_leaderboard_data_to_db():
	if not cooldowns.can_reset_write_leaderboard_stats():
		return
		
	var json = leaderboard.get_leaderboard_json()
	var player_remote_data: PlayerRemoteData = PlayerRemoteData.load_from_file()	

	if player_remote_data.equals(json):
		return

	var as_string = JSON.stringify(json)
	var player_name: String = Settings.load_from_file().player_name
	var url = BASE_URL + "leaderboard/%s.json" % player_name
	put_leaderboard.request(url, PUT_HEADERS, HTTPClient.METHOD_PUT, as_string)

func _on_put_leaderboard_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		cooldowns.reset_write_leaderboard_stats()
	else:
		print("an error occoured, could not send statistics")

	
func _send_statistics_to_db():
	if not cooldowns.can_reset_write_other_stats():
		return
	var json = statistics.get_statistics_json()
	var as_string = JSON.stringify(json)
	var player_name: String = Settings.load_from_file().player_name
	var url = BASE_URL + "statistics/%s.json" % player_name
	put_statistics.request(url, PUT_HEADERS, HTTPClient.METHOD_PUT, as_string)	


func _on_put_statistics_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		cooldowns.reset_write_other_stats()
	else:
		print("an error occoured, could not send statistics")


func send_data_to_db() -> void:
	_send_statistics_to_db()
	_send_leaderboard_data_to_db()

func get_data() -> void:
	print("data requested")
	read_data_from_db()


func is_name_taken(name: String) -> bool:
	if checking_name:
		return true
	checking_name = true
	var url = BASE_URL + "leaderboard/%s.json" % name
	get_player_exists.request(url)
	var res = await name_taken
	checking_name = false
	return res
	
func _on_get_player_exists_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if response == null:
			name_taken.emit(false)
		else:
			name_taken.emit(true)


func read_data_from_db() -> void:
	if not cooldowns.can_reset_read_leaderboard_stats():
		print("can't reset read_leaderboard_stats, on cooldown")
		return
	var url = BASE_URL + "leaderboard.json"

	get_leaderboard.request(url)

	await get_leaderboard.request_completed
	


func _on_get_leaderboard_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if typeof(response) == TYPE_DICTIONARY:
			new_data.emit(response)
			cooldowns.reset_read_leaderboard_stats()
	else:
		print("an error occoured, could not get statistics")
