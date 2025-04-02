class_name Throwable extends Area2D

@export var gravityStrength : float = 980
@export var throwSpeed : float = 400
@export var throwHeightStrength : float = 100
@export var throwStartingHeight : float = 49



var pickedUp : bool = false
var throwable : Node2D #a reference to the parent node which we are throwing
var throwDirection : Vector2

var objectSprite : Sprite2D
var verticalVelocity : float = 0
var groundHeight : float = 0 #where the object hits the ground
var animationPlayer : AnimationPlayer

@onready var hurt_box : HurtBox = $HurtBox

func _ready() -> void:
	area_entered.connect( _onAreaEnter )
	area_exited.connect( _onAreaExit )
	throwable = get_parent()
	setupHurtBox()
	
	objectSprite = throwable.find_child( "Sprite2D" ) #findchild is more process intensive but flexible
	groundHeight = objectSprite.position.y
	animationPlayer = throwable.find_child( "AnimationPlayer" ) 
	
	set_physics_process( false )


#we only run this once the pot has been thrown
func _physics_process( delta: float ) -> void:
	#move the whole throwable object 
	objectSprite.position.y += verticalVelocity * delta
	#check to see if sprite has hit "ground" then destroy
	if objectSprite.position.y >= groundHeight:
		destroy()
	verticalVelocity += gravityStrength * delta
	throwable.position += throwDirection * throwSpeed * delta

func playerInteract() -> void:
	#Pickup one throwable object ONLY, known bug
	if PlayerManager.interactHandled == true:
		return
	if pickedUp == false:
		PlayerManager.interactHandled = true
		#PICKUP THROWABLE OBJECT
		disableCollisions( throwable )
		if throwable.get_parent():
			throwable.get_parent().remove_child( throwable )
		PlayerManager.player.held_item.add_child( throwable )
		throwable.position = Vector2.ZERO #prevents known bug where pot factors in global position
		PlayerManager.player.pickupItem( self )
		area_entered.disconnect( _onAreaEnter )
		area_exited.disconnect( _onAreaExit )
		pass
	
	pass

func throw() -> void:
	#Initiate the entire object throwing process, remove from player and give a velocity
	throwable.get_parent().remove_child( throwable )
	PlayerManager.player.get_parent().call_deferred( "add_child", throwable ) #adds a 1f delay
	throwable.position = PlayerManager.player.position #both have the same parent so no globalposition
	objectSprite.position.y = -throwStartingHeight #in y, negative is up
	verticalVelocity = -throwHeightStrength
	# Enable Physics
	set_physics_process( true )
	# Enable Hurtbox
	hurt_box.set_deferred( "monitoring", true )
	hurt_box.didDamage.connect( destroy )

func drop() -> void:
	throwable.get_parent().remove_child( throwable )
	PlayerManager.player.get_parent().call_deferred( "add_child", throwable )
	throwable.position = PlayerManager.player.position
	objectSprite.position.y = -50
	verticalVelocity = -200
	throwSpeed = 100
	
	set_physics_process( true )

func destroy() -> void:
	set_physics_process( false )
	if animationPlayer:
		animationPlayer.play( "destroy" )
		await animationPlayer.animation_finished
	throwable.queue_free()


#this function is puzzling but it works!
func disableCollisions( _node : Node ) -> void:
	for c in _node.get_children():
		if c == self:
			continue #skip and move on in the tree loop
		if c is CollisionShape2D:
			c.disabled = true
		else:
			disableCollisions( c ) #wooooah epic loop through the entire scene tree

func _onAreaEnter( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.connect( playerInteract )
	pass

func _onAreaExit( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.disconnect( playerInteract )
	pass

func setupHurtBox() -> void:
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col : CollisionShape2D = c.duplicate() #dupe the shape of the parent for the throwable
			hurt_box.add_child( _col )
			_col.debug_color = Color( 1, 0, 0, 0.5 )
