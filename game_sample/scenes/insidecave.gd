extends Node2D

@onready var col: ColorRect = $ColorRect
@onready var tex: TextureRect = $ColorRect/TextureRect

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	player.speed = 200.0
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
