extends TextureRect

@export var float_height := 8.0        # pixels
@export var float_speed := 2.0          # lower = slower
@export var scale_amount := 0.04        # breathing size
@export var scale_speed := 1.5

@export var hover_scale := 1.08
@export var hover_speed := 0.15

var base_position: Vector2
var time := 0.0
var is_hovered := false

func _ready():
	base_position = position
	pivot_offset = size / 2

func _process(delta):
	time += delta
	
	position.y = base_position.y + sin(time * float_speed) * float_height
	
	var breathe = 1.0 + sin(time * scale_speed) * scale_amount
	var target_scale = Vector2(breathe, breathe)
	
	if is_hovered:
		target_scale *= hover_scale
	
	scale = scale.lerp(target_scale, hover_speed)
	
	# Feed time to shader
	if material and material is ShaderMaterial:
		material.set_shader_parameter("custom_time", time)

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false
