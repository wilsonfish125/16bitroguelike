# Singletons should NOT have class names
extends Node

const DAMAGETEXT = preload("res://00Global/Global Effects/damageText.tscn")

# Any script in our project can call this function to create a damage text 
func damageText( _damage : int, _pos : Vector2 ) -> void:
	var _t : DamageText = DAMAGETEXT.instantiate()
	add_child( _t )
	_t.start( str(_damage), _pos )
