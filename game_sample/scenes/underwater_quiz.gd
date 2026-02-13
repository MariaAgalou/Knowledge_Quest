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
		if GameState.underwater_realm_quiz_triggered:
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
	if GameState.underwater_realm_quiz_triggered:
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
			"question": "If 3 apples cost €30, how much will 5 apples cost?",
			"answers": ["€45", "€40", "€60", "€50"],
			"correct": 3,
			"hint": "If the number of apples increases, the cost also increases."
		},
		{
			"question": "A bicycle travels 20 km in 1 hour. How far will it travel in 4 hours at the same speed?",
			"answers": ["100 km", "70 km", "80 km", "60 km"],
			"correct": 2,
			"hint": "More time at the same speed means more distance."
		},
		{
			"question": "If 4 notebooks cost €100, how much will 10 notebooks cost?",
			"answers": ["€225", "€300", "€250", "€200"],
			"correct": 2,
			"hint": "Cost increases as the number of notebooks increases."
		},
		{
			"question": "6 workers can complete a job in 10 days. How many days will it take 3 workers to complete the same job?",
			"answers": ["15 days", "20 days", "5 days", "10 days"],
			"correct": 1,
			"hint": "Fewer workers means more days."
		},
		{
			"question": "A car takes 8 hours to travel a distance at 40 km/h. How long will it take at 80 km/h?",
			"answers": ["2 hours", "4 hours", "8 hours", "6 hours"],
			"correct": 1,
			"hint": "Higher speed means less time for the same distance."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.underwater_realm_level_completed = true
	GameState.underwater_realm_quiz_triggered = true
	
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
		dialogue_box.text = "Pleased by your offerings, the queen grants passage to the sunken ship. Dive deep and help the hero explore its ruins—complete the next quiz to uncover the scepter piece!"
		dialogue_box.visible = true
		panel_box.visible = true
