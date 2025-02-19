class_name HeartGUI extends Control

@onready var sprite = $Sprite2D

#Value of a full heart
var value : int = 2 :
	set( _value ): #called every time the var above is changed ("set")
		value = _value
		updateSprite()



func updateSprite() -> void:
	if value == 2:
		sprite.frame = 0
	if value == 1:
		sprite.frame = 1
	if value == 0:
		sprite.frame = 2
	pass
