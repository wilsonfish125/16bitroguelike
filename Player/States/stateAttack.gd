class_name stateAttack extends State

var attacking : bool = false

@export var attackSound : AudioStream
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var walk: stateWalk = $"../Walk"
@onready var idle: stateIdle = $"../Idle"
@onready var weapon_sprite_2d: Sprite2D = $"../../Sprite2D/WeaponSprite2D"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"


# What happens when the player enters this state?
func Enter() -> void:
	player.updateAnimation("Attack")
	#do some spin attack shit with an if statemecnt checking if prev state was  charging
	
	if player.cardinalDirection == Vector2.LEFT:
		player.leftAttack = true 
	animation_player.animation_finished.connect(endAttack) #When the anim player is done then we remove the state
	#We need to set and play the sound every time, set through script
	audio.stream = attackSound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	if attacking: #added later on, in rare instance in frame perfect stuff we wanna check for attacking
		hurt_box.monitoring = true
	pass

# What happens when the player exits this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect( endAttack )
	weapon_sprite_2d.visible = false
	attacking = false
	
	hurt_box.monitoring = false
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	player.velocity = Vector2.ZERO #if you somehow move in the attack state your velocity remains zero
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null


func endAttack( _newAnimationName : String ) -> void:
	attacking = false
