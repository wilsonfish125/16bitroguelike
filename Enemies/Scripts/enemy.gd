class_name Enemy extends CharacterBody2D

signal direction_changed( newDirection : Vector2 ) #Called new_dir because newDirection was taken, need to seperate
signal enemy_damaged( hurtBox : HurtBox ) #anytime enemy takes damage this signal should be emitted
signal enemy_destroy( hurtBox : HurtBox ) #manages enemy behavior when health is zero

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 3

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false #lets prevent some spam cheese

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: hitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
#Confused about sounds? They are done in the animation player dummy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialise( self )
	player = PlayerManager.player
	hit_box.Damaged.connect( _takeDamage ) #connect to private function
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_direction( _newDirection : Vector2 ) -> bool:
	direction = _newDirection
	if direction == Vector2.ZERO:
		return false
	
	var directionID : int = int( round(
		( direction + cardinal_direction * 0.1 ).angle()
		/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[ directionID ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.flip_h = true if cardinal_direction == Vector2.LEFT else false
	return true


#only underscored because we have a classname EnemyState in enemyState.gd
func updateAnimation( _EnemyState : String ) -> void:
	animation_player.play( _EnemyState + animationDirection() )
	pass



func animationDirection() -> String:
	if cardinal_direction == Vector2.DOWN: #underscores for enemies, camelcase for player (might change)
		return "Down"
	elif cardinal_direction == Vector2.UP:
		return "Up"
	elif cardinal_direction == Vector2.LEFT:
			return "Left"
	else:
		return "Horizontal"

func _takeDamage( hurtBox : HurtBox ) -> void: #in the future we can add shit easy by doing hurtBox.xyz
	if invulnerable == true:
		return 
	hp -= hurtBox.damage #Remember the power of passing through classnames to get the whole scripts vars
	PlayerManager.shakeCamera( 1 )
	if hp > 0:
		enemy_damaged.emit( hurtBox ) #states have access to data as we are passing thru hurtbox
	else:
		enemy_destroy.emit( hurtBox )
