extends Button

@export var player_path: NodePath
@export var teleport_marker: Marker2D

func _on_pressed():
	var player = get_node(player_path)
	player.global_position = teleport_marker.global_position
