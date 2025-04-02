class_name StateStun extends State

@export var knockbackSpeed : float = 200.0
@export var decelerateSpeed : float = 10.0
@export var invulnerableDuration : float = 1.0

var hurtBox : HurtBox
var direction : Vector2

var nextState : State = null

@onready var idle: stateIdle = $"../Idle"

@onready var weapon_sprite_2d: Sprite2D = $"../../Sprite2D/WeaponSprite2D"


func init() -> void:
	player.PlayerDamaged.connect( _playerDamaged )


# What happens when the player enters this state?
func Enter() -> void:
	player.animation.animation_finished.connect( _animationFinished )
	weapon_sprite_2d.visible = false
	
	
	direction = player.global_position.direction_to( hurtBox.global_position )
	player.velocity = direction * -knockbackSpeed
	player.setDirection() #after changing movement call setdirection
	player.updateAnimation("Stun")
	player.makeInvulnerable( invulnerableDuration ) 
	player.effect_animation_player.play("damaged")
	PlayerManager.shakeCamera( hurtBox.damage )
	pass

# What happens when the player exits this state?
func Exit() -> void:
	nextState = null
	player.animation.animation_finished.disconnect( _animationFinished )
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	player.velocity -= player.velocity * decelerateSpeed * _delta
	return nextState

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null

func _playerDamaged( _hurtBox : HurtBox) -> void:
	hurtBox = _hurtBox
	stateMachine.changeState( self ) #similar to enemy
	pass

func _animationFinished( _a : String ) -> void:
	nextState = idle
	pass
