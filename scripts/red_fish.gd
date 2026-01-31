extends Node3D

class_name RedFish

enum State {WANDERING, CHASING}

@export var state: State = State.WANDERING

@export var wanderingSpeed: float = 1.0
@export var targetNodes: Array[Node3D]

var nextTarget: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if targetNodes.size() < 1:
		push_error("Enemy target Node array is empty!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state == State.WANDERING:
		if (position.distance_squared_to(targetNodes[nextTarget].position) <= 0.01): # 0.1^2
			nextTarget += 1
			if nextTarget > (targetNodes.size() - 1):
				nextTarget = 0
		var target = targetNodes[nextTarget].position
		var nextOffset = (target - position).normalized() * wanderingSpeed * delta
		position += nextOffset
	else:
		push_error("Enemy state unimplemented! State: {}", state)
	pass
