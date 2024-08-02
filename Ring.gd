extends Node2D

signal in_hoop

func _on_in_loop(body):
	print("SUCCESS!")
	in_hoop.emit()
