extends CharacterBody2D  

@export var speed: float = 400.0
@onready var _animated_sprite = $AnimatedSprite2D

@export var male_frames: SpriteFrames
@export var female_frames: SpriteFrames
@onready var _collision = $CollisionShape2D
@onready var audio_player = $AudioStreamPlayer

var defeated := false

func _ready():	
	if GameState.gender_male:
		_animated_sprite.sprite_frames = male_frames
	else:
		_animated_sprite.sprite_frames = female_frames

func play_anim(name: String):
	if _animated_sprite.animation != name:
		_animated_sprite.play(name)

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if GameState.lives <= 0:
		if not defeated:
			handle_defeat()
		return
			
	# Collect input ONLY
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	# Animation logic
	if direction == Vector2.ZERO:
		play_anim("Idle")
	else:
		direction = direction.normalized()

		if abs(direction.x) > abs(direction.y):
			play_anim("Right" if direction.x > 0 else "Left")
		else:
			play_anim("Down" if direction.y > 0 else "Up")

	# Movement
	velocity = direction * speed
	move_and_slide()

func handle_defeat():
	defeated = true

	velocity = Vector2.ZERO
	
	play_anim("Defeat")
	
	_collision.disabled = true
	
	input_pickable = false
	
	set_physics_process(false)

func _on_animated_sprite_2d_animation_finished() -> void:
	if _animated_sprite.animation == "Defeat":
		GameOverMenu.open()

func play_audio(audio_stream: AudioStream, on_finished: Callable):
	# If audio was playing, treat stop as "finished"
	if audio_player.playing:
		on_finished.call()

	# Prevent duplicate connections
	if audio_player.finished.is_connected(on_finished):
		audio_player.finished.disconnect(on_finished)

	audio_player.stop()
	audio_player.stream = audio_stream
	audio_player.finished.connect(on_finished)
	audio_player.play()
