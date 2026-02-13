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
		if GameState.woods_quiz_triggered:
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
	if GameState.woods_quiz_triggered:
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
			"question": "What is the value of:
6+4×3",
			"answers": ["30", "18", "24", "12"],
			"correct": 1,
			"hint": "Multiply before you add."
		},
		{
			"question": "Which expression shows the Commutative Property of Addition?",
			"answers": ["(2+3)+4=2+(3+4)", "5+7=7+5", "6×(2+3)=6×2+6×3", "9−4=4−9"],
			"correct": 1,
			"hint": "The commutative property means numbers can switch places."
		},
		{
			"question": "Which equation shows the Associative Property of Multiplication?",
			"answers": ["3×(4×2)=(3×4)×2", "6×5=5×6", "8+2=10", "9×(1+3)=9+3"],
			"correct": 0,
			"hint": "Look for parentheses moving, not numbers switching places."
		},
		{
			"question": "What is the value of:
5×(6+2)",
			"answers": ["50", "30", "35", "40"],
			"correct": 3,
			"hint": "Multiply each number inside the parentheses."
		},
		{
			"question": "Which is the correct way to solve:
4×(3+5)",
			"answers": ["4×3+5=17", "4+3×5=19", "4×3+4×5=32", "(4+3)×5=35"],
			"correct": 2,
			"hint": "Distribute the 4 to both numbers inside the parentheses."
		}
	]
	quiz_ui.load_question(60)
	quiz_ui.start_global_timer(600)
	
	GameState.woods_level_completed = true
	GameState.woods_quiz_triggered = true
	
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
		dialogue_box.text = "The hero spots the scepter atop a scratched tree; only by passing a trial of wits can they climb and claim it."
		dialogue_box.visible = true
		panel_box.visible = true
