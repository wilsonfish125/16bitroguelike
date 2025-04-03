class_name HurtBox extends Area2D

signal didDamage

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect( areaEntered ) #Not to be confused with signal just a fucking stupid func name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func areaEntered( a : Area2D ) -> void:
	if a is hitBox: #This is why classnames and statictype are important! Only way to target in if statement like this
		didDamage.emit()
		a.takeDamage( self )
	pass
