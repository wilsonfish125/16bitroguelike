class_name DamageText extends Node2D

var travelDistance : Vector2 = Vector2( 10, -20 )


func start( _text : String, _pos : Vector2 ) -> void:
	$Label.text = _text
	global_position = _pos
	
	# Animate the node with randomness + a tween
	travelDistance.y *= randf_range( 0.5, 1.5 )
	travelDistance.x *= randf_range( -1.5, 1.5 )
	var duration : float = randf_range( 0.75, 1.25 )
	var tween : Tween = create_tween().set_parallel( true )
	# We can animate Tweens like animating animations
	tween.set_ease( Tween.EASE_OUT )
	tween.set_trans( Tween.TRANS_QUAD )
	
	# Tween Positition 
	tween.tween_property( self, "global_position", global_position + travelDistance, duration )
	
	# Tween Modulate
	tween.tween_property( self, "modulate", Color( 1, 1, 1, 0 ), duration ).set_ease( Tween.EASE_IN )
	
	# Queue Free the node
	tween.chain().tween_callback( self.queue_free )
