extends Node2D

@onready var player: AudioStreamPlayer = $MusicPlayer

func load_music(res:String):
	player.stream = load(res)

func play_music():
	if not player.playing:
		player.play()
		
func stop_music():
	if player.playing:
		player.stop()
