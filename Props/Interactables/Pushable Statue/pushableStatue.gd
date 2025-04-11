class_name PushableStatue extends RigidBody2D

@export var pushSpeed : float = 90.0
@export var persistent : bool = false
@export var persistentLocation : Vector2 = Vector2.ZERO
@export var targetLocationSize : Vector2 = Vector2( 4, 4 ) #half the 8x8 collision shape

var pushDirection : Vector2 = Vector2.ZERO : set = _setPush
var onTarget : bool = false

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_data_handler: PersistentDataHandler = $OnTarget

# Set the location of the statue if saved
func _ready() -> void:
	if persistent_data_handler.value == true:
		# Statue is in the target location
		position = persistentLocation
	pass

#since this is a rigidbody lets move it with physics as intended
func _physics_process( _delta: float ) -> void:
	linear_velocity = pushDirection * pushSpeed
	if persistent:
		# We are gonna save/load the statues position so you cannot get locked out
		# Check both x and y coords, BOTH need to be in the area to prevent weird stuff
		var xIsOn : bool = abs( position.x - persistentLocation.x ) < 15 + targetLocationSize.x
		var yIsOn : bool = abs( position.y - persistentLocation.y ) < 6 + targetLocationSize.y
		# If both of these are true, the statue is in the area we want to save it
		if xIsOn and yIsOn and onTarget == false:
			onTarget = true
			# Arrived on Target, save persistent data
			persistent_data_handler.setValue()
		elif ( xIsOn == false or yIsOn == false ) and onTarget == true:
			onTarget = false
			# Pushed off of target, remove persistent data
			persistent_data_handler.removeValue()



func _setPush( value : Vector2 ) -> void:
	pushDirection = value
	if pushDirection == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
