extends Node

var currentCheckPoint : Checkpoint
var player : Player
func respawn_player():
	if currentCheckPoint != null:
		player.position = currentCheckPoint.global_position
