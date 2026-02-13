extends TextureRect

@export var rotation_speed := 1.0
var t := 0.0
func _ready():
	pivot_offset = size / 2

func _process(delta):
	t += delta
	rotation += rotation_speed * delta
	modulate.a = 0.2 + sin(t * 2.0) * 0.05
