extends Control

@onready var image = $ColorRect/TextureRect
@onready var audio = $AudioStreamPlayer
@onready var text_label: RichTextLabel = $ColorRect/TextureRect/RichTextLabel

var cutscene_skipped := false
var is_cutscene_playing := true

var slides = [
	{
		"image": preload("res://cutscene images/Frame 1.jpg"),
		"audio": preload("res://cutscene images/opening_slide_1.mp3"),
		"text": "In the land of Numeria, in a castle high up in the mountains, a wise and kind king lived peacefully with his wife and kids."
	},
	{
		"image": preload("res://cutscene images/Frame 2.jpg"),
		"audio": preload("res://cutscene images/opening_slide_2.mp3"),
		"text": "His name was Arithmos and he was known for ruling his kingdom with wisdom, justice and strength."
	},
	{
		"image": preload("res://cutscene images/Frame 3.jpg"),
		"audio": preload("res://cutscene images/opening_slide_3.mp3"),
		"text": "He was a good king, loved by his people and able to maintain the balance inside his kingdom and ensure that all who lived there thrived in harmony."
	},
	{
		"image": preload("res://cutscene images/Frame 3-5.jpg"),
		"audio": preload("res://cutscene images/opening_slide_4.mp3"),
		"text": "The heart of his kingdom was a magical artifact, known as the Scepter of Knowledge and Wisdom. It was said to hold the knowledge and power of generations, glowing brighter with each act of courage and wisdom shown by its wielder."
	},
	{
		"image": preload("res://cutscene images/Frame 4.jpg"),
		"audio": preload("res://cutscene images/opening_slide_5.mp3"),
		"text": "One fateful night though, everything changed and the peace in the kingdom of Numeria shattered, as three shadowy figures crept into the castle. Those shadowy figures belonged to the Creatures of Chaos, a sinister group of evil and eerie creatures that were brought to life by the evil magician named Enigmor."
	},
	{
		"image": preload("res://cutscene images/Frame 5.jpg"),
		"audio": preload("res://cutscene images/opening_slide_6.mp3"),
		"text": "Enigmor was jealous of the power that king Arithmos possessed, so he put on an awful plan: he brought to life this group of mischievous creatures, monsters born from his own malice, for only one purpose: destroy king Arithmos."
	},
	{
		"image1": preload("res://cutscene images/Frame 6.jpg"),
		"image2": preload("res://cutscene images/Frame 7.jpg"),
		"audio": preload("res://cutscene images/opening_slide_7.mp3"),
		"text": "He ordered them to invade the castle of king Arithmos and steal the sacred artifact. After stealing Arithmos’ valuable scepter, they shattered it into countless pieces and scattered them across the land of Numeria."
	},
	{
		"image": preload("res://cutscene images/Frame 8.jpg"),
		"audio": preload("res://cutscene images/opening_slide_8.mp3"),
		"text": "To ensure that the scepter will remain broken forever, Enigmor commanded the Creatures of Chaos to guard each shard of the broken scepter, by hiding them in challenges that only the cleverest could solve."
	},
	{
		"image": preload("res://cutscene images/Frame 9.jpg"),
		"audio": preload("res://cutscene images/opening_slide_9.mp3"),
		"text": "Without the artifact in his hands, king Arithmos started losing his power and his once thriving kingdom began to wither."
	},
	{
		"image": preload("res://cutscene images/Frame 10.jpg"),
		"audio": preload("res://cutscene images/opening_slide_10.mp3"),
		"text": "Darkness spread all over the land of Numeria and hope for a recovery faded more and more from people’s hearts, as the days were passing by."
	},
	{
		"image1": preload("res://cutscene images/Frame 11.jpg"),
		"image2": preload("res://cutscene images/Frame 12.jpg"),
		"audio": preload("res://cutscene images/opening_slide_11.mp3"),
		"text": "Enigmor’s plan seemed to be unfolding perfectly and king Arithmos felt weaker than ever, as he wasn’t able to stop the growing darkness all by himself."
	},
	{
		"image1": preload("res://cutscene images/Frame 13.jpg"),
		"image2": preload("res://cutscene images/Frame 14.jpg"),
		"image3": preload("res://cutscene images/Frame 15.jpg"),
		"audio": preload("res://cutscene images/opening_slide_12.mp3"),
		"text": "Therefore, he needed someone to help him restore balance to the realm. And the only person who is capable to solve the demanding puzzles and outsmart the villain creatures of Enigmor is YOU. You - a smart, sharp-minded, courageous and strong young man - can journey through the kingdom, fight the monsters of the magician, solve the demanding puzzles, overcome any obstacle, find every part of the scepter and reconstruct it. You are Arithmos’ last hope. Only you are able to restore the kingdom to its former glory and destroy the evil heart of the magician Enigmor once and for all, so that he never gets a chance again to plunge the realm into chaos. Find the scepter parts, put them back into place, reconstruct the magical artifact and kill Enigmor! You have the power to do it. The fate of the kingdom rests in your hands!"
	}
]

var current_slide := 0

func _ready():
	play_slide(0)
	MusicManager.load_music("res://Crystal Spires in Mist.mp3")
	MusicManager.play_music()

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

func play_two_slides(index: int, delay: float):
	if index >= slides.size():
		end_cutscene()
		return

	var slide = slides[index]

	image.texture = slide.image1
	type_text("[center]"+slide.text+"[/center]")

	audio.stream = slide.audio
	audio.play()
	audio.finished.connect(_on_audio_finished, CONNECT_ONE_SHOT)
	
	await get_tree().create_timer(delay).timeout
	image.texture = slide.image2

func play_three_slides(index: int, delay: float):
	if index >= slides.size():
		end_cutscene()
		return

	var slide = slides[index]

	image.texture = slide.image1
	type_text("[center]"+slide.text+"[/center]")

	audio.stream = slide.audio
	audio.play()
	audio.finished.connect(_on_audio_finished, CONNECT_ONE_SHOT)
	
	await get_tree().create_timer(delay).timeout
	image.texture = slide.image2
	await get_tree().create_timer(delay).timeout
	image.texture = slide.image3

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
	match current_slide:
		6:
			play_two_slides(current_slide, 7.0)
		10:
			play_two_slides(current_slide, 8.0)
		11:
			play_three_slides(current_slide, 20.0)
		_:
			play_slide(current_slide)

func end_cutscene():
	SceneManager.change_scene("res://scenes/main.tscn")
