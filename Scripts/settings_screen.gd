extends Control

signal resume_game
signal save_settings
signal update_settings(settings: Settings)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume: Button = $PanelContainer/MarginContainer/VBoxContainer/resume

@onready var panel_container: PanelContainer = $PanelContainer

@onready var sfx_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/SFXVolumeSlider
@onready var music_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/MusicVolumeSlider

@onready var mute: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row1/Mute
@onready var screen_shake: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row1/ScreenShake
@onready var vibrations: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row2/Vibrations
@onready var speedometer: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Columns/Row2/Speedometer

func _update_settings(value) -> void:
	var settings = _get_current_settings()
	update_settings.emit(settings)
	

func _get_current_settings() -> Settings:
	var settings = Settings.new()
	settings.sfx_volume = sfx_volume_slider.value
	settings.music_volume = music_volume_slider.value
	settings.vibrations = vibrations.button_pressed
	settings.screenshake = screen_shake.button_pressed
	settings.mute = mute.button_pressed
	settings.speedometer = speedometer.button_pressed
	return settings

func set_settings(settings: Settings) -> void:
	sfx_volume_slider.value = settings.sfx_volume
	music_volume_slider.value = settings.music_volume
	vibrations.button_pressed = settings.vibrations
	screen_shake.button_pressed = settings.screenshake
	mute.button_pressed = settings.mute
	speedometer.button_pressed = settings.speedometer


func open_settings() -> void:
	get_tree().paused = true
	animation_player.play("blur")
	resume.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.modulate.a = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func close_settings() -> void:
	get_tree().paused = false
	animation_player.play_backwards("blur")
	save_settings.emit()
	resume_game.emit()

	
