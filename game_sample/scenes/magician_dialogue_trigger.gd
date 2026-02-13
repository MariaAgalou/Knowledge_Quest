extends Area2D

@export var audio_stream: AudioStream
@onready var quiz = $"../Magician Quiz"
var dialogue_triggered := false
var dialogue_triggered_2 := false

func _on_body_entered(body):
	if quiz.quiz_audio_active:
		return
	if dialogue_triggered:
		return
	if body.is_in_group("player"):
		dialogue_triggered = true
		var audio_player = body.get_node("AudioStreamPlayer")
		play_audio(audio_player)
		show_dialogue()

func show_dialogue():
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.text = "A warm stone workshop glows with firelight, cluttered tables of bubbling potions, hanging herbs, rune-scribed floors, and dog-eared tomes—half laboratory, half home."
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
	dialogue_triggered_2 = true
	# Hide dialogue when audio finishes
	var dialogue_box = get_tree().get_first_node_in_group("DialogueBox")
	var panel_box = get_tree().get_first_node_in_group("PanelBox")
	if dialogue_box:
		dialogue_box.visible = false
		panel_box.visible = false
