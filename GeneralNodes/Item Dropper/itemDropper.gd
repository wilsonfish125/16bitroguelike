@tool
class_name ItemDropper extends Node2D

signal DropCollected # The item has been picked up and is in player inventory
const PICKUP = preload("res://Items/ItemPickup/itemPickup.tscn")

@export var itemData : ItemData : set = _setItemData

var hasDropped : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var hasDroppedData : PersistentDataHandler = $PersistentDataHandler
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if Engine.is_editor_hint() == true:
		_updateTexture()
		return
	
	sprite.visible = false
	hasDroppedData.DataLoaded.connect( _onDataLoaded )
	_onDataLoaded()

func dropItem() -> void:
	if hasDropped == true:
		return #dont want the player to farm a room for keys
	hasDropped = true #if it hasnt dropped, now it has
	
	var drop = PICKUP.instantiate() as ItemPickup
	drop.itemData = itemData
	add_child( drop )
	drop.pickedUp.connect( _onDropPickup )
	audio.play()


func _onDropPickup() -> void:
	DropCollected.emit()
	hasDroppedData.setValue()

func _onDataLoaded() -> void:
	hasDropped = hasDroppedData.value


func _setItemData( value : ItemData ) -> void:
	itemData = value
	_updateTexture()

func _updateTexture() -> void:
	if Engine.is_editor_hint() == true:
		if itemData and sprite:
			sprite.texture = itemData.texture
