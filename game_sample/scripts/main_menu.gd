extends Control

@export var default_style: StyleBox
@export var default_grey_style: StyleBox

@onready var login_panel: Panel = $Login
@onready var username: LineEdit = $Login/VBoxContainer/Username
@onready var password: LineEdit = $Login/VBoxContainer/Password
@onready var error_label: Label = $Login/VBoxContainer/Error
@onready var label: Label = $Hello
@onready var http := $HTTPRequest

@onready var buttons = [
	$HBoxContainer/VBoxContainer/Button,
	$HBoxContainer/VBoxContainer/Button4,
	$HBoxContainer/VBoxContainer2/Button2,
	$HBoxContainer/VBoxContainer2/Button3,
	$Teacher
]

func _ready() -> void:
	if GameState.player_name != "":
		label.text = "Hello " + GameState.player_name + "!"
	else:
		label.text = "Hello Teacher!"
	apply_styles()
	login_panel.visible = false
	error_label.visible = false

func apply_styles():
	for b in buttons:
		b.add_theme_stylebox_override("normal", default_style)
		b.add_theme_stylebox_override("hover", default_grey_style)
		b.add_theme_stylebox_override("pressed", default_style)
		b.add_theme_stylebox_override("disabled", default_style)

func _on_teacher_pressed() -> void:
	if login_panel.visible:
		login_panel.visible = false
		error_label.visible = true
	else:
		login_panel.visible = true
		error_label.visible = false

func _on_submit_pressed() -> void:
	login_teacher(username.text, password.text)

func login_teacher(username: String, password: String):
	var body = {
		"username": username,
		"password": password
	}

	var headers = ["Content-Type: application/json"]
	http.request(
		"http://127.0.0.1:3000/login",
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)

func _on_http_request_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	# Network-level failure
	if result != HTTPRequest.RESULT_SUCCESS:
		error_label.text = "Network error"
		error_label.visible = true
		return

	# Server-level failure
	if response_code != 200:
		error_label.text = "Server error (%d)" % response_code
		error_label.visible = true
		return

	var response_text := body.get_string_from_utf8()
	var data = JSON.parse_string(response_text)

	if data == null:
		error_label.text = "Invalid server response"
		error_label.visible = true
		return

	if data.get("success", false):
		GameState.teacher_token = data.get("token", "")
		SceneManager.change_scene("res://scenes/teacher_statistics.tscn")
	else:
		error_label.text = "Wrong username and password combination."
		error_label.visible = true

func _on_button_pressed() -> void:
	if GameState.player_name != "":
		SceneManager.change_scene("res://scenes/opening_cutscene.tscn")

func _on_button_4_pressed() -> void:
	HowToPlay.show()

func _on_button_2_pressed() -> void:
	SceneManager.change_scene("res://scenes/credits.tscn")

func _on_button_3_pressed() -> void:
	get_tree().quit()
