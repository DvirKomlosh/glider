extends Control

@onready var distance: Label = $MarginContainer/HBoxContainer/Distance
@onready var score: Label = $MarginContainer/HBoxContainer/Score
@onready var streak_text: Label = $StreakText

var _streak_tween: Tween

func update_distance(new_distance: int) -> void:
	distance.text = str(new_distance)

func update_score(new_score: int) -> void:
	score.text = str(new_score)


func show_streak_message(combo: int) -> void:
	if combo >= 8:
		streak_text.text = "CRAZY STREAK!!"
	elif combo >= 6:
		streak_text.text = "Amazing!"
	elif combo >= 4:
		streak_text.text = "Awesome!"
	elif combo >= 2:
		streak_text.text = "Good!"
	else:
		return

	if _streak_tween:
		_streak_tween.kill()

	streak_text.modulate.a = 1.0
	streak_text.scale = Vector2(0.5, 0.5)

	_streak_tween = create_tween()
	_streak_tween.tween_property(streak_text, "scale", Vector2(1.2, 1.2), 0.1)
	_streak_tween.tween_property(streak_text, "scale", Vector2(1.0, 1.0), 0.1)
	_streak_tween.tween_property(streak_text, "modulate:a", 0.0, 0.5).set_delay(1.0)
