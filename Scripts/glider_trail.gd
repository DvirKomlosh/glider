extends Line2D

var trail_offset = Vector2(200, 0)
var queue : Array
var MAX_TRAIL_POINTS = 30

@export var default_start_color = Color("56a7b6")
@export var start_color = Color("56a7b6")

func _ready() -> void:
	width_curve.point_count = MAX_TRAIL_POINTS
	width_curve = get_default_curve()
	width_curve.bake()
	
	var distance = 1.0 / MAX_TRAIL_POINTS
	

func get_default_curve() -> Curve:
	'''
	makes a default linear curve for the trail, with enough points.
	'''
	var distance = 1.0 / MAX_TRAIL_POINTS
	var curve = Curve.new()
	for i in range(MAX_TRAIL_POINTS):
		curve.add_point(Vector2(distance * i, 1 - distance * i))

	return curve

func propegate_curve(size: float) -> void:
	'''
	changes the curve of the trail, makes sure that zeros stay zeros, and that other points are kept linear.
	'''
	var distance = 1.0 / MAX_TRAIL_POINTS
	var new_curve = Curve.new()
	new_curve.add_point(Vector2(0,size))
	for i in range(width_curve.point_count - 1):
		var last = width_curve.get_point_position(i)
		if last.y == 0:
			new_curve.add_point(Vector2(distance * (i+1), 0))
		else:
			new_curve.add_point(Vector2(distance * (i+1), 1 - distance * (i+1)))
	
	
	width_curve = new_curve
	width_curve.bake()		
	return
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	start_color = start_color.lerp(default_start_color, 0.02)
	
	gradient.set_color(0, start_color)
	clear_points()
	for point in queue:
		add_point(point)

	
func add_trail_point(trail_position: Vector2, speed: float) -> void:
	'''
	adds the new point to the trail.
	'''
	queue.push_front(trail_position)
	var size = 0
	if speed > 4000:
		size = clamp(speed / (2 * 4000), 0.5, 2.5)
	propegate_curve(size)
		
	if len(queue) > MAX_TRAIL_POINTS:
		queue.pop_back()
		
	
