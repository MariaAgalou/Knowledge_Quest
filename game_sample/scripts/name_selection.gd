extends Control

@onready var player_name = $Panel/VBoxContainer/Name
@onready var label = $Panel/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	if player_name.text != "":
		GameState.player_name = player_name.text
		SceneManager.change_scene("res://scenes/gender_choice.tscn")
	else:
		label.text = "Please pick a name!"
