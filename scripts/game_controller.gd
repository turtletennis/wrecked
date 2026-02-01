extends Node3D

@export var player_in_air:bool = false
var ui:UIController

@export var fog_min_density := 0.02
@export var fog_max_density := 0.10
@export var fog_depth_max := 100.0 # how deep until max fog
@export var fog_lerp_speed := 3.0  # smoothing


var env: Environment

func _ready():
	env = get_node("/root/Level/World_Environment").environment

func _process(delta: float) -> void:
	if not env:
		return

	var target_density := 0.0

	if not player_in_air:
		var player := get_tree().get_first_node_in_group("player")
		if player:
			var depth := clampf(-player.global_position.y, 0.0, fog_depth_max)
			var t := depth / fog_depth_max
			t = t * t * (3.0 - 2.0 * t) # smoothstep
			target_density = lerp(fog_min_density, fog_max_density, t)

	env.volumetric_fog_density = lerp(
		env.volumetric_fog_density,
		target_density,
		fog_lerp_speed * delta
	)

	
func _on_shipwreck_ship_reached_by_player() -> void:
	print_debug("Level complete!")

func on_airpocket_enter(body: Node3D):
	player_in_air = true

func on_air_pocket_exit(body: Node3D):
	player_in_air = false

func game_over(reason:String) -> void:
	print_debug("Game over!")
	get_tree().paused = true
	ui.game_over(reason)

func win() -> void:
	get_tree().paused = true
	ui.win()
func next_level(levelPath:String)-> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(levelPath)

func try_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
