extends Node2D

@export var speed = 160.0
var current_speed = 0.0

var original_position: Vector2

func _ready():
	original_position = position
	
func _physics_process(delta):
	position.y += current_speed * delta
	
func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()


func _on_player_detect_area_entered(area):
	if area.get_parent() is Player:
		fall()
		
func fall():
	await get_tree().create_timer(1).timeout
	current_speed = speed 
	await get_tree().create_timer(5).timeout
	reset_spike()

func reset_spike():
	current_speed = 0.0
	position = original_position
	
