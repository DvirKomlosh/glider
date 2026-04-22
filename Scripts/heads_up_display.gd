extends Control

@onready var distance: Label = $MarginContainer/HBoxContainer/Distance
@onready var score: Label = $MarginContainer/HBoxContainer/Score
@onready var streak_text: Label = $StreakTextnow

var _streak_tween: Tween

func update_distance(new_distance: int) -> void:
	distance.text = str(new_distance)

func update_score(new_score: int) -> void:
	score.text = str(new_score)


func show_streak_message(combo: int) -> void:
	
	var low_streak_words = ["Good!", "Cool!", "Very Good!", "Awesome!"]
	var mid_streak_words = ["Amazing!", "Great Job!", "Keep Going!", "Unstoppable!"]
	var high_streak_words = ["CRAZY STREAK!!", "DOING AMAZINGLY GOOD!", "INSANE!!", "KING OF THE SKY!"]
	
	var chosen_word = ""
	
	if combo >= 8:
		chosen_word = high_streak_words.pick_random()
	elif combo >= 6:
		chosen_word = mid_streak_words.pick_random()
	elif combo >= 2: 
		chosen_word = low_streak_words.pick_random()
	else:
		return

	streak_text.rotation_degrees = randf_range(-10, 10)
	streak_text.text = chosen_word

	if _streak_tween:
		_streak_tween.kill()

	streak_text.modulate.a = 1.0
	streak_text.scale = Vector2(0.5, 0.5)

	_streak_tween = create_tween()
	_streak_tween.tween_property(streak_text, "scale", Vector2(1.2, 1.2), 0.1)
	_streak_tween.tween_property(streak_text, "scale", Vector2(1.0, 1.0), 0.1)
	_streak_tween.tween_property(streak_text, "modulate:a", 0.0, 0.5).set_delay(1.0)

@onready var fire_label: Label = $FireLabel

func update_fire_streak(current_combo: int) -> void:
	if current_combo <= 1:
		fire_label.text = ""
		return

	var emojis = ""
	var streak_number = current_combo - 1
	
	if streak_number >= 10:
		emojis = "🔥🔥🔥"
	elif streak_number >= 5:
		emojis = "🔥🔥"
	elif streak_number >= 3:
		emojis = "🔥"
	
	fire_label.text = emojis + " " + str(streak_number)
	
	var tween = create_tween()
	tween.tween_property(fire_label, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(fire_label, "scale", Vector2(1.0, 1.0), 0.05)
