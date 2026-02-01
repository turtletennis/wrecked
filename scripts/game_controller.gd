extends Node3D

@export var player_in_air:bool = false
var ui:UIController


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

func try_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()