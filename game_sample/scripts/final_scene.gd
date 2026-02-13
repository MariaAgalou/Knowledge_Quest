extends Control

@onready var http = $HTTPRequest
@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.hide()
	send_statistics(GameState.player_name, GameState.stats)

func send_statistics(student_name: String, statistics_array: Array):
	var body = { 
		"student": student_name, 
		"stats": statistics_array 
	}
	var headers = ["Content-Type: application/json"]
	http.request(
		"http://127.0.0.1:3000/stats", 
		headers, 
		HTTPClient.METHOD_POST, 
		JSON.stringify(body) 
	)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Network error")
		button.show()
		return

	var text := body.get_string_from_utf8()
	print("Server response:", text)

	var data = JSON.parse_string(text)
	if data and data.get("success"):
		print("Stats saved successfully")
	else:
		print("Failed to save stats")
	await get_tree().create_timer(5.0).timeout
	button.show()

func _on_button_pressed() -> void:
	get_tree().quit()
