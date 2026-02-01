extends CharacterBody3D

class_name Fish

enum State {WANDERING, CHASING, ATTACKING, COOLDOWN}

@export var state: State = State.WANDERING

@export_group("Tuning params")
@export var acceleration: float = 6.0
@export var turn_rate: float = 3.0
@export var steering_bias:float = 0.65
@export var lateral_drag:float = 5.0
@export var pushing_power: float = 5.0

@export_group("Wandering Params")
@export var wanderingSpeed: float = 1.0
@export var targetNodes: Array[Node3D]

@export_group("Chase Params")
@onready var player: Player= %Player
@export var playerDetectionRadius: float = 5.0
@export var playerIgnoreRadius: float = 10.0
@export var playerChaseSpeed: float = 3.0

var nextTarget: int = 0


var forward_dir: Vector3

@export_group("Fish wiggle")
@export var wiggle_amplitude := 0.35 # sideways strength
@export var wiggle_frequency := 7.0 # tail speed
@export var wiggle_speed_scale := 0.3 # more wiggle when moving faster

var wiggle_time := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if targetNodes.size() < 1:
		push_error("Enemy target Node array is empty!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state_machine_tick(delta)

func state_machine_tick(delta: float) -> void:
	pass

func change_state(newState: State):
	print_debug("Changing ", name, " state from ", State.keys()[state], " to ", State.keys()[newState])
	state = newState

func go_towards_target(target: Vector3, speed: float, delta: float) -> void:
	var to_target := target - global_position
	to_target.z = 0.0
	if to_target.length_squared() < 0.0001:
		return

	var desired_dir := to_target.normalized()

	# --- Compute steering direction ---
	var velocity_dir := forward_dir
	if velocity.length_squared() > 0.0001:
		velocity_dir = velocity.normalized()

	var steering_dir := velocity_dir.lerp(desired_dir, steering_bias).normalized()

	# --- Turn ONCE toward steering direction ---
	forward_dir = forward_dir.slerp(steering_dir, turn_rate * delta)
	forward_dir.z = 0.0
	forward_dir = forward_dir.normalized()

	# --- Accelerate along forward ---
	var desired_velocity := forward_dir * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	velocity.z = 0.0

	# --- Lateral drag (kills ice) ---
	var lateral := velocity - velocity.project(forward_dir)
	velocity -= lateral * lateral_drag * delta

	# --- Fish wiggle ---
	wiggle_time += delta

	# Sideways relative to facing (planar)
	var side := forward_dir.cross(Vector3.UP).cross(forward_dir).normalized()

	# Speed-based strength (0 when stopped)
	var speed_factor := clampf(velocity.length() * wiggle_speed_scale, 0.0, 1.0)

	# Sinusoidal lateral offset
	var wiggle := side * sin(wiggle_time * wiggle_frequency) * wiggle_amplitude * speed_factor

	velocity += wiggle
	velocity.z = 0.0


	# --- Move ---
	var collision = move_and_collide(velocity * delta)
	if (collision):
		var collider = collision.get_collider()
		if (collider is Player):
			var player = collider as Player
			on_player_hit()

	# --- Face forward ---
	look_at(global_position + forward_dir, Vector3.UP)

func check_for_player_nearby(detectionRadius):
	if GameController.player_in_air: return false
	return player.global_position.distance_to(global_position) <= detectionRadius

func on_player_hit():
	pass
