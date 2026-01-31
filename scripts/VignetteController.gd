extends ColorRect

class_name UIController

@onready var mat := material as ShaderMaterial

@export var player: Player
@export var min_radius := 0.2  # how dark it gets at 0 HP


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player == null:
		push_error("Player reference not set!")
		return
	
	var blindness_ratio = clamp(player.blindness / 100.0, 0.0, 1.0)
	blindness_ratio = 1.0 - pow(blindness_ratio, 2.0) # FPS-style curve

	# Smooth curve feels nicer than linear
	var radius = lerp(min_radius, 1.0, blindness_ratio)

	mat.set_shader_parameter("visible_radius", radius)
