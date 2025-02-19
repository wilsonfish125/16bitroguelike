@tool #this script has a lot going on
class_name TreasureChest extends Node2D

@export var itemData : ItemData : set = _setItemData
@export var quantity : int = 1 : set = _setItemQuantity

var isOpen : bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interactArea : Area2D = $Area2D
@onready var label: Label = $ItemSprite/Label
@onready var persistent_data_is_open: PersistentDataHandler = $PersistentDataIsOpen



func _ready() -> void:
	_updateTexture()
	_updateLabel()
	
	if Engine.is_editor_hint():
		return #whenever is below will not run in the editor
	interactArea.area_entered.connect( _onAreaEnter )
	interactArea.area_exited.connect( _onAreaExit )
	persistent_data_is_open.DataLoaded.connect( setChestState )
	setChestState()
	pass

func playerInteract() -> void:
	#what happens when the player interacts with the chest?
	if isOpen == true:
		return
	isOpen = true
	persistent_data_is_open.setValue() #makes sure we set the save data as soon as player opens
	animation_player.play( "opening" )
	if itemData and quantity > 0:
		PlayerManager.INVENTORYDATA.addItem( itemData, quantity ) #works with existing inv scripts
	else:
		printerr("u fucked up")
	pass


func _onAreaEnter( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.connect( playerInteract )
	pass

func _onAreaExit( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.disconnect( playerInteract )
	pass



func _setItemData( value : ItemData ) -> void:
	itemData = value
	_updateTexture()
	pass

func _setItemQuantity( value : int ) -> void:
	quantity = value
	_updateLabel()
	pass

func _updateTexture() -> void:
	if itemData and sprite:
		sprite.texture = itemData.texture

func _updateLabel() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )

func setChestState() -> void: #call this from the save data
	isOpen = persistent_data_is_open.value
	if isOpen:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
	pass
