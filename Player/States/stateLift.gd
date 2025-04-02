class_name StateLift extends State

@export var liftAudio : AudioStream

@onready var carry : State = $"../Carry"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# What happens when the player enters this state?
func Enter() -> void:
	player.updateAnimation( "Lift" )
	player.animation.animation_finished.connect( stateComplete )
	player.audio.stream = liftAudio
	player.audio.play()
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null

func stateComplete( _a : String ) -> void:
	player.animation.animation_finished.disconnect( stateComplete )
	stateMachine.changeState( carry )
	pass
