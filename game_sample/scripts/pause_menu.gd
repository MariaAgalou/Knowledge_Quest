extends CanvasLayer

@onready var warning: Panel = $Panel/Warning

@export var default_style: StyleBox
@export var default_grey_style: StyleBox
@onready var buttons = [
	$Panel/Button,
	$Panel/Button2,
	$Panel/Button3,
	$Panel/Button4
]

func _ready():
	visible = false
	warning.hide()
	apply_styles()

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

func _on_button_pressed() -> void:
	close()

func apply_styles():
	for b in buttons:
		b.add_theme_stylebox_override("normal", default_style)
		b.add_theme_stylebox_override("hover", default_grey_style)
		b.add_theme_stylebox_override("pressed", default_style)
		b.add_theme_stylebox_override("disabled", default_style)

func _on_button_2_pressed() -> void:
	#todo maybe add a warning
	get_tree().quit()

func _on_button_3_pressed() -> void:
	HowToPlay.show()
	
func _on_button_4_pressed() -> void:
	if GameState.stats.is_empty():
		warning.show()
		await get_tree().create_timer(6.0).timeout
		warning.hide()
	else:
		StatisticsPopUp.load_stats()
		StatisticsPopUp.show()
