class_name StateCarry extends State

@export var moveSpeed : float = 100.0
@export var throwAudio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: stateIdle = $"../Idle"
@onready var stun: StateStun = $"../Stun"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#What happens when we initialise this state?
func init() -> void:
	pass

# What happens when the player enters this state?
func Enter() -> void:
	player.updateAnimation( "Carry" )
	walking = false
	pass

# What happens when the player exits this state?
func Exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throwDirection = player.cardinalDirection
		else:
			throwable.throwDirection = player.direction
		
		if stateMachine.nextState == stun:
			#DROP THE THROWABLE
			throwable.throwDirection = throwable.throwDirection.rotated( PI )
			throwable.drop()
			pass
		else:
			#THROW THE THROWABLE
			player.audio.stream = throwAudio
			player.audio.play()
			throwable.throw()
			pass
		
		pass
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.updateAnimation( "Carry" )
	elif player.setDirection() or walking == false:
		player.updateAnimation( "CarryWalk" )
		walking = true
	
	player.velocity = player.direction * moveSpeed
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	if _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle #we handle throwing the throwable in the exit function
	return null
