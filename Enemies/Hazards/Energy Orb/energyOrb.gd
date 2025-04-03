class_name EnergyOrb extends Node2D

@export var speed : float = 300
@export var shootAudio : AudioStream
@export var hitAudio : AudioStream

var direction : Vector2 = Vector2.DOWN

@onready var hurt_box : HurtBox = $HurtBox
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	hurt_box.didDamage.connect( hitPlayer )
	playAudio( shootAudio )
	get_tree().create_timer( 5 ).timeout.connect( destroy )
	direction = global_position.direction_to( PlayerManager.player.global_position )
	flicker()

func _process( delta: float ) -> void:
	position += direction * speed * delta

func flicker() -> void:
	modulate.a = randf() * 0.7 + 0.3
	await get_tree().create_timer( 0.05 ).timeout
	flicker()

func hitPlayer() -> void:
	playAudio( hitAudio )
	hurt_box.set_deferred( "monitoring", false )

func playAudio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()

func destroy() -> void:
	queue_free()
