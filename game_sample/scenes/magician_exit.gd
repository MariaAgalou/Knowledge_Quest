extends Area2D

@onready var glow = $Exit
@onready var text = $Label

func _ready():
	glow.visible = false
	text.visible = false
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered():
	glow.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	text.text = "Click to exit!"
	text.visible = true

func _on_mouse_exited():
	glow.visible = false
	text.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if GameState.magician_lair_level_completed:
			SceneManager.change_scene("res://scenes/ending_cutscene.tscn")
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		else:
			var player = get_tree().get_first_node_in_group("player")
			var sfx_player = player.get_node("AudioStreamPlayer")
			sfx_player.stop()
			sfx_player.stream = load("res://scripts/Entering.mp3")
			sfx_player.play()
			SceneManager.change_scene_with_pos("res://scenes/main.tscn")
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
