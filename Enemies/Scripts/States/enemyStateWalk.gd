#more of a wander than a walk
class_name EnemyStateWalk extends EnemyState

@export var animName : String = "Run"
@export var walkSpeed : float = 100.0

@export_category("AI")
@export var stateAnimationDuration : float = 0.5
@export var stateCyclesMin : int = 1
@export var stateCyclesMax : int = 3
@export var nextState : EnemyState

var _timer : float = 0.0 #smth simple silly variable name will suffice
var _direction : Vector2

# What happens when we initialise this state?
func init()  -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	_timer = randi_range( stateCyclesMin, stateCyclesMax ) * stateAnimationDuration
	var rand = randi_range( 0, 3 )
	_direction = enemy.DIR_4[ rand ] #Enemy wanders, we pull a random direction to walk in for a multiple of time
	enemy.velocity = _direction * walkSpeed
	enemy.set_direction( _direction )
	enemy.updateAnimation( animName )
	
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func process (_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer < 0:
		return nextState
	return null
	

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null
