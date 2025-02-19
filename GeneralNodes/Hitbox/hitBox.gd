class_name hitBox extends Area2D

#Needs to be able to notify parent entity of damage
signal Damaged( hurtBox : HurtBox ) #Pass a reference to the hurtbox class to avoid shit getting complicated
#Passes through all vars and stuff in the hurtBox script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func takeDamage( hurtBox : HurtBox ) -> void:
	Damaged.emit( hurtBox )
