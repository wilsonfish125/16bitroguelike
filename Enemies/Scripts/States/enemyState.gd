class_name EnemyState extends Node

#Store a reference to the enemy and the state it belongs to
var enemy : Enemy #If these were static it would fuck up the machine
var stateMachine : EnemyStateMachine


# What happens when we initialise this state?
func init()  -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func process (_delta : float) -> EnemyState:
	return null

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null
