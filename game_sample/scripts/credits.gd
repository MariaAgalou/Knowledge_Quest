extends Control

@onready var credits_label: Label = $VBoxContainer/ScrollContainer/CreditsLabel
@onready var scroll: ScrollContainer = $VBoxContainer/ScrollContainer
@export var scroll_speed := 30.0
var max_scroll := 0.0
var scroll_pos := 0.0
func _ready():
	load_credits()
	await get_tree().process_frame

func _process(delta):
	scroll_pos += scroll_speed * delta
	scroll.scroll_vertical = int(scroll_pos)

func load_credits():
	var file: FileAccess
	var ourCredits: FileAccess
	var empty_space = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	if GameState.gender_male:
		file = FileAccess.open(
			"res://characters' sprite/man/sheet-credits.txt",
			FileAccess.READ
		)
	else:
		file = FileAccess.open(
			"res://characters' sprite/woman/sheet-credits.txt",
			FileAccess.READ
		)
	ourCredits = FileAccess.open(
			"res://data/credits.txt",
			FileAccess.READ
		)
	if file:
		credits_label.text = empty_space + ourCredits.get_as_text() + file.get_as_text()
		file.close()
	else:
		credits_label.text = "Credits file not found."
