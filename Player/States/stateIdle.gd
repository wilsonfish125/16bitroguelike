class_name stateIdle extends State

@onready var walk: stateWalk = $"../Walk"
@onready var attack: stateAttack = $"../Attack"
@onready var weapon_sprite_2d: Sprite2D = $"../../Sprite2D/WeaponSprite2D"


# What happens when the player enters this state?
func Enter() -> void:
	player.updateAnimation("Idle")
	weapon_sprite_2d.visible = false
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk #the power of returning states!
	#each state should note velocity in case of overlap, idle velocity zero takes precendence 
	player.velocity = Vector2.ZERO #if you somehow move in the idle state your velocity remains zero
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.InteractPressed.emit()
	return null
