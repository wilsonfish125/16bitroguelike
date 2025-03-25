@tool
@icon( "res://NPC/Icons/answer_bubble.svg" )
class_name DialogueBranch extends DialogueItem


@export var text : String = "ok.."

var dialogueItems : Array[ DialogueItem ]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	
	for c in get_children():
		if c is DialogueItem:
			dialogueItems.append( c )
		
	
