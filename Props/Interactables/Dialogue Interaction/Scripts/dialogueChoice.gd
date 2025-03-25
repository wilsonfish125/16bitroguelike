@tool
@icon( "res://NPC/Icons/question_bubble.svg" )
class_name DialogueChoice extends DialogueItem

var dialogueBranches : Array[ DialogueBranch ]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogueBranch:
			dialogueBranches.append( c )


func _get_configuration_warnings() -> PackedStringArray:
	if _checkForDialogueBranches() == false:
		return ["Requires at least 2 DialogueBranch Nodes."]
	else:
		return []
	

func _checkForDialogueBranches() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogueBranch:
			_count += 1
			if _count > 1:
				return true
	return false
