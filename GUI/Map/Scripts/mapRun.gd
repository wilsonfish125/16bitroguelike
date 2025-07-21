class_name Run extends Node2D

@onready var map: Map = $Map

func _ready() -> void:
	_startMap()
	_showMap()

func _startMap() -> void:
	map.generateNewMap()
	map.unlockFloor(0)
	# MAKE NEW MAP HERE #

func _changeView( scene : PackedScene ) -> void:
	LevelManager.loadLevelByPacked(scene, "LevelTransition", Vector2.ONE)
	get_tree().paused = false
	map.hideMap()

func _showMap() -> void:
	map.showMap()
	map.unlockNextRooms()

func _setupEventConnections() -> void:
	MapManager.MonsterExited.connect(_showMap)
	MapManager.BossExited.connect(_showMap)

func _onMapExited(room : Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_changeView(MapManager.level)
