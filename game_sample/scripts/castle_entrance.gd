extends Area2D

@onready var glow = $Entrance
@onready var text = $Label
@onready var level = $Level

func _ready():
	glow.visible = false
	text.visible = false
	level.visible = false
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered():
	glow.visible = true
	text.text = "Click to enter!"
	level.text = "Level 1: The Castle"
	text.visible = true
	level.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	glow.visible = false
	text.visible = false
	level.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var player = get_tree().get_first_node_in_group("player")
		SceneManager.save_playr_pos(player.global_position)
		var sfx_player = player.get_node("AudioStreamPlayer")
		sfx_player.stop()
		sfx_player.stream = load("res://scripts/Entering.mp3")
		sfx_player.play()
		await get_tree().create_timer(4.0).timeout
		SceneManager.change_scene("res://scenes/insidecastle.tscn")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
