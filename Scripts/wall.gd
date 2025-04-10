extends Node2D

signal wall_entred

var WALL_COLOR = Color("#191726")

var up_wall_points 
var down_wall_points
var wall_size = 10000
var entrance_thickness = 1000

func _set_up_polygons() -> void:
	'''
		sets up the polygons of the walls, with a StaticBody2D, a CollisionPolygon2D and a Polygon2D
		#TODO: lots of code duplication in this function, fix it.
	'''
	var extreme_x = Vector2(down_wall_points[0].x, down_wall_points[-1].x)
	
	# create down polygon points to close the shape
	var down_points_polygon = down_wall_points
	down_points_polygon.append(Vector2(extreme_x[1] ,down_wall_points[-1].y - wall_size))
	down_points_polygon.append(Vector2(extreme_x[0] ,down_wall_points[0].y - wall_size))
	
	# create up polygon points to close the shape
	var up_points_polygon = up_wall_points
	up_points_polygon.append(Vector2(extreme_x[1] ,up_wall_points[-1].y + wall_size))
	up_points_polygon.append(Vector2(extreme_x[0] ,up_wall_points[0].y + wall_size))
	
	var down_static = StaticBody2D.new()
	var down_collision = CollisionPolygon2D.new()
	var down_polygon = Polygon2D.new()
	down_polygon.color = WALL_COLOR
	
	down_collision.polygon = PackedVector2Array(down_points_polygon)
	down_static.add_child(down_collision)
	add_child(down_static)
	
	down_polygon.polygon = PackedVector2Array(down_points_polygon)
	add_child(down_polygon)
	
	var up_static = StaticBody2D.new()
	var up_collision = CollisionPolygon2D.new()	
	var up_polygon = Polygon2D.new()
	up_polygon.color = WALL_COLOR
	
	up_collision.polygon = PackedVector2Array(up_points_polygon)
	up_static.add_child(up_collision)
	add_child(up_static)
	
	up_polygon.polygon = PackedVector2Array(up_points_polygon)
	add_child(up_polygon)


func _set_up_entrance() -> void:
	'''
	sets up an imaginary "enterance" Collision shape for the wall to detect the glider getting into the section
	'''
	var entrance_shape = Vector2(entrance_thickness, up_wall_points[0].y  - down_wall_points[0].y)
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
		wall_entred.emit()
	
func _ready() -> void:
	call_deferred("_set_up_polygons")
	call_deferred("_set_up_entrance")
	
