extends Area2D

@export var audio_stream: AudioStream
@onready var quiz_ui = $"../QuizUI"
@onready var camera: Camera2D = get_viewport().get_camera_2d()

var original_camera_position: Vector2
var quiz_audio_active = false

func _on_body_entered(body):
	if GameState.castle_quiz_triggered:
		show_dialogue()
		return
	if body.is_in_group("player"):
		quiz_audio_active = true
		var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
		dialogue_box.visible = false
		var audio_player = body.get_node("AudioStreamPlayer")
		play_audio(audio_player)

func play_audio(audio_player: AudioStreamPlayer):
	# Prevent duplicate connections
	if audio_player.finished.is_connected(_on_audio_finished):
		audio_player.finished.disconnect(_on_audio_finished)

	audio_player.stop()
	audio_player.stream = audio_stream
	audio_player.finished.connect(_on_audio_finished)
	audio_player.play()

func _on_audio_finished():
	if GameState.castle_quiz_triggered:
		var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
		if dialogue_box:
			dialogue_box.visible = false
	else:
		quiz_audio_active = false
		start_quiz()

func start_quiz():
	var score_box = get_tree().get_first_node_in_group("ScoreBox")
	score_box.hide()
	var lives_box = get_tree().get_first_node_in_group("LivesBox")
	lives_box.hide()
	var emoji = get_tree().get_first_node_in_group("HeartEmoji")
	emoji.visible = false
	get_tree().paused = true
	quiz_ui.show()
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	original_camera_position = camera.global_position
	quiz_ui.original_cam_pos(original_camera_position)
	camera.global_position = quiz_ui.global_position

func show_dialogue():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	if dialogue_box:
		dialogue_box.text = "You have already completed this quiz!"
		dialogue_box.visible = true
		await get_tree().create_timer(1.0).timeout
		dialogue_box.visible = false
