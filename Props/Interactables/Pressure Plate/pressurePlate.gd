class_name PressurePlate extends Node2D

signal activated
signal deactivated

var bodies : int = 0
var isActive : bool = false
var offRect : Rect2

@onready var area_2d : Area2D = $Area2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audioActivate : AudioStream = preload("res://Resources/Michael Games Sprites/example_music/lever-01.wav")
@onready var audioDeactivate : AudioStream = preload("res://Resources/Michael Games Sprites/example_music/lever-02.wav")
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area_2d.body_entered.connect( _onBodyEntered )
	area_2d.body_exited.connect( _onBodyExited )
	offRect = sprite.region_rect #only since we are using a region as a texture for this specific

func _onBodyEntered( _b : Node2D ) -> void:
	bodies += 1 #stops it thinking there is nothing on the button when one leaves while the other stays
	checkIsActivated()
	pass

func _onBodyExited( _b : Node2D ) -> void:
	bodies -= 1
	checkIsActivated()
	pass

func checkIsActivated() -> void:
	if bodies > 0 and isActive == false:
		isActive = true
		sprite.region_rect.position.x = offRect.position.x - 32
		playAudio( audioActivate )
		activated.emit()
	elif bodies <= 0 and isActive == true:
		isActive = false
		sprite.region_rect.position.x = offRect.position.x
		playAudio( audioDeactivate )
		deactivated.emit()

func playAudio( _stream : AudioStream ) -> void:
	audio.stream = _stream
	audio.play()
