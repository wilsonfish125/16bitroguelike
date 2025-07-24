class_name Map extends Node2D

const SCROLLSPEED := 15
const MAPROOM = preload("res://GUI/Map/mapRoom.tscn")
const MAPLINE = preload("res://GUI/Map/mapLine.tscn")

@onready var mapGenerator : MapGenerator = $MapGenerator
@onready var lines : Node2D = %Lines
@onready var rooms : Node2D = %Rooms
@onready var visuals : Node2D = $Visuals
@onready var camera_2d : Camera2D = $Camera2D

var map_data : Array [Array]
var floors_climbed : int
var last_room : Room
var cameraEdgeY : float


func _ready() -> void:
	floors_climbed=MapManager.floorsClimbed
	last_room = MapManager.lastRoom
	cameraEdgeY = MapGenerator.YDIST * (MapGenerator.FLOORS - 1)
	_start_run()

func _start_run () -> void:
	generateNewMap()
	if floors_climbed>0:
		for _floor in floors_climbed:
			unlockNextRooms()
	else:
		unlockFloor(0)


func _input(event : InputEvent):
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLLSPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLLSPEED
	
	camera_2d.position.y = clamp(camera_2d.position.y, -cameraEdgeY, 0)

func generateNewMap() -> void:
	if MapManager.mapData.is_empty():
		MapManager.mapData = mapGenerator.generateMap()
		map_data=MapManager.mapData
	else:
		map_data=MapManager.mapData
	createMap()

func createMap() -> void:
	for currentFloor : Array in map_data:
		for room : Room in currentFloor:
			if room.nextRooms.size() > 0:
				_spawnRoom(room)
			
		
	# Boss Room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAPWIDTH * 0.5)
	_spawnRoom(map_data[MapGenerator.FLOORS - 1][middle])
	
	var mapWidthPixels := MapGenerator.XDIST * (MapGenerator.MAPWIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - mapWidthPixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2

func unlockFloor( whichFloor : int = floors_climbed ) -> void:
	for mapRoom : MapRoom in rooms.get_children():
		if mapRoom.room.row == whichFloor:
			mapRoom.available = true

func unlockNextRooms() -> void:
	for mapRoom : MapRoom in rooms.get_children():
		if last_room.nextRooms.has(mapRoom.room):
			mapRoom.available = true

func showMap() -> void:
	show()
	camera_2d.enabled = true

func hideMap() -> void:
	hide()
	camera_2d.enabled = false

func _spawnRoom( room : Room ) -> void:
	var newMapRoom := MAPROOM.instantiate() as MapRoom
	rooms.add_child( newMapRoom )
	newMapRoom.room = room
	newMapRoom.Selected.connect(_onMapRoomSelected)
	_connectLines(room)
	
	if room.selected and room.row < floors_climbed:
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
	for mapRoom : MapRoom in rooms.get_children():
		if mapRoom.room.row == room.row:
			mapRoom.available = false
	MapManager.lastRoom = room
	MapManager.floorsClimbed += 1	
	
