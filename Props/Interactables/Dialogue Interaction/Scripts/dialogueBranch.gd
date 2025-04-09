@tool
@icon( "res://NPC/Icons/answer_bubble.svg" )
class_name DialogueBranch extends DialogueItem

signal Selected

@export var text : String = "ok.." : set = _setText

var dialogueItems : Array[ DialogueItem ]



func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		return
	
	
	for c in get_children():
		if c is DialogueItem:
			dialogueItems.append( c )
		
	

func _setEditorDisplay() -> void:
	var _p = get_parent()
	if _p is DialogueChoice:
		#display related text
		setRelatedText()
		if _p.dialogueBranches.size() < 2:
			return
		exampleDialogue.setDialogueChoice( _p as DialogueChoice )
		#display parent dialogue choice
		

func setRelatedText() -> void:
	#find the related sibling 
	var _p = get_parent()
	var _p2 = _p.get_parent()
	var _t = _p2.get_child( _p.get_index() - 1 )
	
	#now we set text based on related sibling
	if _t is DialogueText:
		exampleDialogue.setDialogueText( _t )
		exampleDialogue.content.visible_characters = -1

#this is just for updating text dynamically in the editor
func _setText( value : String ) -> void:
	text = value
	if Engine.is_editor_hint():
		if exampleDialogue != null:
			_setEditorDisplay()
