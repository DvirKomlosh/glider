extends Control


@onready var distance: Label = $MarginContainer/HBoxContainer/Distance
@onready var score: Label = $MarginContainer/HBoxContainer/Score

func update_distance(new_distance: int) -> void:
	distance.text = str(new_distance)
	
func update_score(new_score: int) -> void:
	score.text = str(new_score)
	


func _on_settings_button_pressed() -> void:
	pass
