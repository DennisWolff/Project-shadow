extends RigidBody2D

var original_position: Vector2
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	original_position = position
	original_position = position
	linear_velocity.y = 0
