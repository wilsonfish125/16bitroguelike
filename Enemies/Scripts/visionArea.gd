class_name VisionArea extends Area2D

#signals in this format so you can differnatiate them fron variables dummy
signal player_entered()
signal player_exited()

func _ready() -> void:
	#wanna connect to preexisting body entered signals from area2d
	body_entered.connect( _onBodyEnter )
	body_exited.connect( _onBodyExit )
	#lets connect to some signals in the enemy script
	var p = get_parent()
	if p is Enemy:
		p.direction_changed.connect( _onDirectionChange )
	

func _onBodyEnter( b : Node2D ) -> void:
	if b is Player:
		player_entered.emit()
	pass

func _onBodyExit( b : Node2D ) -> void:
	if b is Player:
		player_exited.emit()
	pass

func _onDirectionChange( newDirection : Vector2 ) -> void:
	match newDirection:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass
