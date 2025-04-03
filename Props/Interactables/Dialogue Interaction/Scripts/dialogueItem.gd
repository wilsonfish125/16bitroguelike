@tool
@icon( "res://NPC/Icons/chat_bubble.svg" )
class_name DialogueItem extends Node #acts as a base class for all unique dialogue options


@export var npcInfo : NPCResource

var editorSelection
var exampleDialogue : DialogueSystemNode



func _ready() -> void:
	if Engine.is_editor_hint():
		#editorSelection = EditorInterface.get_selection() #gives us current instance of whatever is selected in editor
		editorSelection = Engine.get_singleton( "EditorInterface" ).get_selection()
		editorSelection.selection_changed.connect( _onSelectionChanged )
		return
	checkNPCData()

func checkNPCData() -> void: #looks for parent npc node to get its data e.g. portrait data
	if npcInfo == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.npcResource:
					npcInfo = p.npcResource
					_checking = false
			else:
				_checking = false
	pass

func _onSelectionChanged() -> void:
	if editorSelection == null:
		return
	
	var sel = editorSelection.get_selected_nodes()
	
	if exampleDialogue != null:
		exampleDialogue.queue_free()
	
	if not sel.is_empty():
		if self == sel[0]:
			exampleDialogue = load("res://GUI/DialogueSystem/dialogueSystem.tscn").instantiate() as DialogueSystemNode
			if exampleDialogue == null:
				return
			self.add_child( exampleDialogue )
			exampleDialogue.offset = getParentGlobalPosition() + Vector2( 16, -200 )
			checkNPCData()
			_setEditorDisplay()

func getParentGlobalPosition() -> Vector2:
	var p = self
	var _checking : bool = true
	while _checking == true:
		p = p.get_parent()
		if p:
			if p is Node2D:
				return p.global_position
		else:
			_checking = false
	return Vector2.ZERO

func _setEditorDisplay() -> void:
	pass
