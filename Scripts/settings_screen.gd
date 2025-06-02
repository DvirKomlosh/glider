extends Control

signal resume_game
signal save_settings
signal update_settings(settings: Settings)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume: Button = $PanelContainer/MarginContainer/VBoxContainer/resume

@onready var panel_container: PanelContainer = $PanelContainer

@onready var sfx_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/SFXVolumeSlider
@onready var music_volume_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Sliders/MusicVolumeSlider

@onready var screen_shake_check_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Checkboxes/ScreenShake/ScreenShakeCheckBox
@onready var vibrations_check_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Checkboxes/Vibrations/VibrationsCheckBox
@onready var mute_check_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/Checkboxes/Mute/MuteCheckBox


func _update_settings(value) -> void:
	var settings = _get_current_settings()
	update_settings.emit(settings)
	

func _get_current_settings() -> Settings:
	var settings = Settings.new()
	settings.sfx_volume = sfx_volume_slider.value
	settings.music_volume = music_volume_slider.value
	settings.vibrations = vibrations_check_box.button_pressed
	settings.screenshake = screen_shake_check_box.button_pressed
	settings.mute = mute_check_box.button_pressed
	return settings

func set_settings(settings: Settings):
	sfx_volume_slider.value = settings.sfx_volume
	music_volume_slider.value = settings.music_volume
	vibrations_check_box.button_pressed = settings.vibrations
	screen_shake_check_box.button_pressed = settings.screenshake
	mute_check_box.button_pressed = settings.mute


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

	
