class_name EnemyStateStun extends EnemyState

@export var animName : String = "Stun"
@export var knockbackSpeed : float = 200.0
@export var decelerateSpeed : float = 10.0

@export_category("AI")
@export var nextState : EnemyState

var _damagePosition : Vector2
var _direction : Vector2
var _animationFinished : bool = false

# What happens when we initialise this state?
func init()  -> void:
	enemy.enemy_damaged.connect( onEnemyDamaged )
	pass

# What happens when the player enters this state?
func enter() -> void:
	enemy.invulnerable = true
	_animationFinished = false
	
	_direction = enemy.global_position.direction_to( _damagePosition )
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockbackSpeed * 2 #negative to oppose motion
	enemy.updateAnimation( animName )
	enemy.animation_player.animation_finished.connect( _onAnimationFinished )
	
	pass

# What happens when the player exits this state?
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _onAnimationFinished )
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func process (_delta : float) -> EnemyState:
	if _animationFinished == true:
		return nextState
	enemy.velocity -= enemy.velocity * decelerateSpeed * _delta
	return null

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null

func onEnemyDamaged( hurtBox : HurtBox ) -> void:
	_damagePosition = hurtBox.global_position #hitbox and damage is no longer based off the player position, instead the position of the hurtbox
	stateMachine.changeState( self ) #if we get enemydamaged signal, we set the state as stun

func _onAnimationFinished( _a : String ) -> void:
	_animationFinished = true
	pass
