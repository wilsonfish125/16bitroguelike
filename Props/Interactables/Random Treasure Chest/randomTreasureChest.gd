class_name RandomTreasureChest extends TreasureChest

@export var itemPool : Array[EquippableItemData] : set = _setItemPool

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return #whenever is below will not run in the editor

func _setItemPool( value : Array[EquippableItemData] ) -> void:
	itemPool = value
