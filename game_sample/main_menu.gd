extends Control

@export var default_style: StyleBox
@export var default_grey_style: StyleBox

@onready var buttons = [
	$HBoxContainer/VBoxContainer/Button,
	$HBoxContainer/VBoxContainer/Button4,
	$HBoxContainer/VBoxContainer2/Button2,
	$HBoxContainer/VBoxContainer2/Button3
]

func _ready() -> void:
	apply_styles()

func apply_styles():
	for b in buttons:
		b.add_theme_stylebox_override("normal", default_style)
		b.add_theme_stylebox_override("hover", default_grey_style)
		b.add_theme_stylebox_override("pressed", default_style)
		b.add_theme_stylebox_override("disabled", default_style)
