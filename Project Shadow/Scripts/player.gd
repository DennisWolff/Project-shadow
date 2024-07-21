extends CharacterBody2D

@export var dash_timer : Timer
@export var dash_again_timer : Timer

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0  
var dashing = false
var can_dash = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not dashing:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle dash
	if Input.is_action_just_pressed("abillity_dash") and can_dash:
		dashing = true
		can_dash = false
		if not is_on_floor():
			velocity.y = 0
		velocity.x = Input.get_axis("left", "right") * DASH_SPEED
		dash_timer.start()
		dash_again_timer.start()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if not dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _on_dash_timer_timeout():
	dashing = false
	gravity = default_gravity
	velocity.x = 0  # Stop the dash by resetting horizontal velocity

func _on_dash_again_timeout():
	can_dash = true
