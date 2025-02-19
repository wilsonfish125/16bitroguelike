extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false #dont wanna see it playing the game
	#we need a way to tell the player manager where to put the player but only when it loads
	#Lets talk to our global scripts cuz thats cool
	if PlayerManager.playerSpawned == false:
		PlayerManager.setPlayerPosition( global_position )
		PlayerManager.playerSpawned = true
