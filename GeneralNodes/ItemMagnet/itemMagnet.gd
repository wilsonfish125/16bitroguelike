class_name ItemMagnet extends Area2D


var items : Array[ ItemPickup ] = []
var speeds : Array[ float ] = []


@export var magnetStrength : float = 1.0
@export var playMagnetAudio : bool = false

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	area_entered.connect( _onAreaEntered )

func _process( delta: float ) -> void:
	for i in range( items.size() - 1, - 1, - 1 ):
		var _item = items[i]
		if _item == null:
			items.remove_at( i )
			speeds.remove_at( i )
		elif _item.global_position.distance_to( global_position ) > speeds[i]:
			speeds[i] += magnetStrength * delta
			_item.position += _item.global_position.direction_to( global_position ) * speeds[i]
		else:
			_item.global_position = global_position
	pass



func _onAreaEntered( _a : Area2D ) -> void:
	if _a.get_parent() is ItemPickup:
		var _newItem = _a.get_parent() as ItemPickup
		items.append( _newItem )
		speeds.append( magnetStrength )
		_newItem.set_physics_process( false )
		if playMagnetAudio:
			audio.play( 0 )
	pass
