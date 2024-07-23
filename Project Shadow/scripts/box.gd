extends RigidBody2D

@export var move_speed = 100.0  # Speed at which the box moves when the button is pressed

@onready var area = $Area2D

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	set_physics_process(false)  # Disable physics process until needed
	angular_velocity = 0

var player_in_area = false

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		set_physics_process(true)

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		set_physics_process(false)

func _physics_process(_delta):
	if player_in_area and Input.is_action_pressed("move_box"):
		if Input.is_action_pressed("right"):
			linear_velocity.x = move_speed
		elif Input.is_action_pressed("left"):
			linear_velocity.x = -move_speed
		else:
			linear_velocity.x = 0
	else:
		linear_velocity.x = 0

