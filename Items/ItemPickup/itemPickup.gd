@tool
class_name ItemPickup extends CharacterBody2D
#manages the pickup-appble item scene, just assign this scene with script one of our item resources

@export var itemData : ItemData : set = _setItemData

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	_updateTexture()
	
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
			if PlayerManager.INVENTORYDATA.addItem( itemData ):
				itemPickedUp()
	pass

func itemPickedUp() -> void:
	area_2d.body_entered.disconnect( _onBodyEntered )
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _setItemData( value : ItemData ) -> void:
	itemData = value
	_updateTexture()
	pass

func _updateTexture() -> void:
	if itemData and sprite_2d:
		sprite_2d.texture = itemData.texture
	pass
