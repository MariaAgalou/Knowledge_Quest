extends Button

func _on_pressed() -> void:
	GameState.gender_male = true
	SceneManager.change_scene("res://main_menu.tscn")
