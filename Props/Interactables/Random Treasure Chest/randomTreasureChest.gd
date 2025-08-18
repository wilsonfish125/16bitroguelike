class_name RandomTreasureChest extends TreasureChest

var itemPool : Array[EquippableItemData] = ItemManager.defaultPool

func _ready() -> void:
	if Engine.is_editor_hint():
		return #whenever is below will not run in the editor
	_setItemData(null)
	super()
	

func _setItemData( value : ItemData ) -> void:
	itemData = itemPool.pick_random()
	_updateTexture()
