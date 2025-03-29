extends Control

@onready var score_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/score
@onready var best_score_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/best_score

@onready var distance_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/distance
@onready var best_distance_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/best_distance


func set_scores(score, best_score, distance, best_distance):
	score_label.text = "score\n" + str(score)
	best_score_label.text = "highscore\n" + str(best_score)
	distance_label.text = "distance\n" + str(distance)
	best_distance_label.text = "best distance\n" + str(best_distance)
	

func end():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer.modulate.a = 0	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
