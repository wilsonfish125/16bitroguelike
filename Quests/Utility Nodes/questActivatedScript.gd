@tool
@icon( "res://Quests/Utility Nodes/Icons/quest_switch.png" )
class_name QuestActivatedSwitch extends QuestNode

# The node function in four different ways depending on what enum we pick
enum CheckType { HASQUEST, QUESTSTEPCOMPLETE, ONCURRENTQUESTSTEP, QUESTCOMPLETE }

signal IsActivatedChanged( v : bool ) # Emits when state of this node changes

@export var checkType : CheckType = CheckType.HASQUEST : set = _setCheckType
@export var removeWhenActivated : bool = false
@export var freeOnRemoved : bool = false # Queue Free on removed rather than mode.process disabled
@export var reactToGlobalSignal : bool = false # Should this item react instantly or next scene reset?

var isActivated : bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node( "Sprite2D" ):
		$Sprite2D.queue_free()
	# We need to connect to the global signal, but only if reactToGlobalSignal is true
	if reactToGlobalSignal == true:
		QuestManager.QuestUpdated.connect( _onQuestUpdated )
	checkIsActivated()
	

func checkIsActivated() -> void:
	# Get a reference to the saved quest
	var _q : Dictionary = QuestManager.findQuest( linkedQuest )
	if _q.title != "not found":
		# Gotta check all four CheckTypes
		
		if checkType == CheckType.HASQUEST:
			# We already know we have a quest
			setIsActivated( true )
		
		elif checkType == CheckType.QUESTCOMPLETE:
			# Simply set is activated based on if our quest complete values match
			# We need to make sure isComplete is always a boolean
			var isComplete : bool = false
			if _q.isComplete is bool:
				isComplete = _q.isComplete
			setIsActivated( isComplete )
		
		elif checkType == CheckType.QUESTSTEPCOMPLETE:
			# The next two get more complex
			if questStep > 0:
				if _q.completedSteps.has( getStep() ) == true:
					# Means we have completed the steps
					setIsActivated( true )
				else:
					setIsActivated( false )
			else:
				setIsActivated( false )
		
		elif checkType == CheckType.ONCURRENTQUESTSTEP:
			# This one is annoying
			var step : String = getStep()
			if step == "N/A":
				setIsActivated( false )
			
			else: # We have a valid step to check
				if _q.completedSteps.has( step ):
					# We know the step is completed as it is in the completed array
					setIsActivated( false )
				else:
					var prevStep : String = getPreviousStep()
					if prevStep == "N/A":
						# We know there is no previous step, so we MUST be on the first step
						setIsActivated( true )
					
					elif _q.completedSteps.has( prevStep.to_lower() ):
						setIsActivated( true ) # If the prev step is in the array but current isnt, we are on current
					else:
						setIsActivated( false )
		
	else:
		setIsActivated( false )

func setIsActivated( _v : bool ) -> void:
	isActivated = _v
	IsActivatedChanged.emit( _v )
	# Have to either set it to an active state or inactive state
	if isActivated == true:
		if removeWhenActivated == true:
			hideChildren()
		else:
			showChildren()
	else:
		if removeWhenActivated == true:
			showChildren()
		else:
			hideChildren()

func showChildren() -> void:
	for c in get_children():
		c.visible = true
		c.process_mode = Node.PROCESS_MODE_INHERIT

func hideChildren() -> void:
	for c in get_children():
		c.set_deferred( "visible", false )
		c.set_deferred( "process_mode", Node.PROCESS_MODE_DISABLED )
		if freeOnRemoved:
			c.queue_free()

func _onQuestUpdated( _q : Dictionary ) -> void:
	checkIsActivated()
	

func _setCheckType( v : CheckType ) -> void:
	checkType = v
	updateSummary()

func updateSummary() -> void:
	if linkedQuest == null:
		settingsSummary = "Select a Quest"
		return
	settingsSummary = "UPDATE QUEST:\nQuest: " + linkedQuest.title + "\n"
	if checkType == CheckType.HASQUEST:
		settingsSummary += "Checking if player has quest"
	elif checkType == CheckType.QUESTSTEPCOMPLETE:
		settingsSummary += "Checking if player has completed step: " + getStep()
	elif checkType == CheckType.ONCURRENTQUESTSTEP:
		settingsSummary += "Check if player is on step: " + getStep()
	elif checkType == CheckType.QUESTCOMPLETE:
		settingsSummary += "Checking if quest is complete"
