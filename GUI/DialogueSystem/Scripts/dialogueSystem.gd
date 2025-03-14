@tool
@icon( "res://NPC/Icons/star_bubble.svg" )
class_name DialogueSystemNode extends CanvasLayer #referenced in global script as DialogueSystem so we dont wanna confuse class names


var isActive : bool = false

@onready var dialogue_ui : Control = $DialogueUI


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window: #program will crash without this
			get_parent().remove_child( self )
			return
		return
	hideDialogue()

func _unhandled_input( event : InputEvent ) -> void:
	#if isActive == false:
		#return
	if event.is_action_pressed( "test" ):
		if isActive == false:
			showDialogue()
		else:
			hideDialogue()

func showDialogue() -> void:
	isActive = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func hideDialogue() -> void:
	isActive = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED #Disabling the DIALOGUE UI NODE not the root node
	get_tree().paused = false
