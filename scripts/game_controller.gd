extends Node3D

@export var player_in_air:bool = false

func _on_shipwreck_ship_reached_by_player() -> void:
	print_debug("Level complete!")
