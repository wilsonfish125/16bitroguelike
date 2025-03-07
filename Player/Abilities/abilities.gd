class_name PlayerAbilities extends Node

const BOOMERANG = preload("res://Player/Abilities/boomerang.tscn")

enum abilities { BOOMERANG, WAND, ETC }


var selectedAbility = abilities.BOOMERANG #by default
var player : Player

var boomerangInstance : Boomerang = null


func _ready() -> void:
	player = PlayerManager.player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ability" ):
		if selectedAbility == abilities.BOOMERANG:
			boomerangAbility()

func boomerangAbility() -> void:
	if boomerangInstance != null:
		return
	
	
	var _b = BOOMERANG.instantiate() as Boomerang
	player.add_sibling( _b )
	_b.global_position = player.global_position
	
	var throwDirection = player.direction
	if throwDirection == Vector2.ZERO:
		throwDirection = player.cardinalDirection
	
	_b.throw( throwDirection )
	boomerangInstance = _b
	pass
