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

func loadLevel() -> void:
	LevelManager.loadNewLevel(level, "LevelTransition", Vector2.ZERO)
	
