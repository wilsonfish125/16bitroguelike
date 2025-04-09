@tool
class_name QuestNode extends Node2D

@export var linkedQuest : Quest = null : set = _setQuest
@export var questStep : int = 0 : set = _setStep
@export var questComplete : bool = false : set = _setComplete

@export_category( "Info Only" )
@export_multiline var settingsSummary : String

func _setQuest( _v : Quest ) -> void:
	linkedQuest = _v
	questStep = 0
	updateSummary()

func _setStep( _v : int ) -> void:
	questStep = clamp( _v, 0, getStepCount() )
	updateSummary()

func _setComplete( _v : bool ) -> void:
	questComplete = _v
	updateSummary()

func getStepCount() -> int:
	if linkedQuest == null:
		return 0 # there are no steps
	else:
		return linkedQuest.steps.size()

func updateSummary() -> void:
	settingsSummary = "UPDATE QUEST:\nQuest: " + linkedQuest.title + "\n"
	settingsSummary += "Step: " + str( questStep ) + " - " + getStep() + "\n"
	settingsSummary += "Complete: " + str( questComplete )

func getStep() -> String:
	# Check that our questStep value is within the range of steps
	if questStep != 0 and questStep <= getStepCount() :
		return linkedQuest.steps[ questStep - 1 ] # Because indexed arrays begin at zero
	else:
		return "N/A"
