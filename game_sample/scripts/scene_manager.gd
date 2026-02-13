extends Node

var player_pos = null
var temp_pos

func change_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
	
func save_playr_pos(coords: Vector2):
	temp_pos = coords

func change_scene_with_pos(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
	player_pos = temp_pos
