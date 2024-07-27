extends CharacterBody2D
class_name Player


@onready var health_bar = $"../CanvasLayer/HealthBar"
@onready var dash_timer = $dash_timer
@onready var dash_again_timer = $dash_again_timer
@export var SPEED := 160
@export var JUMP_VELOCITY := -300.0
@export var DASH_SPEED := 500.0
@export var DASH_DURATION := 0.3
@export var max_health := 100
var inventory := {}

const PUSH_FORCE := 150.0
const MIN_PUSH_FORCE := 10.0

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity
var dashing = false
var can_dash = true

func _ready():
	inventory = {"herb": 0, "healing_potion": 0 }
	Checkpointmanager.player = self
	
	

func _health(delta):
	health_bar.value = max_health

#Movement
func _physics_process(delta):
	_health(delta)
	
	# Add the gravity.
	if not is_on_floor() and not dashing:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# handling healing (e) and crafting potion (q)
	if Input.is_action_just_pressed("craft_healing"):
		craft_healing_potion()
	if Input.is_action_just_pressed("use_healing"):
		use_healing_potion()
		
	# Box movement
	if Input.is_action_pressed("move_box"):
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_collider() is RigidBody2D and collision.get_collider().is_in_group("boxbody"):
				var push_force_to_apply = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
				collision.get_collider().apply_central_impulse(Vector2(Input.get_axis("move_right", "move_left") * push_force_to_apply, 0))

	# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash and velocity.x != 0:
		dashing = true
		can_dash = false
		if not is_on_floor():
			velocity.y = 0
		velocity.x = Input.get_axis("left","right") * DASH_SPEED
		dash_timer.start(DASH_DURATION)
		dash_again_timer.start(DASH_DURATION * 2)
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left","right")
	
	if not dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
func _on_dash_timer_timeout():
	dashing = false
	gravity = default_gravity
	velocity.x = 0  # Stop the dash by resetting horizontal velocity

func _on_dash_again_timer_timeout():
	can_dash = true

func take_damage(damage_amount):
	max_health -= damage_amount
	if max_health <= 0:
		die()
		max_health += 100
	
func die():
	Checkpointmanager.respawn_player()
	
func collect_item(item_name: String):
	if inventory.has(item_name):
		inventory[item_name] += 1
	else:
		inventory[item_name] = 1
	print("Collected ", item_name, ", Total: ", inventory[item_name])

func has_items(required_items: Dictionary) -> bool:
	for key in required_items.keys():
		if not inventory.has(key) or inventory[key] < required_items[key]:
			return false
	return true

func craft_healing_potion():
	var required_items = {"herb": 2}
	if has_items(required_items):
		for key in required_items.keys():
			inventory[key] -= required_items[key]
		if not inventory.has("healing_potion"):
			inventory["healing_potion"] = 0
		inventory["healing_potion"] += 1
		print("Crafted healing potion")
	else:
		print("Can't craft healing potion")

func use_healing_potion():
	if inventory["healing_potion"] > 0:
		heal(50)  # Amount to heal
		inventory["healing_potion"] -= 1
		print("Used healing potion")
	else:
		print("Can't use healing potion")

func heal(amount: int):
	max_health += amount
	print("Healed by ", amount, ". Current health: ", max_health)
