extends Node

signal selected(room: Room)

var mapData : Array[Array] = []
var floorsClimbed : int = 0
var lastRoom : Room = null

const MONSTERROOMS : Array[String] = [
	"res://Levels/Roguelike/Area1/Enemies/e1a1.tscn", 
	"res://Levels/Roguelike/Area1/Enemies/e2a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e3a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e4a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e5a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e6a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e7a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e8a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e9a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e10a1.tscn",
	"res://Levels/Roguelike/Area1/Enemies/e11a1.tscn",
]

var shopRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Shops/s1a1.tscn"
]

var campfireRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Campfires/c1a1.tscn"
]

var treasureRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Treasure/t1a1.tscn"
]

var bossRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Bosses/b1a1.tscn"
]

var monsterRooms : Array[String] = MONSTERROOMS.duplicate()

func _ready() -> void:
	selected.connect(loadLevel)

func loadLevel( room : Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			var level : String = monsterRooms.pick_random()
			LevelManager.loadNewLevel(level, "LevelTransition", Vector2.ZERO)
			monsterRooms.erase(level)
		Room.Type.SHOP:
			LevelManager.loadNewLevel(shopRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.CAMPFIRE:
			LevelManager.loadNewLevel(campfireRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.TREASURE:
			LevelManager.loadNewLevel(treasureRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.BOSS:
			LevelManager.loadNewLevel(bossRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		_:
			LevelManager.loadNewLevel(MONSTERROOMS.pick_random(), "LevelTransition", Vector2.ZERO)
