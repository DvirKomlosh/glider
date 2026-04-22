extends MarginContainer


@onready var rank: Label = $Row/Rank
@onready var player_name: Label = $Row/PlayerName
@onready var value: Label = $Row/Value



func set_rank(new_rank: String) -> void:
	rank.text = new_rank
	
func set_player_name(new_player_name: String) -> void:
	player_name.text = new_player_name
	
func set_value(new_value: String) -> void:
	value.text = new_value
