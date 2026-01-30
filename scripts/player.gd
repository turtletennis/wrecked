extends CharacterBody3D
@export var speed:float = 10
var input_dir:Vector2

func _process(delta: float) -> void:
    input_dir = Input.get_vector("left","right","up","down")

func _physics_process(delta: float) -> void:
    velocity.x = input_dir.x * speed
    velocity.y = input_dir.y * speed * -1
    velocity.z = 0
    move_and_slide()