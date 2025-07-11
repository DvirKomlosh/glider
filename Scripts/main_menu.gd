extends Control

signal play
signal show_leaderboard


func _on_play_button_pressed() -> void:
	play.emit()


func _on_leaderboard_button_pressed() -> void:
	show_leaderboard.emit()
