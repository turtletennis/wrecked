extends StaticBody3D

class_name Shipwreck

signal ship_reached_by_player()

func _on_player_interact_area_body_entered(body: Node3D) -> void:
	if(body is Player):
		GameController.win()
		ship_reached_by_player.emit()
