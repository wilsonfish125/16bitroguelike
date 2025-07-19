class_name Map extends Node2D

const SCROLLSPEED := 15
const MAPROOM = preload("res://GUI/Map/mapRoom.tscn")
const MAPLINE = preload("res://GUI/Map/mapLine.tscn")

@onready var mapGenerator : MapGenerator = $MapGenerator
@onready var lines : Node2D = %Lines
@onready var rooms : Node2D = %Rooms
@onready var visuals : Node2D = $Visuals
@onready var camera_2d : Camera2D = $Camera2D

var mapData : Array[Array]
var floorsClimbed : int
var lastRoom : Room
var cameraEdgeY : float

func _ready():
	cameraEdgeY = MapGenerator.YDIST * (MapGenerator.FLOORS - 1)
	
	
	if floorsClimbed == 0:
		generateNewMap()
		MapManager.unlockFloor(0)
	else:
		MapManager.unlockNextRooms()

func _input(event : InputEvent):
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLLSPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLLSPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -cameraEdgeY, 0)

func createMap() -> void:
	for currentFloor : Array in mapData:
		for room : Room in currentFloor:
			if room.nextRooms.size() > 0:
				_spawnRoom(room)
			
		
	# Boss Room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAPWIDTH * 0.5)
	_spawnRoom(mapData[MapGenerator.FLOORS - 1][middle])
	
	var mapWidthPixels := MapGenerator.XDIST * (MapGenerator.MAPWIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - mapWidthPixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2

func generateNewMap() -> void:
	floorsClimbed = 0
	mapData = mapGenerator.generateMap()

func unlockFloor( whichFloor : int = floorsClimbed ) -> void:
	MapManager.unlockFloor( whichFloor )

func unlockNextRooms() -> void:
	MapManager.unlockNextRooms()

func showMap() -> void:
	self.show()
	self.camera_2d.enabled = true

func hideMap() -> void:
	self.hide()
	self.camera_2d.enabled = false

func _spawnRoom( room : Room ) -> void:
	var newMapRoom := MAPROOM.instantiate() as MapRoom
	rooms.add_child( newMapRoom )
	newMapRoom.room = room
	newMapRoom.Selected.connect(_onMapRoomSelected)
	_connectLines(room)
	
	if room.selected and room.row < floorsClimbed:
		newMapRoom.showSelected()

func _connectLines( room : Room ) -> void:
	if room.nextRooms.is_empty():
		return
	
	for next: Room in room.nextRooms:
		var newMapLine := MAPLINE.instantiate() as Line2D
		newMapLine.add_point(room.position)
		newMapLine.add_point(next.position)
		lines.add_child(newMapLine)

func _onMapRoomSelected( room : Room ) -> void:
	MapManager._onMapRoomSelected(room)
	MapManager.MapExited.emit(room)
