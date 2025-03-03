class_name PushableStatue extends RigidBody2D

@export var pushSpeed : float = 90.0

var pushDirection : Vector2 = Vector2.ZERO : set = _setPush

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

#since this is a rigidbody lets move it with physics as intended

func _physics_process( _delta: float ) -> void:
	linear_velocity = pushDirection * pushSpeed



func _setPush( value : Vector2 ) -> void:
	pushDirection = value
	if pushDirection == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
