class_name Room extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS}

@export var type : Type
@export var row : int
@export var column : int
@export var position : Vector2
@export var nextRooms : Array[Room]
@export var selected := false


func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
