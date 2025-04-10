# Quest Manager - Global Script 
extends Node

signal QuestUpdated( q )

const QUESTDATALOCATION : String = "res://Quests/" #all quests live in this folder, note when updating

var quests : Array[ Quest ] # Keeps track of ALL QUESTS IN GAME
var currentQuests : Array = [
]  # Keeps track of current quests both active and completed in a savegame
 # What each item looks like: { title = "not found", isComplete = false, completedSteps = [''] }

func _ready() -> void:
	# Gather all Quests
	gatherQuestData()

func _unhandled_input( event: InputEvent ) -> void:
	if event.is_action_pressed( "test" ):
		#print( findQuest( load( "res://Quests/evilWizardQuest.tres" ) as Quest ) )
		# The way it works, quests cannot be added and completed at once
		#updateQuest( "a short quest" )
		#updateQuest( "slay the evil wizard" )
		#updateQuest( "slay the evil wizard", "enter the dungeon" )
		#updateQuest( "a long quest" )
		#updateQuest( "a long quest", "1" )
		#updateQuest( "a long quest", "2" )
		
		pass

func gatherQuestData() -> void:
	# Gather all quest resources within QUESTDATALOCATION and append to quests array
	var questFiles : PackedStringArray = DirAccess.get_files_at( QUESTDATALOCATION )
	quests.clear() #prevent dupes and weird stuff
	for q in questFiles:
		quests.append( load( QUESTDATALOCATION + "/" + q ) as Quest )
	print( quests.size() )

# Update the status of a quest from begin to end
# Add, find or complete a quest
func updateQuest( _title : String, _completedStep : String = "", _isComplete : bool = false ) -> void:
	var questIndex : int = getQuestIndexByTitle( _title )
	if questIndex == -1:
		# Means quest was not found, and it must be added to currentQuests
		var newQuest : Dictionary = {  # Two tabs for Dictionary
				title = _title, 
				isComplete = _isComplete,
				completedSteps = []
		}
		if _completedStep != "":
			newQuest.completedSteps.append( _completedStep.to_lower() )
		
		currentQuests.append( newQuest )
		QuestUpdated.emit( newQuest )
		
		# Display UI notif that a quest was ADDED
		PlayerHud.queueNotification( "Quest Started", _title )
		
	else:
		# Means quest WAS found, update it
		var q = currentQuests[ questIndex ]
		if _completedStep != "" and q.completedSteps.has( _completedStep ) == false:
			# If we have a completed step value, and if that string is not already found in list of completed steps
			q.completedSteps.append( _completedStep.to_lower() )
		q.isComplete = _isComplete
		QuestUpdated.emit( q )
		
		# Display UI notif if quest is updated/completed
		
		if q.isComplete == true:
			PlayerHud.queueNotification( "Quest Complete", _title )
			dropQuestRewards( findQuestByTitle( _title ) )
		else: # Quest wasn't marked as complete
			PlayerHud.queueNotification( "Quest Updated", _title + ": " + _completedStep )
	pass

# Give XP and item rewards to player
func dropQuestRewards( _q : Quest ) -> void:
	var _message : String = str( _q.rewardXP ) + "xp"
	PlayerManager.rewardXP( _q.rewardXP )
	for i in _q.rewardItems:
		PlayerManager.INVENTORYDATA.addItem( i.item, i.quantity )
		_message += ", " + i.item.name + " x" + str( i.quantity )
	
	PlayerHud.queueNotification( "Quest Rewards Recieved", _message )

# Provide a quest resource and return the corresponding Dictionary from currentQuests associated with it
func findQuest( _quest : Quest ) -> Dictionary:
	for q in currentQuests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return { title = "not found", isComplete = false, completedSteps = [''] }

# Take title and find associated quest resource
func findQuestByTitle( _title : String ) -> Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower(): # Makes it not case sensitive
			return q
	return null

# Find quest by title name and return index in currentQuests array
func getQuestIndexByTitle( _title : String ) -> int:
	for i in currentQuests.size():
		if currentQuests[ i ].title.to_lower() == _title.to_lower():
			return i
	# Returns -1 if no quest with matching title was found
	return -1

# 
func sortQuests() -> void:
	var activeQuests : Array = [] #Current quests not complete
	var completedQuests : Array = []
	for q in currentQuests:
		if q.isComplete: # Has dictionary data here, no autocomplete remember
			completedQuests.append( q )
		else:
			activeQuests.append( q )
	
	activeQuests.sort_custom( sortQuestsAscending )
	completedQuests.sort_custom( sortQuestsAscending )
	
	currentQuests = activeQuests # Overwrites previous data in currentQuests
	currentQuests.append_array( completedQuests ) # Appends at the end, out of the way
	

func sortQuestsAscending( a, b ):
	if a.title.to_lower() < b.title.to_lower():
		return true
	return false
