extends CharacterBody2D


const ACC_MULT = 4.0



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	#velocity.x += 200
	pass

func _process(delta):

	var screen_height = 5040.0
	rotation = (get_global_mouse_position().y - screen_height / 2) / screen_height  * PI 
	rotation = max(rotation,-PI/2)
	rotation = min(rotation, PI/2)
	
	rotation = 0

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * 3 * delta
	
	var pitch = rotation
	var pitchcos = cos(pitch)
	var pitchsin = sin(pitch)
	var squared_pitchcos = pitchcos * pitchcos
	
	
	## calculate drag:
	
	var down_speed = velocity.y
	var forward_speed = velocity.x
	var air_resistance = 0.99

	var forward_dir : Vector2 = Vector2(pitchcos,pitchsin)
	var normal_dir = Vector2(cos(pitch - PI/2),sin(pitch - PI/2))
	var force = abs(forward_dir.x * velocity.x + forward_dir.y * velocity.y)
	force  += 0.2 * (forward_dir.y * velocity.x + forward_dir.x * velocity.y)


	var acc = normal_dir * force * delta * 2

	if velocity.dot(normal_dir) > 0:
		velocity -= acc
	else:
		velocity += acc
	velocity.x = max(0,velocity.x)
	
	move_and_slide()
