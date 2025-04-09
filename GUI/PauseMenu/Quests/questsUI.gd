class_name QuestsUI extends Control
# Responsible for populating the quests list, and updating the display

const QUESTITEM : PackedScene = preload( "res://GUI/PauseMenu/Quests/questItem.tscn" )
const QUESTSTEPITEM : PackedScene = preload( "res://GUI/PauseMenu/Quests/questStepItem.tscn" )

@onready var questItemContainer : VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer
@onready var detailsContainer : VBoxContainer = $VBoxContainer
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel


func _ready() -> void:
	clearQuestDetails()
	visibility_changed.connect( _onVisibleChanged )
	pass

func _onVisibleChanged() -> void:
	 # Clear the list first, since we repopulate every time menu is open
	for i in questItemContainer.get_children():
		i.queue_free()
	
	clearQuestDetails()
	
	# Update the list when menu is open
	if visible == true:
		QuestManager.sortQuests() # Sorts before list is created
		for q in QuestManager.currentQuests:
			var questData : Quest = QuestManager.findQuestByTitle( q.title ) # Find associated resource
			if questData == null:
				continue # Go onto next item in loop
			var newQItem : QuestItem = QUESTITEM.instantiate()
			# Add new item to the container
			questItemContainer.add_child( newQItem )
			newQItem.initalize( questData, q ) # Create new questItem with the corresponding resource 
			# Connect to focus buttons
			newQItem.focus_entered.connect( updateQuestDetails.bind( newQItem.quest ) )

func updateQuestDetails( q : Quest ) -> void:
	# Clear previous quest details
	clearQuestDetails()
	
	title_label.text = q.title
	description_label.text = q.description
	# Get the steps
	var questSave = QuestManager.findQuest( q ) # Gives us saved info related to quest
	for step in q.steps:
		# Create a new QuestStepItem for display
		var newStep : QuestStepItem = QUESTSTEPITEM.instantiate()
		var stepIsComplete : bool = false
		if questSave.title != "not found":
			stepIsComplete = questSave.completedSteps.has( step.to_lower() ) # Check steps by string name
		detailsContainer.add_child( newStep )
		newStep.initialize( step, stepIsComplete ) # Now iterates over all steps
		#print( step, stepIsComplete )

func clearQuestDetails() -> void:
	# Set the label text to blank string by iterating over details container
	title_label.text = ""
	description_label.text = ""
	for c in detailsContainer.get_children():
		if c is QuestStepItem:
			c.queue_free()
