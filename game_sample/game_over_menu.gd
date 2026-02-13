extends CanvasLayer

func _ready():
	visible = false

func open():
	visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	GameState.reset_game()
	SceneManager.change_scene("res://main.tscn")
	visible = false

func _on_button_2_pressed() -> void:
	#todo maybe add a warning
	get_tree().quit()
