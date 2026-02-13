extends Area2D

@export var audio_stream: AudioStream
@onready var quiz_ui = $"../QuizUI"
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var col: CollisionShape2D = $CollisionShape2D
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
		if GameState.mountains_quiz_triggered:
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
	if GameState.mountains_quiz_triggered:
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
			"question": "What is 6 × 4?",
			"answers": ["20", "22", "24", "26"],
			"correct": 2,
			"hint": "Think of 6 groups of 4."
		},
		{
			"question": "What is 7 × 5?",
			"answers": ["30", "35", "40", "45"],
			"correct": 1,
			"hint": "Multiplying by 5 is the same as counting by 5s."
		},
		{
			"question": "What is 9 × 3?",
			"answers": ["18", "21", "27", "30"],
			"correct": 2,
			"hint": "9 × 3 is the same as adding 9 three times."
		},
		{
			"question": "What is 8 × 6?",
			"answers": ["42", "46", "54", "48"],
			"correct": 3,
			"hint": "Try doubling 8 × 3."
		},
		{
			"question": "What is 4 × 9?",
			"answers": ["36", "34", "32", "40"],
			"correct": 0,
			"hint": "4 × 9 is the same as 9 + 9 + 9 + 9."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.mountains_level_completed = true
	GameState.mountains_quiz_triggered = true
	
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
		dialogue_box.text = "Finding a telescope, the hero scans distant lands; to claim the scepter piece, the player must pass a challenging quiz."
		dialogue_box.visible = true
		panel_box.visible = true
