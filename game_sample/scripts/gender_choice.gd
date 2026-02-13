extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_male_pressed() -> void:
	GameState.gender_male = true
	SceneManager.change_scene("res://scenes/main_menu.tscn")

func _on_female_pressed() -> void:
	GameState.gender_male = false
	SceneManager.change_scene("res://scenes/main_menu.tscn")

func _on_teacher_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
