extends Control


@onready var db_manager: Node = $DBManager

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var name_picker: Control = $CanvasLayer/NamePicker
@onready var leaderboard: Control = $CanvasLayer/Leaderboard
@onready var main_menu: Control = $CanvasLayer/MainMenu

@onready var settings: Settings = Settings.load_from_file()

var game_scene = preload("res://Scences/MainGame.tscn")



var current_game: Node2D = null


func _ready() -> void:
	if not _player_name_set():
		_get_player_name()
		return
	db_manager.get_data()
	db_manager.send_data_to_db()
	leaderboard._setup()


func _player_name_set() -> bool:
	return settings.player_name != ""

func _get_player_name():
	for child in canvas_layer.get_children():
		child.visible = false
	name_picker.visible = true


func _on_try_pick_name(name: String) -> void:
	if await db_manager.is_name_taken(name):
		name_picker.on_failed_set_name("name already taken")
	else:
		settings.player_name = name
		settings.save_to_file()
		_on_show_menu()
		db_manager.send_data_to_db()
		leaderboard._setup()
	

func _on_main_menu_play() -> void:
	canvas_layer.visible = false
	_restart_game()

func _on_main_menu_show_leaderboard() -> void:
	for child in canvas_layer.get_children():
		child.visible = false
	leaderboard.update_table()
	leaderboard.visible = true
	

func _on_show_menu() -> void:
	for child in canvas_layer.get_children():
		child.visible = false
	main_menu.visible = true

func _return_to_menu() -> void:
	if current_game:
		current_game.queue_free()
		current_game = null
		await get_tree().process_frame #make sure the last scene is gone	
	canvas_layer.visible = true

func _restart_game() -> void:
	if current_game:
		current_game.queue_free()
		current_game = null
		await get_tree().process_frame #make sure the last scene is gone
	current_game = game_scene.instantiate()
	current_game.request_reload.connect(_restart_game)
	current_game.request_main_menu.connect(_return_to_menu)
	add_child(current_game)


func _on_db_new_data(data: Variant) -> void:
	leaderboard.save_data(data)

func _on_leaderboard_request_data() -> void:
	db_manager.get_data()
