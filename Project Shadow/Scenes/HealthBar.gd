extends ProgressBar
@export var label : Label
#var player : Player
@onready var player = $"../../Player"


func _ready():
	pass

func update():
	pass

func _physics_process(delta):
	if player:
		label.text = "HP: " + str(player.max_health)
	else:
		print("not working")
	
