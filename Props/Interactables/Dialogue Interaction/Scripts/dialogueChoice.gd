@tool
@icon( "res://NPC/Icons/question_bubble.svg" )
class_name DialogueChoice extends DialogueItem

var dialogueBranches : Array[ DialogueBranch ]


func _ready() -> void:
	super() #do whatever the class i am extending does
	for c in get_children():
		if c is DialogueBranch:
			dialogueBranches.append( c )

func _setEditorDisplay() -> void:
	#Set the text based on related DialogueText node
	setRelatedText()
	
	#Then we set the choice buttons
	if dialogueBranches.size() < 2:
		return
	exampleDialogue.setDialogueChoice( self )

func setRelatedText() -> void:
	#find the related sibling 
	var _p = get_parent()
	var _t = _p.get_child( self.get_index() - 1 )
	
	#now we set text based on related sibling
	if _t is DialogueText:
		exampleDialogue.setDialogueText( _t )
		exampleDialogue.content.visible_characters = -1

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
