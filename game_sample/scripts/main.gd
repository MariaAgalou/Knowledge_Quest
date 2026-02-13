extends Node2D

@export var audio_stream: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	var movement = player.get_node("Movement")
	if movement != null:
		movement.stream = load("res://scripts/Walking_on_grass.mp3")
	MusicManager.stop_music()
	MusicManager.load_music("res://Suno (4) - Happy Little Steps v.2.mp3")
	MusicManager.play_music()
	var score_box = get_tree().get_first_node_in_group("ScoreBox")
	score_box.show()
	if score_box:
		score_box.text = "Score: " + str(GameState.score)
	var lives_box = get_tree().get_first_node_in_group("LivesBox")
	lives_box.show()
	if lives_box:
		lives_box.text = str(GameState.lives)
	var emoji = get_tree().get_first_node_in_group("HeartEmoji")
	emoji.visible = true

func _input(event):
	if event.is_action_pressed("pause_menu"):
		if get_tree().paused:
			PauseMenu.close()
		else:
			PauseMenu.open()

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/final_scene.tscn")
