class_name BarredDoor extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass



func openDoor() -> void:
	animation_player.play( "openDoor" )
	pass




func closeDoor() -> void:
	animation_player.play( "closeDoor" )
	pass
