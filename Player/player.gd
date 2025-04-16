class_name Player extends CharacterBody2D

#Movement/Attack Vars
var cardinalDirection : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var leftAttack: bool = false

#Damage Manager Vars
var invulnerable : bool = false
var hp : int = 6
var maxHP : int = 6

var level : int = 1
var xp : int = 0

var attackStat : int = 1 :
	set( v ):
		attackStat = v
		updateDamageValues()

var defenceStat : int = 1
var defenseBonus : int = 0

var bodyStat : int = 1
var skillTreePoints : int = 0

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D
@onready var weapon_sprite_2d: Sprite2D = $Sprite2D/WeaponSprite2D #Not the most elegant solution but it works!

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: hitBox = $Interactions/HitBox
@onready var audio : AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D

@onready var lift: StateLift = $StateMachine/Lift
@onready var held_item: Node2D = $Sprite2D/HeldItem
@onready var carry: StateCarry = $StateMachine/Carry


signal DirectionChanged( newDirection : Vector2 )
signal PlayerDamaged( hurtBox : HurtBox )

func _ready():
	PlayerManager.player = self
	state_machine.initialise(self)
	hit_box.Damaged.connect( _takeDamage )
	updateHP(99)
	updateDamageValues()
	PlayerManager.PlayerLevelUp.connect( _onPlayerLevelUp )
	PlayerManager.INVENTORYDATA.EquipmentChanged.connect( _onEquipmentChanged )

func _process(_delta: float):
	
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Remember, no states in player input. You will end up with if statement hell


func _physics_process(_delta: float) -> void:
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		PlayerManager.shakeCamera()

func setDirection() -> bool:
	var newDirection : Vector2 = cardinalDirection
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		newDirection = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		newDirection = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if newDirection == cardinalDirection:
		return false
	
	cardinalDirection = newDirection
	DirectionChanged.emit( newDirection ) #this can come in handy later
	sprite.flip_h = true if cardinalDirection == Vector2.LEFT else false
	return true


func updateAnimation( state : String ) -> void:
	animation.play("player" + state + animationDirection())
	pass


func animationDirection() -> String:
	if cardinalDirection == Vector2.DOWN:
		return "Down"
	elif cardinalDirection == Vector2.UP:
		return "Up"
	elif cardinalDirection == Vector2.LEFT:
			return "Left"
	else:
		return "Horizontal"

func _takeDamage( hurtBox : HurtBox ) -> void:
	if invulnerable == true:
		return
	var dmg : int = hurtBox.damage
	if hp > 0:
		if dmg > 0:
			dmg = clampi( dmg - defenceStat - defenseBonus , 1, dmg )
		updateHP( -hurtBox.damage )
		PlayerDamaged.emit( hurtBox )
	else:
		PlayerDamaged.emit( hurtBox )
		updateHP( 99) #player never dies



func updateHP( delta : int ) -> void:
	hp = clampi( hp + delta, 0, maxHP ) #cant get healed greater than max hp, cant go lower than 0
	PlayerHud.updateHP( hp, maxHP )
	pass


func makeInvulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	#these need to be reset after the duration
	
	await get_tree().create_timer( _duration ).timeout #create a timer, when it runs out, continue function
	
	invulnerable = false
	hit_box.monitoring = true
	pass

func pickupItem( _t : Throwable ) -> void:
	state_machine.changeState( lift )
	# store throwable object so we have a reference
	carry.throwable = _t

func updateDamageValues() -> void:
	# Must now be calculated based on equipment
	var damageValue : int = attackStat + PlayerManager.INVENTORYDATA.getAttackBonus()
	
	$Interactions/HurtBox.damage = damageValue

func _onPlayerLevelUp() -> void:
	effect_animation_player.play( "levelUp" )
	updateHP( 99 )

func _onEquipmentChanged() -> void:
	updateDamageValues()
	defenseBonus = PlayerManager.INVENTORYDATA.getDefenseBonus()
