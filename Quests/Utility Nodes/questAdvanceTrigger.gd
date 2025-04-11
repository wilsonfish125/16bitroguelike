@tool # Because we extend QuestNode
@icon( "res://Quests/Utility Nodes/Icons/quest_advance.png" )
class_name QuestAdvanceTrigger extends QuestNode

signal Advanced

@export_category( "Parent Signal Connection" )
@export var signalName : String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node( "Sprite2D" ):
		$Sprite2D.queue_free()
	
	# Way better way of connecting with signals than doing it in the editor
	# IMPORTANT, ONLY WORKS IF THIS NODE IS A DIRECT CHILD OF NODE WITH METHOD
	if signalName != "":
		if get_parent().has_signal( signalName ):
			get_parent().connect( signalName, advanceQuest )
	pass

# Primary function of this node
# Most of the heavy lifting is done in the QuestManager
func advanceQuest() -> void:
	if linkedQuest == null:
		return
	
	await get_tree().process_frame # So the questActivatedSwitch runs before this node
	
	Advanced.emit()
	var _title : String = linkedQuest.title
	var _step : String = getStep()
	
	if _step == "N/A":
		_step = ""
	
	QuestManager.updateQuest( _title, _step, questComplete )
