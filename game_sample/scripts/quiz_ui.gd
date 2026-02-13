extends Control

@onready var question_label = $Panel/Label
@onready var buttons = [
	$Panel/Button,
	$Panel/Button2,
	$Panel/Button3,
	$Panel/Button4
]

@export var default_style: StyleBox
@export var correct_style: StyleBox
@export var wrong_style: StyleBox

@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var timer: Timer = $"Question Timer"
@onready var timer_global: Timer = $"Global Timer"
@onready var timerLabel: Label = $Panel/TimerLabel
@onready var lives: Label = $Panel/Lives

@onready var hint: Panel = $Panel/Hint
@onready var hint_label: Label = $Panel/Hint/Label
@onready var hint_button: Button = $"Panel/Hint Button"

@onready var statistics: ScrollContainer = $Panel/Statistics
@onready var stats_label: Label = $Panel/Statistics/Stats_Label
@onready var exit: Button = $Panel/Exit

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

var original_camera_position: Vector2
var time_remaining: int
var time_it_took: int
var correct_ans = false
var first = true
var alive = true

var current_question = 0
var wrong_questions = 0
var correct_questions = 0
var lives_lost = 0

var hints = 0
var hint_limit = 2
var first_time_hint = true

var questions = []

var wrong_list = []
var correct_list = []

func _ready():
	hide()
	hint_button.hide()
	hint.hide()
	statistics.hide()
	exit.hide()
	lives.text = str(GameState.lives)
	for i in buttons.size():
		buttons[i].pressed.connect(func():
			_on_answer_pressed(i)
		)

func _process(_delta):
	if timer.time_left > 0:
		timerLabel.text = str(ceil(timer.time_left))
	if alive:
		if GameState.lives <= 0:
			alive = false
			finish_quiz()

func load_question(time_rem:int):
	timerLabel.show()
	var q = questions[current_question]
	question_label.text = q["question"]
	hint_label.text = q["hint"]
	for i in buttons.size():
		buttons[i].text = q["answers"][i]
		
	apply_default_styles()
	
	timer.wait_time = time_rem
	timer.one_shot = true
	timer.start()

func _on_answer_pressed(index: int) -> void:
	var correct: int = questions[current_question]["correct"]

	if index == correct:
		sfx.stop()
		sfx.stream = load("res://scripts/Providing_a_right_an.mp3")
		sfx.play()
		timerLabel.hide()
		correct_ans = true
		hint_button.hide()
		show_answer_styles()
		# Disable buttons to prevent spam
		set_buttons_enabled(false)
		# Wait 3 seconds
		await get_tree().create_timer(2.0).timeout
		set_buttons_enabled(true)
		if first:
			correct_questions += 1
			GameState.correct_questions += 1
			correct_list.append(questions[current_question]["question"]+"\n")
			first = false
		current_question += 1
		if current_question >= questions.size():
			finish_quiz()
		else:
			first = true
			load_question(60)
	else:
		sfx.stop()
		sfx.stream = load("res://scripts/Providing_a_wrong_an.mp3")
		sfx.play()
		question_label.text = "Wrong answer. Try again to find the correct one!"
		first_time_hint = true
		if hints < hint_limit:
			hint_button.show()
		if first:
			wrong_questions += 1
			wrong_list.append(questions[current_question]["question"]+"\n")
			first = false
		GameState.lives -= 1
		lives_lost += 1
		lives.text = str(GameState.lives)
		# Disable buttons to prevent spam
		set_buttons_enabled(false)
		# Wait 3 seconds
		await get_tree().create_timer(3.0).timeout
		set_buttons_enabled(true)
		time_remaining = ceil(timer.time_left)
		if alive:
			load_question(time_remaining)

func original_cam_pos(cam_pos: Vector2):
	original_camera_position = cam_pos

