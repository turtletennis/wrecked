extends Area3D

class_name Air_Pocket

@export var t:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(GameController.on_airpocket_enter)
	self.body_exited.connect(GameController.on_air_pocket_exit)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
