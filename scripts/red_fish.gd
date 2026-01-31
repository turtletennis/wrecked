extends Node3D

class_name RedFish

enum State {WANDERING, CHASING}

@export var state: State = State.WANDERING

@export var acceleration: float = 1.0

@export_group("Wandering Params")
@export var wanderingSpeed: float = 1.0
@export var targetNodes: Array[Node3D]

@export_group("Chase Params")
@export var player: Player
@export var playerDetectionRadius: float = 5.0
@export var playerIgnoreRadius: float = 10.0
@export var playerChaseSpeed: float = 3.0

var nextTarget: int = 0

var velocity: Vector3


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
		go_towards_target(target, wanderingSpeed, delta)
		if check_for_player_nearby(playerDetectionRadius):
			change_state(State.CHASING)
	elif state == State.CHASING:
		go_towards_target(player.position, playerChaseSpeed, delta)
		if !check_for_player_nearby(playerIgnoreRadius):
			change_state(State.WANDERING)
	else:
		push_error("Enemy state unimplemented! State: ", State.keys()[state])

func change_state(newState: State):
	print_debug("Changing Enemy state from ", State.keys()[state], " to ", State.keys()[newState])
	state = newState

func go_towards_target(target:Vector3, speed: float, delta: float):
	var desired_velocity = (target - position).normalized() * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	position += velocity * delta

func check_for_player_nearby(detectionRadius):
	return player.position.distance_to(position) <= detectionRadius
