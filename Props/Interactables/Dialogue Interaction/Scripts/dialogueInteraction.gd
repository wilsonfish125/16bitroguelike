@tool
@icon( "res://NPC/Icons/chat_bubbles.svg" )
class_name DialogueInteraction extends Area2D

signal PlayerInteracted
signal Finished

@export var enabled : bool = true

var dialogueItems : Array[ DialogueItem ] #anything that extends dialogueitem can be added

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_entered.connect( _onAreaEntered )
	area_exited.connect( _onAreaExited )
	
	for c in get_children():
		if c is DialogueItem:
			dialogueItems.append( c )
	

func playerInteract() -> void:
	PlayerInteracted.emit()
	await get_tree().process_frame
	await get_tree().process_frame #wait twice
	DialogueSystem.showDialogue( dialogueItems )
	DialogueSystem.Finished.connect( _onDialogueFinished )
	pass

func _onAreaEntered( _a : Area2D ) -> void:
	if enabled == false || dialogueItems.size() == 0:
		return
	animation.play( "show" )
	PlayerManager.InteractPressed.connect( playerInteract )

func _onAreaExited( _a : Area2D ) -> void:
	animation.play( "hide" )
	PlayerManager.InteractPressed.disconnect( playerInteract )

func _onDialogueFinished() -> void:
	DialogueSystem.Finished.disconnect( _onDialogueFinished )
	Finished.emit()

func _get_configuration_warnings() -> PackedStringArray:
	# check for dialogue items
	if _checkForDialogueItems() == false:
		return[ "Requires at least one DialogueItem node" ]
	else:
		return[]
	pass

func _checkForDialogueItems() -> bool:
	for c in get_children():
		if c is DialogueItem:
			return true
	return false
