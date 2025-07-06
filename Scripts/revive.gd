extends Control

signal is_revive_requested(is_requested: bool)

@onready var revive_button: Button = $PanelContainer/VBoxContainer/VBoxContainer/CenterContainer/ReviveButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func show_menu() -> void:
	animation_player.play("blur")
	await animation_player.animation_finished
	animation_player.play("countdown")
	
func clean() -> void:
	animation_player.play_backwards("blur")
	await animation_player.animation_finished
	animation_player.play("RESET")

func _on_revive_button_pressed() -> void:
	emit_signal("is_revive_requested", true)
	revive_button.disabled = true
	animation_player.play("loading")
