extends Node2D

class_name Herb
@export var item_name: String = "herb"

func _on_area_body_entered(body):
	if body is Player:
		body.collect_item(item_name)
		print("herb colltected")
		queue_free()
	
