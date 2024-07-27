extends CharacterBody2D

@export var speed := 2000.0
@export var direction = 1
var player_chase = false
var player :Player
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight

@onready var detection_area = $Detection_area


	
func _physics_process(delta):
	if player_chase and player:
		direction = (player.global_position.x - global_position.x) * speed
		velocity.x = direction
	else:
		velocity.x = direction * speed * delta

		if ray_cast_left.is_colliding():
			direction = 1
		if ray_cast_right.is_colliding():
			direction = -1
			

	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true
	

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false

func _on_area_2d_area_entered(area): # hitbox
	if area.get_parent() is Player:
		area.get_parent().take_damage(25)
