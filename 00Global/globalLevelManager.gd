#REMEMBER NO CLASSNAME FOR AUTOLOADS
extends Node

#we wanna keep track of current tilemap bounds in case we need it
var currentTilemapBounds : Array[ Vector2 ]

var targetTransition : String
var positionOffset : Vector2

signal TilemapBoundsChanged( bounds : Array[ Vector2 ] )

signal LevelLoadStarted
signal LevelLoaded

func _ready() -> void:
	await get_tree().process_frame
	LevelLoaded.emit()



#Anytime we load a new tilemap we call this script and this function
func changeTilemapBounds( bounds : Array[ Vector2 ] ) -> void:
	currentTilemapBounds = bounds
	TilemapBoundsChanged.emit( bounds ) #anyone listening can grab these bounds

func loadNewLevel(
		levelPath : String,
		_targetTransition : String,
		_positionOffset : Vector2 
) -> void:
	
	get_tree().paused = true
	targetTransition = _targetTransition
	positionOffset = _positionOffset
	
	#instead of waiting for process frame, lets await the scene transition functions we made 
	
	await SceneTransition.fadeOut()
	
	LevelLoadStarted.emit()
	
	await get_tree().process_frame #inbetween level load started and next part of code we wanna remove old level
	
	get_tree().change_scene_to_file( levelPath )
	
	await SceneTransition.fadeIn()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	LevelLoaded.emit()
	
	pass
