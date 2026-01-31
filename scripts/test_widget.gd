extends Polygon2D

class_name Test_Widget

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_red = (1 - (player.blindness / 100))
	self.color.g = new_red
	self.color.b = new_red

