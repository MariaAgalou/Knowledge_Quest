extends Area2D

@export var audio_stream: AudioStream
@onready var quiz_ui = $"../QuizUI"
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var col: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialogue: Area2D = $"../MagicianDialogueTrigger2"
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
		if dialogue.dialogue_1:
			if GameState.magician_lair_quiz_triggered:
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
	if GameState.magician_lair_quiz_triggered:
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
			"question": "Evaluate:
6 + 12 ÷ (3 × 2)",
			"answers": ["3", "8", "10", "12"],
			"correct": 1,
			"hint": "Solve what’s inside the parentheses first, then division, then addition."
		},
		{
			"question": "Evaluate:
(15 − 3) × 2 + 4",
			"answers": ["20", "24", "28", "32"],
			"correct": 2,
			"hint": "Parentheses come before multiplication and addition."
		},
		{
			"question": "Evaluate:
20 − 4 × (3 + 2)",
			"answers": ["0", "8", "12", "16"],
			"correct": 0,
			"hint": "Add inside the parentheses before multiplying."
		},
		{
			"question": "Evaluate:
(18 ÷ 3) + 5 × 2",
			"answers": ["13", "12", "16", "22"],
			"correct": 2,
			"hint": "Do division and multiplication before addition."
		},
		{
			"question": "Evaluate:
24 ÷ (4 + 2) + 7",
			"answers": ["9", "10", "11", "13"],
			"correct": 2,
			"hint": "Start with what’s inside the parentheses."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.magician_lair_level_completed = true
	GameState.magician_lair_quiz_triggered = true
	
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
		dialogue_box.text = "As Enigmor appears, the exhausted hero makes a final stand. Help him defeat the evil magician—summon your strength and win the next quiz to turn the tide!"
		dialogue_box.visible = true
		panel_box.visible = true
