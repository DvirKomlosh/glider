extends CharacterBody2D


var ACC_MULT = 2.0

var forward_dir: Vector2
var acc
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var alive = true

func _ready():
	#velocity.x += 200
	pass

func _process(delta):
		
	var screen_height = 5040.0
	if alive:
		look_at(get_global_mouse_position())
	#rotation = (get_local_mouse_position().y - screen_height / 2) / screen_height  * PI 
	rotation = max(rotation,-PI/2)
	rotation = min(rotation, PI/2)
	
	#rotation = PI/2

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 5 * delta
	
	var pitch = rotation
	var pitchcos = cos(pitch)
	var pitchsin = sin(pitch)
	var squared_pitchcos = pitchcos * pitchcos
	
	
	## calculate drag:
	
	var down_speed = velocity.y
	var forward_speed = velocity.x
	var air_resistance = 0.99

	forward_dir = Vector2(pitchcos,pitchsin)
	var normal_dir = Vector2(cos(pitch - PI/2),sin(pitch - PI/2))
	#var force = abs(forward_dir.x * velocity.x + forward_dir.y * velocity.y)
	var force = abs(forward_dir.y * velocity.x) + abs(forward_dir.x * velocity.y)
	#force = 0
	#print(force)
	#print(normal_dir)
	#print(velocity.dot(normal_dir))
	

	#print(force)
	acc = normal_dir * force * delta * 2

	#if velocity.dot(normal_dir) > 0:
		#velocity -= acc
	#else:
		#velocity += acc
		#
		#
	#velocity += acc
	
	if velocity.dot(normal_dir) > 0:
		acc *= -1
	acc *= ACC_MULT
	velocity += acc 
	
	velocity.x = max(0,velocity.x)
	#
	
	
	if Input.is_key_pressed(KEY_SPACE):
		#velocity.x += 300
		ACC_MULT = 40
	if not Input.is_key_pressed(KEY_SPACE):
		#velocity.x += 300
		ACC_MULT = 2.0
	
	var collided = move_and_slide()
	if collided:
		print("collision!")
		alive = false
		create_tween().tween_property($".", "rotation", -PI/2, 1)
		
		
	queue_redraw()

func _draw():
	pass
	#draw_line(Vector2(0,0),Vector2(1,0) * 500,Color.AQUA, 10)
	#draw_line(Vector2(0,0),Vector2(0,-1) * 500,Color.AQUA, 10)
	#draw_line(Vector2(0,0), velocity.rotated(-rotation) ,Color.RED, 10)
	#draw_line(velocity.rotated(-rotation), velocity.rotated(-rotation)+acc.rotated(-rotation) ,Color.GREEN, 10)
	#draw_line(Vector2(0,0), acc.rotated(-rotation) ,Color.GREEN, 10)

func in_hoop():
	velocity += forward_dir * 3000
	#velocity.x += 1500
	#$Glider.velocity *= 1.4
	
