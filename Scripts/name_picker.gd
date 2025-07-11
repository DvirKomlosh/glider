extends Control

@onready var submit_button: Button = $MarginContainer/VBoxContainer/SubmitButton
@onready var text_edit: TextEdit = $MarginContainer/VBoxContainer/TextEdit
@onready var error_message: Label = $MarginContainer/VBoxContainer/ErrorMessage
@onready var animation_player: AnimationPlayer = $AnimationPlayer


signal name_submitted(name: String)

func _on_submit_pressed():
	var name = text_edit.text.strip_edges()
	if _is_legal(name):
		animation_player.play("loading")
		emit_signal("name_submitted", name)

func on_failed_set_name(reason: String):
	# reanable submit button, stop loading animation.
	animation_player.play("RESET")
	error_message.text = reason


func _is_legal(name: String) -> bool:
	var length = len(name)
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_-]+$") 

	if length < 3:
		error_message.text = "name's too short, it should have at least 3 characters"
		return false
	if length > 16:
		error_message.text = "name's too long, it should have up to 16 characters"
		return false
		
	if not regex.search(name):
		error_message.text = "name should only contain English letters,\n Numbers, dashes (-) and underscores (_)"
		return false

	return true
	
