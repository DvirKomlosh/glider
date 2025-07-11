extends Node2D

signal request_reload
signal request_main_menu

var settings_path = "user://settings.save"

var saved_state: SavedState
var commited_state: SavedState = null

var settings
var starting_glider_position

var vibrations
var screenshake

var difficulty_level = 0

var can_revive: bool = true

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")


@onready var environment: Node2D = $Environment
@onready var glider: CharacterBody2D = $Glider
@onready var rings: Node2D = $Environment/Rings
@onready var glider_trail: Line2D = $GliderTrail
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Glider/Camera

@onready var heads_up_display: Control = $CanvasLayer/HeadsUpDisplay
@onready var settings_screen: Control = $CanvasLayer/settings
@onready var end_screen: Control = $CanvasLayer/EndScreen
@onready var revive: Control = $CanvasLayer/Revive


@onready var music: AudioStreamPlayer = $Music
@onready var ad_manager: Node = $"../AdManager"

@onready var statistics: Statistics = Statistics.load_from_file()
@onready var start_time: int = int(Time.get_unix_time_from_system())

var score = 0
var best_score = 0
var distance = 0
var best_distance = 0

var combo = 1
var is_game_over = false

func _get_current_state() -> SavedState:
	return SavedState.new(glider.position, glider.velocity, glider.rotation, score, combo)

func _commit_state(state: SavedState) -> void:
	commited_state = state

func save_state() -> void:
	_commit_state(saved_state)
	saved_state = _get_current_state()

	
func _reload_state() -> void:
	is_game_over = false
	glider.position = commited_state.position
	glider.velocity = commited_state.velocity
	glider.rotation = commited_state.rotation
	score = commited_state.score
	combo = commited_state.combo
	glider.reset_state()
	glider_trail.reset_trail()
	_process(0)
	
	await get_tree().process_frame
	rings.reset_rings(glider.position)
	
	animation_player.play("RESET")

	get_tree().paused = true
	await heads_up_display.countdown()
	get_tree().paused = false


	

func update_glider_position(pos: Vector2, speed: float) -> void:
	'''
	updates relavent functions of the glider position
	'''
	glider_trail.add_trail_point(pos, speed)
	rings.update_indicator(pos)
	
	
func save_statistics():
	"""
	saves all statistics from the end of the game
	
	the setters and getters of the statistics fields change only for a bigger value, 
	so we can just try to set instead of checking for max
	"""
	statistics.best_score = max(statistics.best_score, score)
	statistics.best_distance = max(statistics.best_distance, distance)
	statistics.games_played += 1
	statistics.time_played += int(Time.get_unix_time_from_system()) - start_time
	statistics.total_distance_traveled += distance
	statistics.acumulated_score += score
	
	print("game done, statistics:")
	print(statistics)
	

func _set_game_over() -> void:
	if is_game_over:
		return
	save_statistics()
	is_game_over = true
	animation_player.play("death")
	await animation_player.animation_finished
	end_screen.set_scores(score, statistics.best_score, distance, statistics.best_distance)
	_end_game()

func _end_game() -> void:
	if can_revive and commited_state and ad_manager.is_ad_loaded():
		revive.show_menu()
		return
	end_screen.end()
		
func _on_revive_request(is_requested: bool) -> void:
	if is_requested and await ad_manager.try_get_reward():
		await revive.clean()
		can_revive = false
		statistics.revives += 1
		_reload_state()
		return
	else:
		await revive.clean()
		end_screen.end()


func _in_hoop() -> void:
	if not is_game_over:
		statistics.total_rings_gone_through += 1
		statistics.best_combo = max(statistics.best_combo, combo)
		glider.in_hoop(combo)
		score += combo
		combo += 1
		animation_player.seek(0, true)
		animation_player.play("in_hoop")
					
func _out_hoop() -> void:
	combo = 1

func _ready() -> void:
	load_settings()
	music.playing = true
	glider.position = starting_glider_position


func _calculate_difficulty() -> float:
	'''
	difficulty starts at 0 and reaches slowly to 1 (is 1 at infinity)
	at distance = 500 it difficulty is 1/2
	'''
	
	return 1 - (1 / (1 + (distance / 500.0)))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	distance = int(glider.position.x / 1000)
	difficulty_level = _calculate_difficulty()
	environment.set_difficulty(difficulty_level)
	# set glider UI position
	var speed = glider.velocity.length()
	statistics.max_speed = max(statistics.max_speed, int(speed/1000))
	
	heads_up_display.update_score(score)
	heads_up_display.update_distance(distance)
	heads_up_display.update_speed(speed)
	
	
func _on_ready_to_set_glider_position(pos_x: float, pos_y: float) -> void:
	starting_glider_position = Vector2(pos_x, pos_y + 500)

func _vibrate_screen(millieseconds: int) -> void:
	if vibrations:
		Input.vibrate_handheld(millieseconds)

func _on_update_settings(new_settings: Settings) -> void:
	settings = new_settings
	apply_settings()
	
func apply_settings() -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(settings.sfx_volume/100))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(settings.music_volume/100))
	AudioServer.set_bus_mute(MASTER_BUS_ID, settings.mute)
	vibrations = settings.vibrations
	screenshake = settings.screenshake
	heads_up_display.display_speedometer(settings.speedometer)
	camera.set_screenshake(screenshake)
	
func load_settings() -> void:
	if FileAccess.file_exists(settings_path):
		var file = FileAccess.open(settings_path, FileAccess.READ)
		settings = file.get_var(true)
	else:
		settings = Settings.new()
	settings_screen.set_settings(settings)
	
func save_settings() -> void:
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	file.store_var(settings, true)
	

func _on_settings_button_pressed() -> void:
	rings.unset_all_indicators()
	settings_screen.open_settings()
	

func _on_resume() -> void:
	rings.set_all_indicators()
	heads_up_display.show_settings_button()


func _on_request_reload() -> void:
	request_reload.emit()


func _on_request_main_menu() -> void:
	request_main_menu.emit()
