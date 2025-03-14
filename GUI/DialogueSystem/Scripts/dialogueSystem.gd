@tool
@icon( "res://NPC/Icons/star_bubble.svg" )
class_name DialogueSystemNode extends CanvasLayer #referenced in global script as DialogueSystem so we dont wanna confuse class names

signal Finished

var isActive : bool = false

var dialogueItems : Array[ DialogueItem ]
var dialogueItemsIndex : int = 0

@onready var dialogue_ui : Control = $DialogueUI
@onready var content : RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogueUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogueUI/PortraitSprite
@onready var dialogue_progress_indicator: PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label: Label = $DialogueUI/DialogueProgressIndicator/Label


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window: #program will crash without this
			get_parent().remove_child( self )
			return
		return
	hideDialogue()

func _unhandled_input( event : InputEvent ) -> void:
	if isActive == false:
		return
	if(
			event.is_action_pressed("interact") or 
			event.is_action_pressed("attack") or
			event.is_action_pressed("ui_accept")
	):
		dialogueItemsIndex += 1
		if dialogueItemsIndex < dialogueItems.size():
			startDialogue()
		else:
			hideDialogue()


func showDialogue( _items : Array[ DialogueItem ] ) -> void:
	isActive = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogueItems = _items
	dialogueItemsIndex = 0
	get_tree().paused = true
	await get_tree().process_frame #await a tick since we execute lots at once
	startDialogue()

func hideDialogue() -> void:
	isActive = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED #Disabling the DIALOGUE UI NODE not the root node
	get_tree().paused = false
	Finished.emit()

func startDialogue() -> void:
	showDialogueButtonIndicator( true )
	var _d : DialogueItem = dialogueItems[ dialogueItemsIndex ]
	setDialogueData( _d )

func setDialogueData( _d : DialogueItem ):
	if _d is DialogueText:
		content.text = _d.text
	name_label.text = _d.npcInfo.npcName
	portrait_sprite.texture = _d.npcInfo.portrait

func showDialogueButtonIndicator( _isVisible : bool ) -> void:
	dialogue_progress_indicator.visible = _isVisible
	if dialogueItemsIndex + 1 < dialogueItems.size():
		dialogue_progress_indicator_label.text = "NEXT"
	else:
		dialogue_progress_indicator_label.text = "END"
