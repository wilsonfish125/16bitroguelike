@tool
class_name ItemPickup extends CharacterBody2D
#manages the pickup-appble item scene, just assign this scene with script one of our item resources

signal pickedUp

@export var itemData : ItemData : set = _setItemData
@export var itemCount : int = 1 : set = _setItemCount

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var count_label: Label = %CountLabel


func _ready() -> void:
	_updateTexture()
	_updateCountLabel()
	
	if Engine.is_editor_hint():
		return #anything below this point only happens when the game is running
	
	area_2d.body_entered.connect( _onBodyEntered )

#functions for drop velocity, hence characterbody root node
func _physics_process(delta: float) -> void:
	var collisionInfo = move_and_collide( velocity * delta )
	if collisionInfo:
		velocity = velocity.bounce( collisionInfo.get_normal() ) #yay for godot functions
	velocity -= velocity * delta * 4



#call this anytime enters the colision shape
func _onBodyEntered( b ) -> void:
	if b is Player:
		if itemData:
			# Check here to see if important items are of a specific type
			if itemData.name == "Coin":
				PlayerManager.player.coins += itemCount
				itemPickedUp()
			elif itemData.name == "Shard":
				PlayerManager.shards += itemCount
				itemPickedUp()
			elif PlayerManager.INVENTORYDATA.addItem( itemData, itemCount ):
				itemPickedUp()
	pass

func itemPickedUp() -> void:
	area_2d.body_entered.disconnect( _onBodyEntered )
	audio_stream_player_2d.play()
	visible = false
	pickedUp.emit()
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _setItemData( value : ItemData ) -> void:
	itemData = value
	_updateTexture()

func _updateTexture() -> void:
	if itemData and sprite_2d:
		sprite_2d.texture = itemData.texture

func _setItemCount( value : int ) -> void:
	itemCount = value
	_updateCountLabel()

func _updateCountLabel() -> void:
	if itemData and count_label:
		count_label.text = ""
		if itemCount > 1:
			count_label.text = str( itemCount )
	pass
