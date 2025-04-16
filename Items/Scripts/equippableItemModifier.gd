class_name EquippableItemModifier extends Resource

enum Type { HEALTH, ATTACK, DEFENSE, BODY, SPEED } # Go nuts here do lots
@export var type : Type = Type.HEALTH
@export var value : int = 1
