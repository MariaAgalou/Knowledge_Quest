extends CanvasLayer

@onready var button:Button = $Panel/Button
@onready var how_to_play:RichTextLabel = $Panel/Instructions
@export var default_style: StyleBox
@export var default_grey_style: StyleBox

func _ready() -> void:
	hide()
	apply_styles()
	var file: FileAccess
	file = FileAccess.open(
			"res://data/how_to_play.txt",
			FileAccess.READ
		)
	if file:
		how_to_play.text = "[center]" + file.get_as_text() + "[/center]"
		file.close()
	else:
		how_to_play.text = "Credits file not found."

func apply_styles():
	button.add_theme_stylebox_override("normal", default_style)
	button.add_theme_stylebox_override("hover", default_grey_style)
	button.add_theme_stylebox_override("pressed", default_style)
	button.add_theme_stylebox_override("disabled", default_style)

func _on_button_2_pressed() -> void:
	HowToPlay.hide()
