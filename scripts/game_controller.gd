extends Node3D

@export var player_in_air:bool = false

func _on_shipwreck_ship_reached_by_player() -> void:
	print_debug("Level complete!")

func on_airpocket_enter(body: Node3D):
	player_in_air = true

func on_air_pocket_exit(body: Node3D):
	player_in_air = false

func game_over() -> void:
	print_debug("Game over!")