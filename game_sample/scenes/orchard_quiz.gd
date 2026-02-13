extends Area2D

@export var audio_stream: AudioStream
@onready var quiz_ui = $"../QuizUI"
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var col: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

var original_camera_position: Vector2
var quiz_audio_active = false

func _on_mouse_entered():
	sprite.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	sprite.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if GameState.orchard_quiz_triggered:
			show_text()
			return
		quiz_audio_active = true
		sfx.stop()
		sfx.stream = load("res://scripts/Interacting_with_an_item.mp3")
		sfx.play()
		var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
		var player = get_tree().get_first_node_in_group("player")
		dialogue_box.visible = false
		var audio_player = player.get_node("AudioStreamPlayer")
		play_audio(audio_player)
		show_dialogue()


func play_audio(audio_player: AudioStreamPlayer):
	# Prevent duplicate connections
	if audio_player.finished.is_connected(_on_audio_finished):
		audio_player.finished.disconnect(_on_audio_finished)

	audio_player.stop()
	audio_player.stream = audio_stream
	audio_player.finished.connect(_on_audio_finished)
	audio_player.play()

func _on_audio_finished():
	if GameState.orchard_quiz_triggered:
		var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
		var panel_box = get_tree().get_first_node_in_group("PanelBox")
		if dialogue_box:
			dialogue_box.visible = false
			panel_box.visible = false
	else:
		quiz_audio_active = false
		start_quiz()
		col.disabled = true
		

func start_quiz():
	var score_box = get_tree().get_first_node_in_group("ScoreBox")
	score_box.hide()
	var lives_box = get_tree().get_first_node_in_group("LivesBox")
	lives_box.hide()
	var emoji = get_tree().get_first_node_in_group("HeartEmoji")
	emoji.visible = false
	get_tree().paused = true
	quiz_ui.show()
	quiz_ui.questions = [
		{
			"question": "Emma ate 1/4 of a pizza and her brother ate 2/4 of the same pizza.
How much of the pizza did they eat altogether?",
			"answers": ["3/4", "2/4", "1/4", "4/4"],
			"correct": 0,
			"hint": "The fractions have the same bottom number, so you can add the top numbers."
		},
		{
			"question": "Which fraction is equal to 1/2?",
			"answers": ["1/3", "4/3", "3/5", "2/4"],
			"correct": 3,
			"hint": "Try dividing the top and bottom numbers by the same number."
		},
		{
			"question": "Sofia bought a juice for €1.25 and paid with €2.00.
How much change should she get?",
			"answers": ["€0.75", "€0.50", "€0.25", "€0.65"],
			"correct": 0,
			"hint": "Line up the decimal points before adding."
		},
		{
			"question": "Which number is greater?",
			"answers": ["0.45", "0.50", "0.39", "0.48"],
			"correct": 1,
			"hint": "Change the fraction into a decimal before adding."
		},
		{
			"question": "Mia drank 3/10 of a liter of water. Which decimal shows how much she drank?",
			"answers": ["0.13", "0.03", "0.3", "3.0"],
			"correct": 2,
			"hint": "A fraction with 10 on the bottom can be written easily as a decimal."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.orchard_level_completed = true
	GameState.orchard_quiz_triggered = true
	
	original_camera_position = camera.global_position
	quiz_ui.original_cam_pos(original_camera_position)
	camera.global_position = quiz_ui.global_position

func show_text():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "You have already completed this quiz!"
		dialogue_box.visible = true
		panel_box.visible = true
		await get_tree().create_timer(2.0).timeout
		dialogue_box.visible = false
		panel_box.visible = false

func show_dialogue():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "Help the hero gather special blossoms for orchard bees—ace the next quiz, and the buzzing guides will reveal the scepter’s hiding place."
		dialogue_box.visible = true
		panel_box.visible = true
