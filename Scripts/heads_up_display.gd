extends Control


@onready var distance: Label = $MarginContainer/HBoxContainer/Distance
@onready var score: Label = $MarginContainer/HBoxContainer/Score
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var needle: TextureRect = $Speedometer/Needle
@onready var speedometer: Control = $Speedometer

signal settings_button_pressed

func update_distance(new_distance: int) -> void:
	distance.text = str(new_distance)
	
func update_score(new_score: int) -> void:
	score.text = str(new_score)
	


func _on_settings_button_pressed() -> void:
	animation_player.play("hide_settings_button")
	await animation_player.animation_finished
	settings_button_pressed.emit()


func show_settings_button() -> void:
	animation_player.play_backwards("hide_settings_button")

func countdown() -> void:
	animation_player.play("countdown")
	await animation_player.animation_finished

func update_speed(speed: float) -> void:
	speed = speed / 1000.0
	if speed < 15:
		needle.rotation = deg_to_rad(speed * 8)
	else:
		needle.rotation = deg_to_rad(speed * 3 + 75)

func display_speedometer(display: bool) -> void:
	speedometer.visible = display
