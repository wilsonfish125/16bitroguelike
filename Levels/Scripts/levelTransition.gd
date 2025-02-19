@tool #i know the pieces fit, this tells godot we want the script to run in the editor
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM } #easy way for us to track the side it belongs to

@export_file( "*.tscn" ) var level #hey you did wildcard characters in IPT! finally something useful
@export var targetTransitionArea : String = "LevelTransition" #value will be used to point the player to another map scene

@export_category("Collision Area Settings")

@export_range(1, 12, 1, "or_greater") var size : int = 2 :
	set( _v ): #anytime a value is set on the size we call this, since this is tool script also happens in editor
		size = _v
		_updateArea()

#Set side to the side the player ENTERS the levelTransition area
@export var side : SIDE = SIDE.LEFT :
	set( _v ):
		side = _v
		_updateArea()


@export var snapToGrid : bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D





func _ready() -> void:
	_updateArea()
	if Engine.is_editor_hint(): #if we're in the editor:
		return
	
	monitoring = false #trust the process
	_placePlayer()
	
	await LevelManager.LevelLoaded
	
	monitoring = true #it only works when monitoring is off
	body_entered.connect( _playerEntered )
	
	pass

func _playerEntered( _p : Node2D ) -> void:
	#what we wanna do is tell the level manager that we wanna change levels since the player has entered
	LevelManager.loadNewLevel( level, targetTransitionArea, getOffset() )
	pass

func _placePlayer() -> void:
	if name != LevelManager.targetTransition:
		return
	PlayerManager.setPlayerPosition( global_position + LevelManager.positionOffset )
	pass

func getOffset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var playerPosition = PlayerManager.player.global_position
	
	#we need to detect if we are in the left, right, top, or bottom
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = playerPosition.y - global_position.y
		offset.x = 8
		if side == SIDE.LEFT:
			offset.x *= -1
	else: #if not left or right we know its top or bottom
		offset.x = playerPosition.x - global_position.x
		offset.y = 8
		if side == SIDE.TOP:
			offset.y *= -1
	
	return offset


func _updateArea() -> void:
	#gonna create a new shape for our level transition shape based on what we put in the editor
	var newRect : Vector2 = Vector2( 16, 16 )
	var newPosition : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		newRect.x *= size
		newPosition.y -= 16 #keeps centered but bumps it down by half a tile
	elif side == SIDE.BOTTOM:
		newRect.x *= size
		newPosition.y += 16
	elif side == SIDE.LEFT:
		newRect.y *= size
		newPosition.x -= 16
	elif side == SIDE.RIGHT:
		newRect.y *= size
		newPosition.x += 16
	
	if collision_shape == null: #failsafe cuz this is a tool script
		collision_shape = get_node("CollisionShape2D")
	
	collision_shape.shape.size = newRect
	collision_shape.position = newPosition
	
