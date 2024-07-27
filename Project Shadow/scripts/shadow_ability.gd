extends StaticBody2D
@export var timer : Timer
@export var ability_cooldown : Timer
@export var transparent: Color = Color(1, 1, 1, 0.5)
@export var reset: Color = Color(1, 1, 1, 1)



# Called when the node enters the scene tree for the first time.
func _ready():
	stop_timer()
	ability_cooldown.stop()
	collision_layer = 1  
	collision_mask = 1   
	

func _process(delta):
	
	if Input.is_action_just_pressed("ability_shadow") and ability_cooldown.is_stopped():
		if timer.is_stopped():
			timer.start(3)
			collision_layer = 2  
			collision_mask = 2  
			ability_cooldown.start(10)
	


func stop_timer():
	if timer.is_stopped():
		print("Timer is already stopped.")
	else:
		timer.stop()

func _on_timer_timeout():
	print("Timer stopped")
	stop_timer()
	#collision_layer = 1  
	#collision_mask = 1 
	

func _on_abillity_cooldown_timeout():
	print("cooldown stopped")
	ability_cooldown.stop()
	


func _on_area_2d_body_exited(body):
	if body.is_in_group("Colliding"):
		$Sprite2D.modulate = reset
		collision_layer = 1  
		collision_mask = 1 
		print("Exit")
		



func _on_area_2d_body_entered(body):
	if body.is_in_group("Colliding"):
		$Sprite2D.modulate = transparent
		print("test")
	print("enter")
	


