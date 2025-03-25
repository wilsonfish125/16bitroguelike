@tool
@icon( "res://NPC/Icons/star_bubble.svg" )
class_name DialogueSystemNode extends CanvasLayer #referenced in global script as DialogueSystem so we dont wanna confuse class names

signal Finished
signal LetterAdded( letter : String )

var isActive : bool = false
var textInProgress : bool = false #is the text typing out on the screen?
var waitingForChoice : bool = false #not ideal but i doubt this is gonna get much more complex

var textSpeed : float = 0.02
var textLength : int = 0
var plainText : String

var dialogueItems : Array[ DialogueItem ]
var dialogueItemsIndex : int = 0

@onready var dialogue_ui : Control = $DialogueUI
@onready var content : RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var name_label : Label = $DialogueUI/NameLabel
@onready var portrait_sprite : DialoguePortrait = $DialogueUI/PortraitSprite
@onready var dialogue_progress_indicator : PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label : Label = $DialogueUI/DialogueProgressIndicator/Label
@onready var timer : Timer = $DialogueUI/Timer
@onready var audio : AudioStreamPlayer = $DialogueUI/AudioStreamPlayer
@onready var choiceOptions : VBoxContainer = $DialogueUI/VBoxContainer


func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window: #program will crash without this
			get_parent().remove_child( self )
			return
		return
	timer.timeout.connect( _onTimerTimeout )
	hideDialogue()

#handling key presses here
func _unhandled_input( event : InputEvent ) -> void:
	if isActive == false:
		return
	if(
			event.is_action_pressed("interact") or 
			event.is_action_pressed("attack") or
			event.is_action_pressed("ui_accept")
	):
		if textInProgress == true:
			content.visible_characters = textLength
			timer.stop() #epic memory leak prevent
			textInProgress = false
			showDialogueButtonIndicator( true )
			return
		elif waitingForChoice == true:
			return
		
		dialogueItemsIndex += 1
		if dialogueItemsIndex < dialogueItems.size():
			startDialogue()
		else:
			hideDialogue()

#Shows the dialogue UI
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
	choiceOptions.visible = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED #Disabling the DIALOGUE UI NODE not the root node
	get_tree().paused = false
	Finished.emit()

#selects which piece of dialogue to select and puts it in the panelcontainer
func startDialogue() -> void:
	waitingForChoice = false #by default, there is no choice for dialogue
	showDialogueButtonIndicator( false )
	var _d : DialogueItem = dialogueItems[ dialogueItemsIndex ]
	
	if _d is DialogueText:
		setDialogueText( _d as DialogueText )
	elif _d is DialogueChoice:
		setDialogueChoice( _d as DialogueChoice )
	

#setting dialogue text based on dialogue item parameters
#once set, start text typing timer to sync with portraitsprite
func setDialogueText( _d : DialogueText ):
	content.text = _d.text
	name_label.text = _d.npcInfo.npcName
	portrait_sprite.texture = _d.npcInfo.portrait
	portrait_sprite.audioPitchBase = _d.npcInfo.dialogueAudioPitch
	content.visible_characters = 0
	textLength = content.get_total_character_count() #we love godot inbuilt methods
	plainText = content.get_parsed_text()
	textInProgress = true
	startTimer()

#setting dialogue choice based on passed in parameters
func setDialogueChoice( _d : DialogueChoice ):
	choiceOptions.visible = true
	waitingForChoice = true
	for c in choiceOptions.get_children():
		c.queue_free() #gets rid of old buttons
	#loop through our array to create new buttons!
	for i in _d.dialogueBranches.size():
		var _newChoice : Button = Button.new()
		_newChoice.text = _d.dialogueBranches[i].text
		_newChoice.pressed.connect( _dialogueChoiceSelected.bind( _d.dialogueBranches[i] ) ) #bind allows us to pass another parameter
		choiceOptions.add_child( _newChoice )
	
	await get_tree().process_frame
	choiceOptions.get_child( 0 ).grab_focus()


func _dialogueChoiceSelected( _d : DialogueBranch ) -> void:
	choiceOptions.visible = false
	showDialogue( _d.dialogueItems )
	

func _onTimerTimeout() -> void:
	content.visible_characters += 1
	if content.visible_characters <= textLength:
		LetterAdded.emit( plainText[ content.visible_characters - 1 ] )
		startTimer()
	else:
		showDialogueButtonIndicator( true )
		textInProgress = false

func showDialogueButtonIndicator( _isVisible : bool ) -> void:
	dialogue_progress_indicator.visible = _isVisible
	if dialogueItemsIndex + 1 < dialogueItems.size():
		dialogue_progress_indicator_label.text = "NEXT"
	else:
		dialogue_progress_indicator_label.text = "END"

func startTimer() -> void:
	timer.wait_time = textSpeed
	# Manipulate wait time depending on character
	var _char = plainText[ content.visible_characters - 1 ]
	if '.?!:;'.contains( _char ):
		timer.wait_time *= 4
	elif ', '.contains( _char ):
		timer.wait_time *= 2
	timer.start()