func finish_quiz():
	time_it_took = timer_global.wait_time - timer_global.time_left
	timer_global.stop()
	timer.stop()
	if alive:
		question_label.text = "LEVEL COMPLETE!"
		sfx.stop()
		sfx.stream = load("res://scripts/Victory_sound.mp3")
		sfx.play()
	else:
		MusicManager.stop_music()
		question_label.text = "You have been defeated..."
	GameState.update_score()
	for i in buttons.size():
		buttons[i].hide()
	timerLabel.hide()
	hint_button.hide()
	hint.hide()
	statistics.show()
	timerLabel.hide()
	exit.show()
	var statistics_dict = {
		"Score gained": correct_questions*100,
		"Total score": GameState.score,
		"Lives lost": lives_lost,
		"Lives remaining": GameState.lives,
		"Time to completion": time_it_took,
		"Number of wrong answers": wrong_questions,
		"Wrong answers": wrong_list,
		"Number of correct answers": correct_questions,
		"Correct answers": correct_list
	}
	(GameState.stats).append(statistics_dict)
	var txt := ""
	
	txt += "Score (Level): %d\n" % statistics_dict["Score gained"]
	txt += "Score (Total): %d\n" % statistics_dict["Total score"]
	txt += "Lives Lost: %d\n" % statistics_dict["Lives lost"]
	txt += "Lives Remaining: %d\n" % statistics_dict["Lives remaining"]
	txt += "Time: %.1f seconds\n\n" % statistics_dict["Time to completion"]
	txt += "Wrong answers: %d\n" % statistics_dict["Number of wrong answers"]
	var wrong_list_packed := PackedStringArray(statistics_dict["Wrong answers"])
	txt += " ".join(wrong_list_packed) + "\n"
	txt += "Correct answers: %d\n" % statistics_dict["Number of correct answers"]
	var correct_list_packed := PackedStringArray(statistics_dict["Correct answers"])
	txt += " ".join(correct_list_packed)
	
	stats_label.text = txt

func set_buttons_enabled(enabled: bool) -> void:
	hint_button.disabled = not enabled
	for b in buttons:
		b.disabled = not enabled

func start_global_timer(timer_total:int):
	timer_global.wait_time = timer_total
	timer_global.one_shot = true
	timer_global.start()

func _on_timer_timeout() -> void:
	if correct_ans:
		return
	sfx.stop()
	sfx.stream = load("res://scripts/Providing_a_wrong_an.mp3")
	sfx.play()
	hint_button.hide()
	GameState.lives -= 1
	lives_lost += 1
	lives.text = str(GameState.lives)
	timerLabel.text = "Time's up!"
	set_buttons_enabled(false)
	show_answer_styles()
	await get_tree().create_timer(5.0).timeout
	set_buttons_enabled(true)
	if first:
		wrong_questions += 1
		wrong_list.append("- "+questions[current_question]["question"]+"\n")
		first = false
	current_question += 1
	if current_question >= questions.size():
		finish_quiz()
	else:
		first = true
		load_question(60)

func apply_default_styles():
	for b in buttons:
		b.add_theme_stylebox_override("normal", default_style)
		b.add_theme_stylebox_override("hover", default_style)
		b.add_theme_stylebox_override("pressed", default_style)
		b.add_theme_stylebox_override("disabled", default_style)

func show_answer_styles():
	var correct_index: int = questions[current_question]["correct"]

	for i in buttons.size():
		var style: StyleBox = correct_style if i == correct_index else wrong_style
		buttons[i].add_theme_stylebox_override("normal", style)
		buttons[i].add_theme_stylebox_override("hover", style)
		buttons[i].add_theme_stylebox_override("pressed", style)
		buttons[i].add_theme_stylebox_override("disabled", style)

func _on_hint_button_pressed() -> void:
	hint.show()
	if first_time_hint:
		hints += 1
		first_time_hint = false

func _on_close_hint_pressed() -> void:
	hint.hide()

func _on_exit_pressed() -> void:
	hide()
	get_tree().paused = false
	camera.global_position = original_camera_position
