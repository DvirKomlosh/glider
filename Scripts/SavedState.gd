extends Resource
class_name SavedState

@export var position: Vector2
@export var velocity: Vector2
@export var rotation: float
@export var score: int
@export var combo: int


func _init(
	position: Vector2,
	velocity: Vector2,
	rotation: float,
	score: int,
	combo: int
) -> void:
	self.position = position
	self.rotation = rotation
	self.velocity = velocity
	self.score = score
	self.combo = combo

func _to_string() -> String:
	return "[SavedState: pos=%s, rot=%.2f, vel=%s, score=%d, combo=%d]" % [
		position, rotation, velocity, score, combo
	]
