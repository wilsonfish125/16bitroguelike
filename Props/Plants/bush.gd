class_name Bush extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.Damaged.connect( takeDamage )
	pass # Replace with function body.


#We wanna connect to the damage signal and react to it
func takeDamage( _damage ) -> void:
	queue_free() #one health so it just removes plant
	pass
