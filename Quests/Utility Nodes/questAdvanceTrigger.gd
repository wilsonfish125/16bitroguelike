@tool # Because we extend QuestNode
@icon( "res://Quests/Utility Nodes/Icons/quest_advance.png" )
class_name QuestAdvanceTrigger extends QuestNode

@export_category( "Parent Signal Connection" )
@export var signalName : String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	$Sprite2D.queue_free()
	
	# Way better way of connecting with signals than doing it in the editor
	if signalName != "":
		if get_parent().has_signal( signalName ):
			get_parent().connect( signalName, advanceQuest )
	pass

# Primary function of this node
# Most of the heavy lifting is done in the QuestManager
func advanceQuest() -> void:
	if linkedQuest == null:
		return
	
	var _title : String = linkedQuest.title
	var _step : String = getStep()
	
	if _step == "N/A":
		_step = ""
	
	QuestManager.updateQuest( _title, _step, questComplete )
