extends CharacterBody2D
class_name Player

@export var SPEED := 160
@export var JUMP_VELOCITY := -300.0
@export var DASH_SPEED := 500.0
@export var DASH_DURATION := 0.3

const PUSH_FORCE := 150.0
const MIN_PUSH_FORCE := 10.0

@onready var dash_timer = $Timer

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity
var dashing = false

func _ready():
	Checkpointmanager.player = self
	dash_timer.connect("timeout", Callable(self, "_on_dash_timeout"))

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor() and not dashing:
		velocity.y += gravity * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var direction = Input.get_axis("left", "right")
	

	# Handle dashing
	if Input.is_action_just_pressed("dash") and not dashing and direction != 0:
		gravity = 0
		dashing = true
		dash_timer.start(DASH_DURATION)
		velocity.x = DASH_SPEED if direction > 0 else -DASH_SPEED

	# Handle movement only if not dashing
	if not dashing:
		velocity.x = direction * SPEED

	# Move and slide
	move_and_slide()
	
	if Input.is_action_pressed("move_box"):
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_collider() is RigidBody2D and collision.get_collider().is_in_group("boxbody"):
				var push_force_to_apply = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
				collision.get_collider().apply_central_impulse(-collision.get_normal() * push_force_to_apply)
		

func _on_dash_timeout():
	gravity = default_gravity
	dashing = false

func die():
	Checkpointmanager.respawn_player()


