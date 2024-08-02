extends Node2D

signal in_hoop

# Called when the node enters the scene tree for the first time.
func _ready():
	for ring in get_children():
		ring.in_hoop.connect(send_in_hoop)

func send_in_hoop():
	in_hoop.emit() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
