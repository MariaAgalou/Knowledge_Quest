extends SubViewport

@onready var mini_map_camera = $MiniMapCamera
@onready var cam := $MiniMapCamera

const WORLD_SIZE = Vector2(5787, 16380)
const MINIMAP_SIZE = Vector2(256, 256)

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	mini_map_camera.position = player.position
	print("Frame")
	print(delta)
