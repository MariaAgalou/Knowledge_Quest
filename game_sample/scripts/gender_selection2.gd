extends Button

func _on_pressed() -> void:
	GameState.gender_male = false
	SceneManager.change_scene("res://scenes/main_menu.tscn")
