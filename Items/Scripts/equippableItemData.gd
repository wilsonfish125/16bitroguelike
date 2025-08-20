class_name EquippableItemData extends ItemData

enum Type { WEAPON, HELMET, ARMOUR, BOOTS, AMULET, RING }
@export var type : Type = Type.WEAPON # type is of type Type xD
@export var modifiers : Array[ EquippableItemModifier ]
