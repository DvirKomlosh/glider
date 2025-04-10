extends Node2D

signal wall_entred

var wall_scene = preload("res://Scences/Wall.tscn")
var walls = []

func _wall_entred() -> void:
	wall_entred.emit()
	
func destroy_last() -> void:
	'''
	destroys the last wall, and removes it from the tree
	'''
	if len(walls) > 0:
		remove_child(walls[0])
		walls.remove_at(0)

func instantiate_wall(points_down, points_up) -> void:
	'''
	creates a wall with the given points
	'''
	
	var new_wall = wall_scene.instantiate()
	new_wall.down_wall_points = points_down
	new_wall.up_wall_points = points_up
	add_child(new_wall)
	new_wall.wall_entred.connect(_wall_entred)

	walls.append(new_wall)
