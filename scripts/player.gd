extends CharacterBody3D

class_name Player

@export var speed:float = 10
@export var rotationSpeed:float = 25
@export var animationPlayer:AnimationPlayer
@export var swimAnimationName = "swim"
var deadZone:float = 0.1
var input_dir:Vector2

var yellowFishAttached: Array[YellowFish] = []
var yellowFishShake: int = 0
var yellowFishUpForce: float = 0.0

var player_surfaced = false

@export var blindness:float = 0.0
@export var blindness_rate:float = 0.1
@export var blindness_drain_rate:float = 5.0
@export var push_decay_amount:float = 5
var push_total_force:Vector3 = Vector3.ZERO
func _ready() -> void:
	animationPlayer.play(swimAnimationName)
	animationPlayer.pause()
	add_to_group("player")

func _process(delta: float) -> void:
	input_dir = Input.get_vector("left","right","up","down")
	if yellowFishAttached.size() > 0:
		if Input.is_action_just_pressed("shake"):
			yellowFishShake += 1
		if yellowFishShake >= 5:
			detach_yellow_fish()


func _physics_process(delta: float) -> void:

	var move_speed = speed
	if Input.is_physical_key_pressed(KEY_SHIFT):
		move_speed = speed * 5
		get_node("CollisionShape3D").set_deferred("disabled", true)
		blindness = 0.0
	else:
		get_node("CollisionShape3D").set_deferred("disabled", false)
	
	velocity.x = input_dir.x * move_speed
	velocity.y = input_dir.y * move_speed * -1
	velocity.z = 0
	velocity += push_total_force
	push_total_force = push_total_force.slerp(Vector3.ZERO,push_decay_amount*delta)
	if(input_dir.length_squared() > deadZone):
		var desiredAngle =3*PI/2 - input_dir.angle()
		var angle = lerp_angle(global_rotation.z,desiredAngle,rotationSpeed*delta)
		rotation =Vector3(rotation.x,rotation.y,angle)
		if(!animationPlayer.is_playing()):
			animationPlayer.play(swimAnimationName)
	else:
		animationPlayer.pause()
	global_position.z = 0

	yellowFishUpForce = lerpf(yellowFishUpForce, (yellowFishAttached.size() * 5), 0.05)
	velocity.y += yellowFishUpForce

	move_and_slide()

	if global_position.y > 0 and !player_surfaced:
		print_debug("Surfaced!")
		GameController.player_in_air = true
		player_surfaced = true
		while yellowFishAttached.size() > 0:
			detach_yellow_fish()
	elif global_position.y < 0 and player_surfaced:
		print_debug("Going down!")
		GameController.player_in_air = false
		player_surfaced = false

	# mask blindness
	if !GameController.player_in_air:
		blindness += blindness_rate
	else:
		blindness -= blindness_rate * 0.2
	
	if Input.is_action_pressed("mask"):
		if GameController.player_in_air:
			blindness -= blindness_drain_rate
		else:
			blindness += blindness_drain_rate

	blindness = clampf(blindness, 0.0, 100.0)

	global_position.y = clampf(global_position.y, -1000.0, 1.0)

func push(amount:Vector3):
	push_total_force += amount

func detach_yellow_fish():
	yellowFishAttached[-1].shake_off()
	yellowFishAttached.pop_back()
	yellowFishShake = 0