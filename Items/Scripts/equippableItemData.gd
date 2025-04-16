class_name EquippableItemData extends ItemData

enum Type { WEAPON, ARMOUR, AMULET, RING } # Consider another ring slot?
@export var type : Type = Type.WEAPON # type is of type Type xD
@export var modifiers : Array[ EquippableItemModifier ]
