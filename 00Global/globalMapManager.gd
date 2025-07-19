extends Node

# Lots of signals

signal MapExited(room : Room)

signal MonsterExited
signal ShopExited
signal CampfireExited
signal TreasureExited
signal BossExited

var monsterRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Enemies/e1a1.tscn", 
	"res://Levels/Roguelike/Area1/Enemies/e2a1.tscn"
]
var level = monsterRooms[randi_range(0, 1)]

# Test Script #

@onready var mapGenerator : MapGenerator = $MapGenerator
@onready var lines : Node2D = %Lines
@onready var rooms : Node2D = %Rooms
@onready var visuals : Node2D = $Visuals
@onready var camera_2d : Camera2D = $Camera2D

var mapData : Array[Array]
var floorsClimbed : int
var lastRoom : Room
var cameraEdgeY : float

# Test Script End #

func loadLevel() -> void:
	LevelManager.loadNewLevel(level, "LevelTransition", Vector2.ZERO)

# Test Script #

func unlockFloor( whichFloor : int = floorsClimbed ) -> void:
	for mapRoom : MapRoom in rooms.get_children():
		if mapRoom.room.row == whichFloor:
			mapRoom.avaliable = true

func unlockNextRooms() -> void:
	for mapRoom : MapRoom in rooms.get_children():
		if lastRoom.nextRooms.has(mapRoom.room):
			mapRoom.avaliable = true

func _onMapRoomSelected( room : Room ) -> void:
	for mapRoom : MapRoom in rooms.get_children():
		if mapRoom.room.row == room.row:
			mapRoom.avaliable = false
	
	lastRoom = room
	floorsClimbed += 1

# Test Script End #
