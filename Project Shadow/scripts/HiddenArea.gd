extends Node2D

@onready var hidden_sprite = $Sprite2D
@onready var detection_area = $Area2D

func _ready():
	hidden_sprite.visible = true
	
func _on_area_2d_body_entered(body):
	if body is Player:  # Assuming your player script has class_name Player
		hidden_sprite.visible = false


func _on_area_2d_body_exited(body):
	if body is Player:  # Assuming your player script has class_name Player
		hidden_sprite.visible = true
