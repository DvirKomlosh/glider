extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var game_scene = preload("res://Scences/MainGame.tscn")

var current_game: Node2D = null

func _on_main_menu_play() -> void:
	canvas_layer.queue_free()	
	_restart_game()
	

func _restart_game() -> void:
	if current_game:
		current_game.queue_free()
		await get_tree().process_frame #make sure the last scene is gone
		
	current_game = game_scene.instantiate()
	current_game.request_reload.connect(_restart_game)
	add_child(current_game)
