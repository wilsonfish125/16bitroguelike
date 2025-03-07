class_name Boomerang extends Node2D

enum State { INACTIVE, THROW, RETURN }

var player : Player
var direction : Vector2
var speed : float = 0
var state #types dont really work with enums

@export var acceleration : float = 1000.0
@export var maxSpeed : float = 800.0
@export var catchAudio : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player

func _physics_process( delta: float ) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0: #when boomerang hits the apex its movement behavior changes
			state = State.RETURN
		pass
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position )
		speed += acceleration * delta
		position +=  direction * speed * delta
		if global_position.distance_to( player.global_position ) <= 20:
			PlayerManager.playAudio( catchAudio )
			queue_free() #no more infinite boomerangs in the void
		pass
	
	var speedRatio = speed / maxSpeed
	audio.pitch_scale = speedRatio * 0.50 + 0.60
	animation_player.speed_scale = 1 + ( speedRatio * 0.15 )
	
	pass


func throw( throwDir : Vector2 ) -> void:
	direction = throwDir
	speed = maxSpeed
	state = State.THROW
	animation_player.play( "boomerang" )
	PlayerManager.playAudio( catchAudio )
	visible = true
