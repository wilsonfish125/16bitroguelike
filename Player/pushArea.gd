extends Area2D



func _ready() -> void:
	body_entered.connect( _onBodyEntered )
	body_exited.connect( _onBodyExited )


func _onBodyEntered( b : Node2D ) -> void:
	if b is PushableStatue:
		b.pushDirection = PlayerManager.player.direction
	pass

func _onBodyExited( b : Node2D ) -> void:
	if b is PushableStatue:
		b.pushDirection = Vector2.ZERO
	pass
