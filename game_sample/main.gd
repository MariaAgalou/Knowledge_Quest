extends Node2D

@export var audio_stream: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var player = get_tree().get_first_node_in_group("player")
	#if GameState.levels_completed == 1:
		#player.play_audio(audio_stream)
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
