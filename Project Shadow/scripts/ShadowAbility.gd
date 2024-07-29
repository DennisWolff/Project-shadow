extends StaticBody2D
@export var timer : Timer
@export var ability_cooldown : Timer
@export var transparent: Color = Color(1, 1, 1, 0.5)
@export var reset: Color = Color(1, 1, 1, 1)
@onready var tile_map: TileMap = $Secret
@onready var recharge : Recharge


# Called when the node enters the scene tree for the first time.
func _ready():
	stop_timer()
	ability_cooldown.stop()
	tile_map.tile_set.set_physics_layer_collision_layer(0,1)
	tile_map.tile_set.set_physics_layer_collision_mask(0,1)

func _process(delta):
	if Input.is_action_just_pressed("ability_shadow") and ability_cooldown.is_stopped():
		if timer.is_stopped():
			timer.start(3)
			tile_map.tile_set.set_physics_layer_collision_layer(0,8)
			tile_map.tile_set.set_physics_layer_collision_mask(0,8)
			ability_cooldown.start(10)
			print("start cooldown")
	
func stop_timer():
	if timer.is_stopped():
		print("Timer is already stopped.")
	else:
		timer.stop()

func _on_area_2d_body_exited(body):
	print("Exit")
	if body.is_in_group("Colliding"):
		tile_map.modulate = reset
		tile_map.tile_set.set_physics_layer_collision_layer(0,1)
		tile_map.tile_set.set_physics_layer_collision_mask(0,1)

func _on_area_2d_body_entered(body):
	print("enter")
	if body.is_in_group("Colliding"):
		tile_map.modulate = transparent
		print("test")
	
func _on_timer_timeout():
	print("Timer stopped")
	stop_timer()
	#collision_layer = 1  
	#collision_mask = 1 

func _on_ability_cooldown_timeout():
	print("cooldown stopped")
	ability_cooldown.stop()
