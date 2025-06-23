extends Node2D

signal wall_entred

var WALL_COLOR = Color("#191726")

var up_wall_points 
var down_wall_points
var WALL_SIZE = 20000
var ENTERANCE_THICKNESS = 1000
var already_entred = false


func _set_up_wall_object(points: Array) -> void:
	var static_body = StaticBody2D.new()
	var collision_polygon = CollisionPolygon2D.new()
	var polygon = Polygon2D.new()
	polygon.color = WALL_COLOR
	
	collision_polygon.polygon = PackedVector2Array(points)
	static_body.add_child(collision_polygon)
	add_child(static_body)
	
	polygon.polygon = PackedVector2Array(points)
	add_child(polygon)
	

func _set_up_polygons() -> void:
	'''
		sets up the polygons of the walls, with a StaticBody2D, a CollisionPolygon2D and a Polygon2D
		#TODO: lots of code duplication in this function, fix it.
	'''
	var extreme_x = Vector2(down_wall_points[0].x, down_wall_points[-1].x)
	
	# create down polygon points to close the shape
	var down_points_polygon = down_wall_points
	down_points_polygon.append(Vector2(extreme_x[1] ,down_wall_points[-1].y - WALL_SIZE))
	down_points_polygon.append(Vector2(extreme_x[0] ,down_wall_points[0].y - WALL_SIZE))
	
	# create up polygon points to close the shape
	var up_points_polygon = up_wall_points
	up_points_polygon.append(Vector2(extreme_x[1] ,up_wall_points[-1].y + WALL_SIZE))
	up_points_polygon.append(Vector2(extreme_x[0] ,up_wall_points[0].y + WALL_SIZE))
	
	_set_up_wall_object(up_points_polygon)
	_set_up_wall_object(down_points_polygon)
	


func _set_up_entrance() -> void:
	'''
	sets up an imaginary "enterance" Collision shape for the wall to detect the glider getting into the section
	'''
	var entrance_shape = Vector2(ENTERANCE_THICKNESS, up_wall_points[0].y  - down_wall_points[0].y)
	var entrance_position =  Vector2(up_wall_points[0].x, (up_wall_points[0].y + down_wall_points[0].y) / 2)
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	shape.extents = entrance_shape
	collision.shape = shape
	collision.position = entrance_position
	
	area.add_child(collision)
	add_child(area)
	
	area.connect("body_entered", Callable(self,"_on_body_entred"))

func _on_body_entred(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not already_entred:
			already_entred = true
			wall_entred.emit()
	
func _ready() -> void:
	call_deferred("_set_up_polygons")
	call_deferred("_set_up_entrance")
	
