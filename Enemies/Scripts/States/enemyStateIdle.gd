class_name EnemyStateIdle extends EnemyState

@export var animName : String = "Idle"

@export_category("AI")
@export var stateDirectionMin : float = 0.5
@export var stateDirectionMax : float = 1.5
@export var afterIdleState : EnemyState

var _timer : float = 0.0 #smth simple silly variable name will suffice




# What happens when we initialise this state?
func init()  -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range( stateDirectionMin, stateDirectionMax )
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
		return afterIdleState #we will assign this in script
	return null

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null
