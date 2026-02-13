extends Area2D

@export var audio_stream1: AudioStream
@export var audio_stream2: AudioStream
@onready var quiz = $"../Tower Quiz"
var dialogue_triggered := false
var second_pass := false

func _on_body_entered(body):
	if quiz.quiz_audio_active:
		return
	if dialogue_triggered:
		return
	if second_pass && GameState.abandoned_tower_quiz_triggered:
		if body.is_in_group("player"):
			var audio_player = body.get_node("AudioStreamPlayer")
			dialogue_triggered = true
			play_audio(audio_player, audio_stream2)
			show_dialogue2()
	else:
		if body.is_in_group("player"):
			if second_pass:
				return
			second_pass = true
			var audio_player = body.get_node("AudioStreamPlayer")
			play_audio(audio_player, audio_stream1)
			show_dialogue1()

func show_dialogue1():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "The hero uncovers a tarnished key, humming faintly with ancient magic and promises of locked destinies."
		panel_box.visible = true
		dialogue_box.visible = true

func show_dialogue2():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "The hidden door opens, revealing the long-sought scepter fragment, gleaming with power at last."
		panel_box.visible = true
		dialogue_box.visible = true

func play_audio(audio_player: AudioStreamPlayer, audio_stream: AudioStream):
	# If audio was playing, treat stop as "finished"
	if audio_player.playing:
		var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
		if dialogue_box:
			dialogue_box.visible = false
	
	# Prevent duplicate connections
	if audio_player.finished.is_connected(_on_audio_finished):
		audio_player.finished.disconnect(_on_audio_finished)

	audio_player.stop()
	audio_player.stream = audio_stream
	audio_player.finished.connect(_on_audio_finished)
	audio_player.play()

func _on_audio_finished():
	# Hide dialogue when audio finishes
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.visible = false
		panel_box.visible = false
