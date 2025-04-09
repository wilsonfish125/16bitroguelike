class_name QuestStepItem extends Control

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D



func initialize( step : String, isComplete : bool ) -> void:
	label.text = step
	if isComplete == true:
		sprite_2d.frame = 1
	else:
		sprite_2d.frame = 0
	pass 
