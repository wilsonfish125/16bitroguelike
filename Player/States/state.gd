#Acts as a blueprint for all other states, they must all fit this criteria
class_name State extends Node

# Stores a reference to the player this state belongs to
static var player : Player #Static variable avaliable to all other scripts in node tree
static var stateMachine : PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#What happens when we initialise this state?
func init() -> void:
	pass

# What happens when the player enters this state?
func Enter() -> void:
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null
