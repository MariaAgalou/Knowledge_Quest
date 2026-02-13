extends Control

@onready var image = $ColorRect/TextureRect
@onready var audio = $AudioStreamPlayer
@onready var text_label: RichTextLabel = $ColorRect/TextureRect/RichTextLabel

var cutscene_skipped := false
var is_cutscene_playing := true

var slides = [
	{
		"image": preload("res://cutscene images/Frame 1.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 2.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 3.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a testThis is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a testThis is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a testThis is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a testThis is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a testThis is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test.This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 4.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 5.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 6.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 7.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 8.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 9.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 10.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 11.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 12.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 13.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 14.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 15.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 16.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 17.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 18.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 19.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 20.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 21.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 22.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 23.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 24.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	},
	{
		"image": preload("res://cutscene images/Frame 25.jpg"),
		"audio": preload("res://test.mp3"),
		"text": "This is a test"
	}
]

var current_slide := 0

func _ready():
	play_slide(0)

func _input(event):
	if is_cutscene_playing and event.is_action_pressed("ui_cancel"):
		skip_cutscene()

func play_slide(index: int):
	if index >= slides.size():
		end_cutscene()
		return

	var slide = slides[index]

	image.texture = slide.image
	type_text("[center]"+slide.text+"[/center]")

	audio.stream = slide.audio
	audio.play()

	audio.finished.connect(_on_audio_finished, CONNECT_ONE_SHOT)

func type_text(new_text: String, speed := 0.04) -> void:
	text_label.text = new_text
	text_label.visible_characters = 0

	var total_chars = new_text.length()
	var tween = create_tween()
	#tween.add_to_group("cutscene_tweens")
	
	tween.tween_property(
		text_label,
		"visible_characters",
		total_chars,
		total_chars * speed
	)

func skip_cutscene():
	if cutscene_skipped:
		return

	cutscene_skipped = true
	is_cutscene_playing = false

	# Stop audio
	audio.stop()

	# Instantly finish text
	text_label.visible_characters = -1

	# Kill tweens
	get_tree().call_group("cutscene_tweens", "kill")

	# Disconnect signals safely
	if audio.finished.is_connected(_on_audio_finished):
		audio.finished.disconnect(_on_audio_finished)

	end_cutscene()

func _on_audio_finished():
	if cutscene_skipped:
		return
	
	current_slide += 1
	play_slide(current_slide)

func end_cutscene():
	SceneManager.change_scene("res://main.tscn")
