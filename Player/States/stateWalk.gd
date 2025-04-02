class_name stateWalk extends State

#Since we removed it from player we set move speed in the state of movement
@export var moveSpeed : float = 300.0

@onready var idle: stateIdle = $"../Idle"
@onready var attack: stateAttack = $"../Attack"
@onready var weapon_sprite_2d: Sprite2D = $"../../Sprite2D/WeaponSprite2D"

# What happens when the player enters this state?
func Enter() -> void:
	player.updateAnimation("Run")
	weapon_sprite_2d.visible = false
	pass

# What happens when the player exits this state?
func Exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func Process (_delta : float) -> State:
	#each state should note velocity/direction in case of overlap 
	if player.direction == Vector2.ZERO:
		return idle #look at how we can return state values!
	
	player.velocity = player.direction * moveSpeed
	
	if player.setDirection():
		player.updateAnimation("Run")
	return null

# What happens during the _physics_process update in this state?
func Physics( _delta : float) -> State:
	return null

# What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact()
	return null
