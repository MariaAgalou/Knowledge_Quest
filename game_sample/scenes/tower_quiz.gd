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
		if GameState.abandoned_tower_quiz_triggered:
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
	if GameState.abandoned_tower_quiz_triggered:
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
			"question": "Liam has 100 candies. He gives 25% of them to his friends.
How many candies does Liam give away?",
			"answers": ["20", "25", "30", "40"],
			"correct": 1,
			"hint": "25% means 25 out of 100."
		},
		{
			"question": "A toy costs €200. It is on sale for 50% off.
How much money is taken off the original price?",
			"answers": ["€100", "€50", "€150", "€75"],
			"correct": 0,
			"hint": "50% means half of the number."
		},
		{
			"question": "There are 40 students in a class. 10% of them are absent.
How many students are absent?",
			"answers": ["2", "4", "3", "5"],
			"correct": 1,
			"hint": "10% means 10 out of 100, or one-tenth."
		},
		{
			"question": "Round 47 to the nearest ten.",
			"answers": ["40", "50", "60", "45"],
			"correct": 1,
			"hint": "Look at the ones digit to decide whether to round up or down."
		},
		{
			"question": "Round 3.6 to the nearest whole number.",
			"answers": ["6", "3", "4", "5"],
			"correct": 2,
			"hint": "Check the digit right after the decimal point."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.abandoned_tower_level_completed = true
	GameState.abandoned_tower_quiz_triggered = true
	
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
		dialogue_box.text = "The hero scans crowded furniture for secrets. Help him push pieces aside—solve the next quiz to reveal any hidden doors lurking behind."
		dialogue_box.visible = true
		panel_box.visible = true
