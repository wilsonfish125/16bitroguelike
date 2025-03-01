class_name EnemyStateDestroy extends EnemyState

#item logic
const PICKUP = preload("res://Items/ItemPickup/itemPickup.tscn")

@export var animName : String = "Destroy"
@export var knockbackSpeed : float = 200.0
@export var decelerateSpeed : float = 10.0

@export_category("AI")

@export_category("Item Drops")
@export var drops : Array[ DropData ]

var _damagePosition : Vector2
var _direction : Vector2




# What happens when we initialise this state?
func init()  -> void:
	enemy.enemy_destroy.connect( onEnemyDestroyed )
	pass

# What happens when the player enters this state?
func enter() -> void:
	enemy.invulnerable = true
	disableHurtBox() #player cant get damaged after dickhead is killed
	
	_direction = enemy.global_position.direction_to( _damagePosition )
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockbackSpeed * 2 #negative to oppose motion
	enemy.updateAnimation( animName )
	enemy.animation_player.animation_finished.connect( _onAnimationFinished )
	dropItems()
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# Returns a state for ease of processing, either returns null or a state we can use for animation
# What happens during the _process update in this state?
func process (_delta : float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerateSpeed * _delta
	return null

# What happens during the _physics_process update in this state?
func physics( _delta : float) -> EnemyState:
	return null

func onEnemyDestroyed( hurt_box : HurtBox ) -> void:
	_damagePosition = hurt_box.global_position
	stateMachine.changeState( self ) #if we get destroyed signal, we set the state as destroy

func _onAnimationFinished( _a : String ) -> void:
	enemy.queue_free()
	pass

func disableHurtBox() -> void:
	var hurtBox : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurtBox != null:
		hurtBox.monitorable = false

#create a function to drop the items
func dropItems() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue #yay null states or empty item slots just get ignored!
		var dropCount : int = drops[ i ].getDropCount() #function in dropdata!
		for j in dropCount:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup #cast it to a node doofus
			drop.itemData = drops[ i ].item #whatever item we assign in the resource
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9, 1.5 )
		
		
	
	pass
	
