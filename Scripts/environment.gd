extends Node2D

var min_passage_width: float= 200.0
var section_length: float = 10000.0
var section_size: int = 10
var subsection_length: float = section_length / section_size

var noise_down = FastNoiseLite.new()
var noise_up = FastNoiseLite.new()
var noise_path = FastNoiseLite.new()

var next_ring_position = 6000
var ring_distance = 10000
var ring_distance_distance = 2000

var y_values = Vector2(0, 10000)
var x_value = -section_length * 2

@onready var rings = $Rings
@onready var walls = $Walls


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise_down.seed = randi()
	noise_down.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_down.frequency = 0.1
	
	noise_up.seed = randi()
	noise_up.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_up.frequency = 0.1
	
	noise_path.seed = randi()
	noise_path.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_path.frequency = 0.03
	
	for i in range(5):
		_generate_walls(x_value, y_values[0], y_values[1])
		
		# Set the glider slightly below the celing, at the start
		if abs(x_value) < subsection_length:
			$"../Glider".position = Vector2(x_value, y_values[0] + 300)
		
		

func _generate_ring(x_pos, down1, down2, up1, up2):
	'''
	generates a ring at the next ring position, at the middle of the tunnel
	'''
	# calculates the middle of the tunnel to place a ring
	var ratio_x = (x_pos - down1.x) / (down2.x - down1.x)  
	var y_down = down1.y * (1 - ratio_x) + down2.y * ratio_x
	var y_up = up1.y * (1 - ratio_x) + up2.y * ratio_x
	
	var y_pos = (y_up + y_down) / 2
	
	_generate_next_ring_position()
	rings.call_deferred("instentiate_ring",(Vector2(x_pos, y_pos)))
	
func on_wall_entred():
	_generate_walls(x_value, y_values[0], y_values[1])
	walls.call_deferred("destroy_last")
	rings.remove_rings(x_value - section_length * 5)
	
	
func _generate_walls(starting_x: float, y_down: float, y_up: float):
	'''
	generates 2 lists of a points to make walls out of.
	'''
	var up_points = []
	var down_points = []
	var last_x = starting_x
	up_points.append(Vector2(starting_x, y_up))
	down_points.append(Vector2(starting_x, y_down))
	
	for i in range(section_size):
		var x = starting_x + subsection_length * (i + 1) 
		var slope_down = atanh(noise_down.get_noise_1d(x * 0.001)) + 0.01
		var slope_up = atanh(noise_up.get_noise_1d(x * 0.001)) - 0.01
		var path = 1500 * noise_path.get_noise_1d(x * 0.001)
		y_down = y_down + slope_down * subsection_length + path
		y_up = y_up + slope_up * subsection_length + path
		
		if y_up - y_down < 4000:
			y_up = y_down + 8000
			
		down_points.append(Vector2(x, y_down))
		up_points.append(Vector2(x, y_up))
		
		if next_ring_position <= x and next_ring_position > last_x:
			_generate_ring(next_ring_position, down_points[-1], down_points[-2], up_points[-1],up_points[-2])
		
		last_x = x
	
	walls.instantiate_wall(down_points, up_points)
	
	x_value += section_length
	y_values = Vector2(y_down, y_up)  
	
func _generate_next_ring_position():
	'''
	returns the next ring position
	'''
	next_ring_position += ring_distance
	ring_distance += ring_distance_distance
	
	return next_ring_position
