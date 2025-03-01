class_name EnemyStateChase extends EnemyState

@export var animName : String = "Chase"
@export var chaseSpeed : float = 200.0
@export var turnRate : float = 0.25

@export_category("AI")
@export var visionArea : VisionArea
@export var attackArea : HurtBox
@export var stateAggroDuration : float = 0.5
@export var nextState : EnemyState

var _timer : float = 0.0 #smth simple silly variable name will suffice
var _direction : Vector2
var _canSeePlayer : bool = false

# What happens when we initialise this state?
func init()  -> void:
	if visionArea:
		visionArea.player_entered.connect( _onPlayerEnter )
		visionArea.player_exited.connect( _onPlayerExited )
	pass

# What happens when the player enters this state?
func enter() -> void:
	_timer = stateAggroDuration
	enemy.updateAnimation( animName )
	if attackArea:
		attackArea.monitoring = true
	pass

# What happens when the player exits this state?
func exit() -> void:
	if attackArea:
		attackArea.monitoring = false
	_canSeePlayer = false
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func process (_delta : float) -> EnemyState:
	var newDir : Vector2 = enemy.global_position.direction_to( PlayerManager.player.global_position )
	_direction = lerp( _direction, newDir, turnRate )
	enemy.velocity = _direction * chaseSpeed
	if enemy.set_direction( _direction ):
		enemy.updateAnimation( animName )
	
	if _canSeePlayer == false:
		_timer -= _delta
		if _timer < 0:
			return nextState
	else:
			_timer = stateAggroDuration
	return null
	
	

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null

func _onPlayerEnter() -> void:
	_canSeePlayer = true
	if stateMachine.currentState is EnemyStateStun:
		return #prevents weird behavior
	stateMachine.changeState( self )
	pass

func _onPlayerExited() -> void:
	_canSeePlayer = false
	pass
