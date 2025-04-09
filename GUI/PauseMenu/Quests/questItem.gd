class_name QuestItem extends Button

var quest : Quest # Corresponding Quest resource, we dont have to find it later on

@onready var title_label: Label = $TitleLabel
@onready var step_label: Label = $StepLabel


func initalize( qData : Quest, qState ) -> void:
	quest = qData
	title_label.text = qData.title
	
	if qState.isComplete: 
		step_label.text = "Completed"
		step_label.modulate = Color.LIGHT_GREEN
	else: # Calculate how many steps are completed, and what they are
		var stepCount : int = qData.steps.size()
		var completedCount : int = qState.completedSteps.size()
		step_label.text = "Quest Step: " + str( completedCount ) + "/" + str( stepCount )
	pass
