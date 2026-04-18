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
	
	var low_streak_words = ["Good!", "Cool!", "Very Good!", "Awesome!"]
	var mid_streak_words = ["Amazing!", "Great Job!", "Keep Going!", "Unstoppable!"]
	var high_streak_words = ["CRAZY STREAK!!", "DOING AMAZINGLY GOOD!", "INSANE!!", "KING OF THE SKY!"]
	
	if combo >= 8:
		streak_text.rotation_degrees = randf_range(-10, 10)
		streak_text.text = high_streak_words.pick_random()
	elif combo >= 6:
		streak_text.rotation_degrees = randf_range(-10, 10)
		streak_text.text = mid_streak_words.pick_random()
	elif combo >= 4:
		streak_text.rotation_degrees = randf_range(-10, 10)
		streak_text.text = low_streak_words.pick_random()
	elif combo >= 2:
		streak_text.rotation_degrees = randf_range(-10, 10)
		streak_text.text = low_streak_words.pick_random()
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
