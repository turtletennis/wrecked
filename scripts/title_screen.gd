extends CenterContainer
@export var first_level_path:String
@onready var start_button:Button = %StartButton
func _ready() -> void:
	start_button.grab_focus()
func start_game() ->void :
	get_tree().change_scene_to_file(first_level_path)