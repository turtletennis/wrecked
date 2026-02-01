extends Control
class_name UIController

@export var game_over_container:Container
@export var game_over_reason_label:Label

func _ready() -> void:
	game_over_container.visible = false
	GameController.ui = self
	print_debug(GameController.ui.name)

func game_over(reason:String) -> void:
	game_over_container.visible = true
	game_over_reason_label.text = reason

func try_again_pressed() -> void:
	GameController.try_again()