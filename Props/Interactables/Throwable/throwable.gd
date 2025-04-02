class_name Throwable extends Area2D

@export var gravityStrength : float = 980
@export var throwSpeed : float = 400
@export var throwHeightStrength : float = 100
@export var throwStartingHeight : float = 49

var pickedUp : bool = false
var throwable : Node2D #a reference to the parent node which we are throwing

@onready var hurt_box : HurtBox = $HurtBox

func _ready() -> void:
	area_entered.connect( _onAreaEnter )
	area_exited.connect( _onAreaExit )
	throwable = get_parent()
	setupHurtBox()

func playerInteract() -> void:
	#Pickup one throwable object ONLY, known bug
	
	if pickedUp == false:
		#PICKUP THROWABLE OBJECT
		pass
	
	pass

func _onAreaEnter( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.connect( playerInteract )
	pass

func _onAreaExit( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.disconnect( playerInteract )
	pass

func setupHurtBox() -> void:
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col : CollisionShape2D = c.duplicate() #dupe the shape of the parent for the throwable
			hurt_box.add_child( _col )
			_col.debug_color = Color( 1, 0, 0, 0.5 )
