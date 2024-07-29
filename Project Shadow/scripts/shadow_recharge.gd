extends ProgressBar
class_name Recharge

var minimalRecharge = 10
var maximalRecharge = 100
var recharge = 0
@onready var recharge_timer = $"../recharge"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = 100
	recharge = self.value  # Initialize recharge with the current value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ability_shadow") and recharge_timer.is_stopped():
		self.value = 0
		recharge = minimalRecharge  # Set initial recharge value
		recharge_timer.start()
		print("start recharge")

func _on_recharge_timeout():
	if recharge < maximalRecharge:
		recharge += minimalRecharge
		if recharge > maximalRecharge:
			recharge = maximalRecharge
		self.value = recharge
		recharge_timer.start()  # Restart the timer for continuous recharging
	else:
		recharge_timer.stop()  # Stop the timer if the maximalRecharge is reached
