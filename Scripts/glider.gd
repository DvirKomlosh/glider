extends CharacterBody2D

signal dead
signal add_trail(position, speed)

var ACC_MULT = 2.0

var forward_dir: Vector2
var acc
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var wind_player = $WindPlayer

var is_alive = true
var debug_mode = false

func _show_points(combo):
	var points = $Points
	
	points.scale = Vector2(0.6, 0.6)
	points.text = "+" + str(combo)
	var points_tween = create_tween()
	points_tween.tween_property(points, "scale", Vector2(1.1,1.1),0.1)
	points_tween.tween_property(points, "scale", Vector2(1.1,1.1),0.3)
	points_tween.tween_property(points, "scale", Vector2(0,0),0.1)	

func _ready():
	rotation = 0
	wind_player.volume_db = -50

func sigmoid(x: float) -> float:
	return 1 / (1.0 + exp(10 * (-x+0.5)))


func _play_sound(delta):
	var speed = velocity.length()
	var halflife = 0.05
	var base_volume = -10
	var target_volume = base_volume + linear_to_db(sigmoid(speed/30000.0))

	var new_volume = lerp(wind_player.volume_db,target_volume, (1 - 2 ** (-delta / halflife)))
	
	
	wind_player.volume_db = new_volume
	

func _process(delta):
	
	$Points.rotation = -rotation
	var screen_height = 5040.0
	if is_alive:
		rotation = asin( - $"../CanvasLayer/Controller".value/90)
	
	# if alive, size = 0
	# if speed < x -> size = 0
	# if speed > x, size = clamp(0.5,1, speed/2 / x) color = ??? based on speed tho
	var speed = 0
	if is_alive:
		speed = velocity.length()

	add_trail.emit($TrailPosition.global_position, speed)
	# clamp rotation:
	rotation = max(rotation,-PI/2)
	rotation = min(rotation, PI/2)
	
	_play_sound(delta)

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 5 * delta
	
	var pitch = rotation
	var pitchcos = cos(pitch)
	var pitchsin = sin(pitch)
	var squared_pitchcos = pitchcos * pitchcos
	
	
	## calculate drag:
	forward_dir = Vector2(pitchcos,pitchsin)

	var down_speed = velocity.y
	var forward_speed = velocity.x
	var vertical_surface = forward_dir.y
	var horizontal_surface = forward_dir.x

	var normal_dir = Vector2(cos(pitch - PI/2),sin(pitch - PI/2))
	
	# force is proportional to the amount of air heating the plane
	# TODO: check if i playing with the coeficiants may work in my favor, setting the influence of the horizontal surface lower should combat parachuting
	var force =  1 * abs(vertical_surface * forward_speed) + 1 * abs(horizontal_surface * down_speed)
	
	# first coof - gives you the ability to "go up" when fast - _____/
	# second coof - gives the ability to "go forward" when falling quickly - \___
	# too much of second coof - parachuting	
	# too much first coof - like parachuting but first get speed by diving, then go up?

	
	
	acc = normal_dir * force * delta * 2
	
	# the lift should acclarate towards the normal of the plane,
	# if we have accelerated too much, we are going in the normal's direction,
	# in which case the lift should make us slow down and not speed up 
	if velocity.dot(normal_dir) > 0:
		acc *= -1
	
	# boost:
	if Input.is_key_pressed(KEY_SPACE):
		velocity += forward_dir * 100
	
	acc *= ACC_MULT
	velocity += acc 
	
	# always going forward:
	velocity.x = max(0, velocity.x)

	
	var collided = move_and_slide()
	if collided:
		is_alive = false
		dead.emit()
		create_tween().tween_property($".", "rotation", -PI/2, 1)
	
		
	queue_redraw()

func _draw():
	if debug_mode:
		#draw_line(Vector2(0,0),Vector2(1,0) * 500,Color.AQUA, 10)
		#draw_line(Vector2(0,0),Vector2(0,-1) * 500,Color.AQUA, 10)
		draw_line(Vector2(0,0), velocity.rotated(-rotation) ,Color.RED, 10)
		draw_line(velocity.rotated(-rotation), velocity.rotated(-rotation)+acc.rotated(-rotation) ,Color.GREEN, 10)
		#draw_line(Vector2(0,0), acc.rotated(-rotation) ,Color.GREEN, 10)

func in_hoop(combo):
	_show_points(combo)
	velocity += forward_dir * 3000
