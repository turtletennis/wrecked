extends CharacterBody3D

class_name Player

@export var speed:float = 10
@export var rotationSpeed:float = 25
var deadZone:float = 0.1
var input_dir:Vector2

func _process(delta: float) -> void:
	input_dir = Input.get_vector("left","right","up","down")

func _physics_process(delta: float) -> void:
	velocity.x = input_dir.x * speed
	velocity.y = input_dir.y * speed * -1
	velocity.z = 0
	if(input_dir.length_squared() > deadZone):
		var desiredAngle =PI/2 - input_dir.angle()
		var angle = lerp_angle(global_rotation.z,desiredAngle,rotationSpeed*delta)
		rotation =Vector3(rotation.x,rotation.y,angle)
	move_and_slide()