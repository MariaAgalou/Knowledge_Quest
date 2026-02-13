extends Area2D

@onready var glow = $Entrance
@onready var text = $Label

func _ready():
	glow.visible = false
	text.visible = false
	text.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_mouse_entered():
	if GameState.castle_level_completed:
		glow.visible = true
		text.text = "Click to head Inside the Castle!"
		text.visible = true
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		text.text = "You have to complete the previous level in order to play"
		text.visible = true

func _on_mouse_exited():
	glow.visible = false
	text.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport, event, _shape_idx):
	if GameState.lives <= 0:
		return
	if event is InputEventMouseButton and event.pressed:
		SceneManager.change_scene("res://insidecastle.tscn")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
