class_name Level extends Node2D

#ADD THIS SCRIPT TO EVERY LEVEL


func _ready() -> void:
	self.y_sort_enabled = true #I am paranoid black sabbath reference
	PlayerManager.setAsParent( self ) #this level node is the new parent yipe
	LevelManager.LevelLoadStarted.connect( _freeLevel )


func _freeLevel() -> void:
	PlayerManager.unparentPlayer( self )
	queue_free() #this way the player wont be part of the level when it gets removed from the game
