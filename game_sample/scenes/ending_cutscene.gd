extends Control

@onready var image = $ColorRect/TextureRect
@onready var audio = $AudioStreamPlayer
@onready var text_label: RichTextLabel = $ColorRect/TextureRect/RichTextLabel

var cutscene_skipped := false
var is_cutscene_playing := true

var slides = [
	{
		"image": preload("res://cutscene images/Frame 16.jpg"),
		"audio": preload("res://cutscene images/ending_slide_1.mp3"),
		"text": "The villainous magician whispered his last words, uttering a curse that promised eternal torment, left his last breath and his body transformed into a mountain of ashes, as the remnants of his dark magic dissolved into the air."
	},
	{
		"image": preload("res://cutscene images/Frame 17.jpg"),
		"audio": preload("res://cutscene images/ending_slide_2.mp3"),
		"text": "His dark powers have dissolved into the ether, leaving behind nothing but a fading echo of his malevolence. The heart of evil is finally beaten!"
	},
	{
		"image": preload("res://cutscene images/Frame 18.jpg"),
		"audio": preload("res://cutscene images/ending_slide_3.mp3"),
		"text": "The hero killed the devious magician and defeated his evil and dangerous monsters, ending this way his reign of terror. As he saw Enigmor collapsing to the ground and leaving his last breath, he grabbed the magic scepter and started running towards the king’s castle."
	},
	{
		"image": preload("res://cutscene images/Frame 19.jpg"),
		"audio": preload("res://cutscene images/ending_slide_4.mp3"),
		"text": "The source of the evil was defeated and the valuable artifact was safe and finally reconstructed. To finish his mission, the hero had to return it to its rightful owner, king Arithmos."
	},
	{
		"image": preload("res://cutscene images/Frame 20.jpg"),
		"audio": preload("res://cutscene images/ending_slide_5.mp3"),
		"text": "Holding the scepter tightly in his hands, the hero left the dead body of Enigmor behind him and he headed towards the castle with confidence and determination, ready to receive his reward for his challenging mission."
	},
	{
		"image": preload("res://cutscene images/Frame 20-5.jpg"),
		"audio": preload("res://cutscene images/ending_slide_6.mp3"),
		"text": "When he arrived at the king’s castle, he announced to king Arithmos that he had found and reconstructed his magic scepter and that he had killed the evil magician and all his wicked creatures."
	},
	{
		"image": preload("res://cutscene images/Frame 21.jpg"),
		"audio": preload("res://cutscene images/ending_slide_7.mp3"),
		"text": "“The magician Enigmor is dead, your majesty! So are the Creatures of Chaos that he unleashed against you! And the magic scepter is whole once more, ready to serve its king.” said the young hero and he handed over the precious artifact to the king."
	},
	{
		"image": preload("res://cutscene images/Frame 22.jpg"),
		"audio": preload("res://cutscene images/ending_slide_8.mp3"),
		"text": "“My young man…. you have done what many thought was impossible. You carried out the mission I entrusted to you with great success and you managed to defeat the evil that had taken over my kingdom. I want to thank you from the bottom of my heart! And, as I had promised you, your reward will be immense, worthy of the effort you put to restore peace to the kingdom of Numeria.” said the king to the young man standing confidently before him."
	},
	{
		"image": preload("res://cutscene images/Frame 23.jpg"),
		"audio": preload("res://cutscene images/ending_slide_9.mp3"),
		"text": "And just like that, peace and calmness were restored to the kingdom of Numeria. The sky, once shrouded in ominous clouds, cleared to reveal a brightening golden sun. The land, having endured the magician’s tyranny for a long period of time, began to heal. The people, once overwhelmed by fear, began to smile again and regained their hope for a better future."
	},
	{
		"image": preload("res://cutscene images/Frame 24.jpg"),
		"audio": preload("res://cutscene images/ending_slide_10.mp3"),
		"text": "A grand celebration followed. The king wanted to celebrate the restoration of peace to his kingdom and invited all the people and residents of Numeria to eat and drink with him, in a huge celebration."
	},
	{
		"image1": preload("res://cutscene images/Frame 24-1.jpg"),
		"image2": preload("res://cutscene images/Frame 24-2.jpg"),
		"image3": preload("res://cutscene images/Frame 25.jpg"),
		"audio": preload("res://cutscene images/ending_slide_11.mp3"),
		"text": "Finally, the battle was won and it has teached everyone the strength of knowledge and the value of resilience. The scepter was once again safe inside the castle, the evil enemy was beaten and peace was restored in the land of Numeria. As the festivities carried on, the hero silently left the castle, setting out on a new adventure."
	}
]

var current_slide := 0

func _ready():
	MusicManager.stop_music()
	MusicManager.load_music("res://Crystal Spires in Mist.mp3")
	MusicManager.play_music()
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
		10:
			play_three_slides(current_slide, 8.0)
		_:
			play_slide(current_slide)

func end_cutscene():
	SceneManager.change_scene("res://scenes/final_scene.tscn")
