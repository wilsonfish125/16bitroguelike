#do not want a classname for autoloads :(
extends CanvasLayer

var hearts : Array[ HeartGUI ] = []




func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false #turn em all off by default
	pass

func updateHP( _hp: int, _maxHP: int ) -> void:
	updateMaxHP( _maxHP )
	for i in _maxHP:
		updateHeart( i, _hp )
		pass
	pass

func updateHeart( _index : int, _hp : int ) -> void:
	var _value : int = clamp( _hp - _index * 2, 0, 2 ) #figures out half hearts
	hearts[ _index ].value = _value
	pass 


func updateMaxHP( _maxHP : int ) -> void:
	var _heartCount : int = roundi( _maxHP * 0.5 ) #rounded obvz
	for i in hearts.size():
		if i < _heartCount:
			hearts[i].visible = true
		else:
			hearts[i].visible = false #goes over every heart and turns them visible or invisible depending on max health
	pass
