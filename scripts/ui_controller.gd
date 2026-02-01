extends Control
class_name UIController

@export var game_over_container:Container
@export var game_over_reason_label:Label
@export var win_container:Container
@export var next_scene_path:String=""
@export var game_over_button:Button
@export var win_button:Button
func _ready() -> void:
	game_over_container.visible = false
	win_container.visible = false
	GameController.ui = self
	print_debug(GameController.ui.name)

func game_over(reason:String) -> void:
	game_over_container.visible = true
	game_over_reason_label.text = reason
	game_over_button.grab_focus()

func try_again_pressed() -> void:
	GameController.try_again()

func next_level_button_pressed() -> void:
	GameController.next_level(next_scene_path)

func win() -> void:
	win_container.visible = true
	win_button.grab_focus()
	
