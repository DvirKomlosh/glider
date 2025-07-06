extends Control

signal play


func _on_play_button_pressed() -> void:
	play.emit()
