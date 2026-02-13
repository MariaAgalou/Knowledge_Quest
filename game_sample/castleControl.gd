extends Node

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
