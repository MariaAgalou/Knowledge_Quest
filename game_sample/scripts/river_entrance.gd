extends Area2D

@onready var glow = $Entrance
@onready var text = $Label
@onready var level = $Level
@onready var text2 = $Label2
@onready var level2 = $Level2

func _ready():
	glow.visible = false
	text.visible = false
	level.visible = false
	text2.visible = false
	level2.visible = false
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered():
	glow.visible = true
	level.text = "Level 6: The River"
	level.visible = true
	level2.text = "Level 6: The River"
	level2.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if GameState.orchard_level_completed:
		text.text = "Click to enter!"
		text.visible = true
		text2.text = "Click to enter!"
		text2.visible = true
	else:
		text.text = "Complete level 5: The Orchard first!"
		text2.text = "Complete level 5: The Orchard first!"
		text.visible = true
		text2.visible = true

func _on_mouse_exited():
	glow.visible = false
	text.visible = false
	level.visible = false
	text2.visible = false
	level2.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport, event, _shape_idx):
	if GameState.orchard_level_completed:
		if event is InputEventMouseButton and event.pressed:
			var player = get_tree().get_first_node_in_group("player")
			SceneManager.save_playr_pos(player.global_position)
			var sfx_player = player.get_node("AudioStreamPlayer")
			sfx_player.stop()
			sfx_player.stream = load("res://scripts/Entering.mp3")
			sfx_player.play()
			await get_tree().create_timer(4.0).timeout
			SceneManager.change_scene("res://scenes/insideriver.tscn")
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
