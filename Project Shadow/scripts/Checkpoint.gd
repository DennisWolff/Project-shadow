extends Node2D
class_name Checkpoint

@export var spawnpoint := false

var activate := false

func Active():
	Checkpointmanager.currentCheckPoint = self
	activate = true
	print("coliding")
	
func _on_area_2d_area_entered(area):
	
	if area.get_parent() is Player && !activate:
		Active()

   
