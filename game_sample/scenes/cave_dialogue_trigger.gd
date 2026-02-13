extends Area2D

@export var audio_stream: AudioStream
@onready var quiz = $"../Cave Quiz"
var dialogue_triggered := false

func _on_body_entered(body):
	if quiz.quiz_audio_active:
		return
	if dialogue_triggered:
		return
	if body.is_in_group("player"):  # Make sure your player is in "player" group
		var audio_player = body.get_node("AudioStreamPlayer")
		dialogue_triggered = true
		play_audio(audio_player)
		show_dialogue()

func show_dialogue():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "The cave sprawls in twisting chambers: torchlit ruins, bone-strewn tunnels, glowing mushrooms, rope bridges over a dark chasm, and silent pools hiding forgotten secrets."
		panel_box.visible = true
		dialogue_box.visible = true

func play_audio(audio_player: AudioStreamPlayer):
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
