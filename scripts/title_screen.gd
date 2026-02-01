extends CenterContainer
@export var first_level_path:String

func start_game() ->void :
	get_tree().change_scene_to_file(first_level_path)