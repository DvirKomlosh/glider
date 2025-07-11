extends Control

var version = 1 # should change for any addition/delition/edit of MODES or their content
var FULL_PAGE = 10

signal back_to_menu
signal request_data

@onready var statistics: Statistics = Statistics.load_from_file()

@onready var SCORE = LeaderboardMode.new("Score", true, "pasten", "pasten", statistics.get_best_score)
@onready var DISTANCE = LeaderboardMode.new("Distance", true, "pasten", "pasten", statistics.get_best_distance)


@onready var cache_manager: Node = $CacheManager
@onready var error_message: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ErrorMessage
@onready var modes_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Modes
@onready var leaderboard_titles: MarginContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Entries/TitleContatiner/LeaderboardTitles
@onready var global_entries: VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Entries/GlobalEntries
@onready var player_entry: MarginContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Entries/PlayerEntryContainer/PlayerEntry


@onready var MODES = {"Score": SCORE,"Distance": DISTANCE}
@onready var navigation_button: Button = $HBoxContainer/PanelContainer/MarginContainer/NavigationButton

const leaderboard_entry = preload("res://Scences/LeaderboardEntry.tscn")
const ACCOUNT_ICON = preload("res://Assets/Art/account_box.svg")
const TROPHY_ICON = preload("res://Assets/Art/trophy.svg")
var navigation_top = true

@onready var right_button: Button = $HBoxContainer/RightButton
@onready var left_button: Button = $HBoxContainer/LeftButton
var curr_page_first_index = 0

var curr_mode: LeaderboardMode
var curr_data: Array
var curr_player_index: int

var default_mode: String = "Score"
var mode_buttons = {}
var leaderboard_data : Dictionary

var curr_entries

func _ready() -> void:
	cache_manager.set_cache(MODES, version)

func _setup() -> void:
	var player_name: String = Settings.load_from_file().player_name
	player_entry.set_player_name(player_name)
	generate_mode_selection()
	_on_mode_button_pressed(default_mode)

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
	var player_name: String = Settings.load_from_file().player_name
	leaderboard_titles.set_value(curr_mode.name)
	var player_value = curr_mode.local_value_get_function.call()
	var player_data = [player_name, player_value]
	
	curr_data = cache_manager.load_binary_mode_file(curr_mode)
	if len(curr_data) == 0:
		error_message.text = "Error, Check internet Connection"
		error_message.visible = true
	else:
		error_message.visible = false
	
	var index = curr_data.bsearch_custom(player_data, func(a, b): return (0 < (b[1] - a[1])) != curr_mode.decending_order)
	curr_data.insert(index, player_data)
	
	player_entry.set_rank(str(index + 1))
	player_entry.set_value(str(player_value))
	curr_player_index = index
	reset_navigation()
	update_entries(0, FULL_PAGE)

func update_entries(start_index: int, end_index: int):
	for child in global_entries.get_children():
		child.queue_free()
	if start_index >= len(curr_data):
		push_error("indecies too big!")
		return
	end_index = min(end_index, len(curr_data))
	
	left_button.disabled = false
	right_button.disabled = false
	if start_index == 0:
		left_button.disabled = true
	if end_index == len(curr_data):
		right_button.disabled = true
	
	curr_page_first_index = start_index
	for i in range(start_index, end_index):
		add_entry(curr_data[i], i + 1)

func add_entry(entry_data: Array, rank: int):
	var new_entry = leaderboard_entry.instantiate()
	global_entries.add_child(new_entry)
	new_entry.set_rank(str(rank))
	new_entry.set_player_name(entry_data[0])
	new_entry.set_value(str(entry_data[1]))

func update_button_states(active_mode_name: String):
	for name in mode_buttons:
		mode_buttons[name].disabled = (name == active_mode_name)


func set_mode(new_mode: LeaderboardMode) -> void:
	curr_mode = new_mode

func get_leaderboard_json() -> Variant:
	var player_name: String = Settings.load_from_file().player_name
	var json = {'Name': player_name, 'Version': version}
	for mode in MODES.values():
		json[mode.name] = mode.local_value_get_function.call() 
	return json

func save_data(data: Variant) -> void:
	var player_name: String = Settings.load_from_file().player_name
	cache_manager.save_data(data, player_name)


func _on_back_button_pressed() -> void:
	back_to_menu.emit()

func reset_navigation() -> void:
	navigation_top = true
	navigation_button.icon = ACCOUNT_ICON



func _on_navigation_button_pressed() -> void:
	if(navigation_top):
		navigation_button.icon = TROPHY_ICON
		var page_first_rank = curr_player_index - curr_player_index % FULL_PAGE
		update_entries(page_first_rank, page_first_rank + FULL_PAGE)		
	else:
		navigation_button.icon = ACCOUNT_ICON
		update_entries(0, FULL_PAGE)
		
	navigation_top = not navigation_top


func _on_left_button_pressed() -> void:
	update_entries(curr_page_first_index - FULL_PAGE, curr_page_first_index)


func _on_right_button_pressed() -> void:
	update_entries(curr_page_first_index + FULL_PAGE, curr_page_first_index + FULL_PAGE * 2)


func _on_cache_manager_request_data() -> void:
	request_data.emit()
