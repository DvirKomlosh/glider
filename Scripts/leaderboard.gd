extends Control

enum Mode { SCORE, DISTANCE }

@onready var statistics: Statistics = Statistics.load_from_file()
@onready var player_name: String = Settings.load_from_file().player_name

@onready var SCORE = LeaderboardMode.new("Score", true, "pasten", "pasten", statistics.get_best_score)
@onready var DISTANCE = LeaderboardMode.new("Distance", true, "pasten", "pasten", statistics.get_best_distance)

@onready var modes_container: HBoxContainer = $PanelContainer/VBoxContainer/Modes

@onready var leaderboard_titles: MarginContainer = $"PanelContainer/VBoxContainer/Entries/Title Contatiner/LeaderboardTitles"
@onready var player_entry: MarginContainer = $PanelContainer/VBoxContainer/Entries/PlayerEntryContainer/PlayerEntry

@onready var MODES = {"Score": SCORE,"Distance": DISTANCE}



var curr_mode: LeaderboardMode
var default_mode: String = "Score"
var mode_buttons = {}

func _ready() -> void:
	generate_mode_selection()
	_on_mode_button_pressed(default_mode)
	player_entry.set_player_name(player_name)


func _style_button(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 45)
	button.focus_mode = Control.FOCUS_NONE



func generate_mode_selection():
	for mode_name in MODES.keys():
		var mode = MODES[mode_name]
		var button = Button.new()
		button.text = mode.name
		button.name = mode_name  # So we know which one was pressed
		button.pressed.connect(_on_mode_button_pressed.bind(mode_name))
		_style_button(button)
		modes_container.add_child(button)
		mode_buttons[mode_name] = button

func _on_mode_button_pressed(mode_name: String):
	curr_mode = MODES[mode_name]
	update_button_states(mode_name)
	update_table()

func update_table():
	leaderboard_titles.set_value(curr_mode.name)
	player_entry.set_value(str(curr_mode.local_value_get_function.call()))
	player_entry.set_rank("?")
	#TODO: fetch values from firebase
	

func update_button_states(active_mode_name: String):
	for name in mode_buttons:
		mode_buttons[name].disabled = (name == active_mode_name)


func set_mode(new_mode: LeaderboardMode) -> void:
	curr_mode = new_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
