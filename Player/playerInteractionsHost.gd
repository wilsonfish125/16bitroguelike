class_name PlayerInteractionsHost extends Node2D

@onready var player: Player = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.DirectionChanged.connect( updateDirection )
	pass # Replace with function body.


func updateDirection( newDirection : Vector2 ) -> void:
	match newDirection:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_: #incase direction doesnt match
			rotation_degrees = 0
	pass
