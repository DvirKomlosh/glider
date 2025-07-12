extends CharacterBody2D

signal dead
signal add_trail(position, speed)

var ACC_MULT = 2.0

var forward_dir: Vector2
var acc
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var points: Label = $Points
@onready var trail_position: Marker2D = $TrailPosition
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var glider_trail: Line2D = $GliderTrail

var wanted_point = Vector2(-1000, 60)
var glider_wanted_rotation = 0.0
var trail_color = Color("56a7b6")

var is_alive = true
var debug_mode = false

func control():
	glider_wanted_rotation = (wanted_point - global_position).angle()

func boosted():
	animation_player.stop()
	animation_player.play("boost")

func _ready() -> void:
	rotation = 0
	wind_player.volume_db = -50
	set_process_unhandled_input(true)
	glider_trail.trail_speed = 400
	glider_trail.set_max_trail_points(50)
	velocity = Vector2(3000, 0)
	


func sigmoid(x: float) -> float:
	return 1 / (1.0 + exp(10 * (-x+0.5)))


	
func set_glider_rotation(controller_value: float) -> void:
	if is_alive:
		glider_wanted_rotation = asin( - controller_value/90)

func _process(delta: float) -> void:
	control()
	points.rotation = -rotation
	var screen_height = 5040.0
	glider_trail.default_start_color = trail_color
	var speed = 0
	if is_alive:
		speed = velocity.length()
	
	add_trail.emit(trail_position.global_position, speed)
	glider_trail.add_trail_point(trail_position.global_position, speed, delta)
	
	# clamp rotation:
	glider_wanted_rotation = max(glider_wanted_rotation,-PI/2)
	glider_wanted_rotation = min(glider_wanted_rotation, PI/2)
	rotation = lerp(rotation, glider_wanted_rotation, 0.01)
	glider_trail.rotation = -rotation



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 1 * delta
	
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
	
	var force =  1 * abs(vertical_surface * forward_speed) + 1 * abs(horizontal_surface * down_speed)
	

	
	
	acc = normal_dir * force * delta * 2
	
	# the lift should acclarate towards the normal of the plane,
	# if we have accelerated too much, we are going in the normal's direction,
	# in which case the lift should make us slow down and not speed up 
	if velocity.dot(normal_dir) > 0:
		acc *= -1
	
	# boost:
	if Input.is_key_pressed(KEY_SPACE):
		velocity += forward_dir * 100
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().paused = !get_tree().paused
	
	acc *= ACC_MULT
	velocity += acc 

	# always going forward:
	velocity.x = max(0, velocity.x)
	
	
	
	if is_alive:
		var collided = move_and_slide()
		if position.x > 2000 or position.y > 1200:
			collided = true
		if collided:
			is_alive = false
			animation_player.play("Explode")
			await animation_player.animation_finished
			create_tween().tween_property(self, "velocity", Vector2(0,0),0.1)
			dead.emit()
			queue_free()
	else:
		velocity = Vector2(0, 0)
	
		
	queue_redraw()

func reset_state() -> void:
	is_alive = true
	animation_player.stop()
	animation_player.seek(0.0, true)
	glider_wanted_rotation = rotation
	glider_trail.reset_trail()
	

func _draw() -> void:
	'''
	shows vectors of accslaration and velocity on debug mode.
	'''
	if debug_mode:
		draw_line(Vector2(0,0),Vector2(1,0) * 500,Color.AQUA, 10)
		draw_line(Vector2(0,0),Vector2(0,-1) * 500,Color.AQUA, 10)
		draw_line(Vector2(0,0), velocity.rotated(-rotation) ,Color.RED, 10)
		draw_line(velocity.rotated(-rotation), velocity.rotated(-rotation)+acc.rotated(-rotation) ,Color.GREEN, 10)
		draw_line(Vector2(0,0), acc.rotated(-rotation) ,Color.GREEN, 10)

func in_hoop(combo: int) -> void:
	velocity += forward_dir * 3000
