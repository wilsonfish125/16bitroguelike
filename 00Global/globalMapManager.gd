extends Node

# Lots of signals

#signal MapExited(room : Room)
signal selected(room: Room)

#signal MonsterExited
#signal ShopExited
#signal CampfireExited
#signal TreasureExited
#signal BossExited

var mapData : Array[Array] = []
var floorsClimbed : int = 0
var lastRoom : Room = null

var monsterRooms : Array[String] = [
	"res://Levels/Roguelike/Area1/Enemies/e1a1.tscn", 
	"res://Levels/Roguelike/Area1/Enemies/e2a1.tscn"
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

func _ready() -> void:
	selected.connect(loadLevel)

func loadLevel( room : Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			LevelManager.loadNewLevel(monsterRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.SHOP:
			LevelManager.loadNewLevel(shopRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.CAMPFIRE:
			LevelManager.loadNewLevel(campfireRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.TREASURE:
			LevelManager.loadNewLevel(treasureRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		Room.Type.BOSS:
			LevelManager.loadNewLevel(bossRooms.pick_random(), "LevelTransition", Vector2.ZERO)
		_:
			LevelManager.loadNewLevel(monsterRooms.pick_random(), "LevelTransition", Vector2.ZERO)
