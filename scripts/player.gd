extends CharacterBody3D

class_name Player

@export var speed:float = 10
@export var rotationSpeed:float = 25
@export var animationPlayer:AnimationPlayer
@export var swimAnimationName = "swim"
var deadZone:float = 0.1
var input_dir:Vector2


@export var blindness:float = 0.0
@export var blindness_rate:float = 0.1
@export var blindness_drain_rate:float = 5.0
@export var push_decay_amount:float = 5
var push_total_force:Vector3 = Vector3.ZERO
func _ready() -> void:
	animationPlayer.play(swimAnimationName)
	animationPlayer.pause()
func _process(delta: float) -> void:
	input_dir = Input.get_vector("left","right","up","down")

func _physics_process(delta: float) -> void:
	
	velocity.x = input_dir.x * speed
	velocity.y = input_dir.y * speed * -1
	velocity.z = 0
	velocity += push_total_force
	push_total_force = push_total_force.lerp(Vector3.ZERO,push_decay_amount*delta)
	if(input_dir.length_squared() > deadZone):
		var desiredAngle =3*PI/2 - input_dir.angle()
		var angle = lerp_angle(global_rotation.z,desiredAngle,rotationSpeed*delta)
		rotation =Vector3(rotation.x,rotation.y,angle)
		if(!animationPlayer.is_playing()):
			animationPlayer.play(swimAnimationName)
	else:
		animationPlayer.pause()
	global_position.z = 0
	move_and_slide()

	# mask blindness
	if !GameController.player_in_air and position.y < 0:
		blindness += blindness_rate
	
	if Input.is_physical_key_pressed(KEY_E):
		if GameController.player_in_air or position.y > 0:
			blindness -= blindness_drain_rate
		else:
			blindness += blindness_drain_rate

	blindness = clampf(blindness, 0.0, 100.0)

	position.y = clampf(position.y, -1000.0, 1.0)

func push(amount:Vector3):
	push_total_force += amount