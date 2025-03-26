@tool
@icon( "res://NPC/Icons/text_bubble.svg" )
class_name DialogueText extends DialogueItem

@export_multiline var text : String = "Placeholder Text" : set = _setText


func _setText( value : String ) -> void:
	text = value
	if Engine.is_editor_hint():
		if exampleDialogue != null:
			_setEditorDisplay()

func _setEditorDisplay() -> void:
	exampleDialogue.setDialogueText( self )
	exampleDialogue.content.visible_characters = -1 #-1 displays all characters regardless of length
