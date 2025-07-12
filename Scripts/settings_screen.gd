extends Control

signal resume
signal request_open_settings
signal update_settings

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ResumeButton

@onready var panel_container: PanelContainer = $PanelContainer

@onready var sfx_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/SFXVolumeSlider
@onready var music_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/MusicVolumeSlider

@onready var mute: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row1/Mute
@onready var screen_shake: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row1/ScreenShake
@onready var vibrations: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row2/Vibrations
@onready var speedometer: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row2/Speedometer

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

var setting_settings_lock = false

func _update_settings(value) -> void:
	"""
	this function is called after a setting was changed.
	"""
	if setting_settings_lock:
		return
	_save_current_settings()
	update_settings.emit()
	
func _save_current_settings() -> void:
	"""
	saves settings from screen to file, and applys them
	"""
	var settings = Settings.load_from_file()
	settings.sfx_volume = sfx_volume_slider.value
	settings.music_volume = music_volume_slider.value
	settings.vibrations = vibrations.button_pressed
	settings.screenshake = screen_shake.button_pressed
	settings.mute = mute.button_pressed
	settings.speedometer = speedometer.button_pressed
	settings.save_to_file()
	_apply_settings()

func set_settings() -> void:
	"""
	makes sure the settings screen indicate the actual saved settings.
	"""
	setting_settings_lock = true
	print("loading")
	var settings = Settings.load_from_file()
	print(settings)
	sfx_volume_slider.value = settings.sfx_volume
	music_volume_slider.value = settings.music_volume
	vibrations.button_pressed = settings.vibrations
	screen_shake.button_pressed = settings.screenshake
	mute.button_pressed = settings.mute
	speedometer.button_pressed = settings.speedometer
	setting_settings_lock = false

func _apply_settings() -> void:
	var settings = Settings.load_from_file()
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(settings.sfx_volume/100))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(settings.music_volume/100))
	AudioServer.set_bus_mute(MASTER_BUS_ID, settings.mute)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.modulate.a = 0
	set_settings()
	_apply_settings()

func open_settings() -> void:
	animation_player.play("blur")
	resume_button.disabled = false
	request_open_settings.emit()
	

func close_settings() -> void:
	animation_player.play_backwards("blur")
	resume.emit()

	
