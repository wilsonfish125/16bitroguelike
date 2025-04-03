class_name EnergyBeamAttack extends Node2D

@export var useTimer : bool = false
@export var timeBetweenAttacks : float = 5

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if useTimer == true:
		attackDelay()

#Initiates the beam attack
func attack() -> void:
	animation_player.play( "attack" )
	await animation_player.animation_finished
	animation_player.play( "default" )
	if useTimer == true:
		attackDelay()

#Await the time between attacks
func attackDelay() -> void:
	await get_tree().create_timer( timeBetweenAttacks ).timeout
	attack()
