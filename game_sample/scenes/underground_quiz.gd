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
		if GameState.underground_dungeon_quiz_triggered:
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
	if GameState.underground_dungeon_quiz_triggered:
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
			"question": "What is the prime factorization of 12?",
			"answers": ["2 × 6", "3 × 4", "12 × 1", "2 × 2 × 3"],
			"correct": 3,
			"hint": "Keep breaking the number into smaller factors until all factors are prime numbers."
		},
		{
			"question": "What is the prime factorization of 15?",
			"answers": ["5 × 3 × 1", "1 × 2 × 7", "3 × 5", "15 × 1"],
			"correct": 2,
			"hint": "Try dividing by the smallest prime number that works."
		},
		{
			"question": "What is the prime factorization of 18?",
			"answers": ["2 × 9", "3 × 3 × 7", "2 × 3 × 3", "18 × 1"],
			"correct": 2,
			"hint": "Check if the number is even. If yes, start dividing by 2."
		},
		{
			"question": "Which of the following is the prime factorization of 20?",
			"answers": ["4 × 5 × 10", "2 × 2 × 5", "20 × 1", "2 × 10 × 3"],
			"correct": 1,
			"hint": "Remember: 4 and 10 are not prime numbers."
		},
		{
			"question": "Find the prime factorization of 24.",
			"answers": ["2 × 2 × 2 × 3", "6 × 4", "2 × 12", "3 × 8 × 2 × 2"],
			"correct": 0,
			"hint": "Keep dividing by 2 as long as the number is even."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.underground_dungeon_level_completed = true
	GameState.underground_dungeon_quiz_triggered = true
	
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
		dialogue_box.text = "To proceed, the hero must step on the tiles in the correct sequence—your success in the next quiz will reveal the hidden pattern."
		dialogue_box.visible = true
		panel_box.visible = true
