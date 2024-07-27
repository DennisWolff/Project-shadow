extends RigidBody2D
class_name FallingPlatform
@export var fall_delay: float = 0.6  # Delay before the platform falls
@export var fall_speed: float = 400  # Speed at which the platform falls
@export var disappear_delay: float = 0.5  # Delay before the platform disappears
@export var reappear_delay: float = 1.0  # Delay before the platform reappears

@onready var timer = $Timer
@onready var area = $Area2D

var original_position: Vector2
var is_falling: bool = false

func _ready():
	# Store the original position of the platform
	original_position = position
	angular_velocity = 0
	# Initially, the platform should not be affected by gravity
	gravity_scale = 0
	timer.wait_time = fall_delay
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_timer_timeout():
	# Start falling
	gravity_scale = 1
	linear_velocity.y = fall_speed
	is_falling = true
	await get_tree().create_timer(disappear_delay).timeout  # Wait for the delay
	_hide()  # Hide the platform
	await get_tree().create_timer(reappear_delay).timeout  # Wait for the reappear delay
	_reappear()  # Reappear the platform

func _on_body_entered(body):
	if body.name == "Player":
		timer.start()

func _hide():
	visible = false
	collision_layer = 0  # Disable collision to prevent further interaction

func _reappear():
	# Reset platform state
	visible = true
	collision_layer = 1  # Enable collision again
	position = original_position  # Reset position
	linear_velocity = Vector2.ZERO  # Reset velocity
	gravity_scale = 0  # Reset gravity scale
	is_falling = false
