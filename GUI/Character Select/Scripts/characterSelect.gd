class_name CharacterSelect extends Node2D

var kaitoPath : String = "res://Player/Characters/playerKaito.tscn"
var clawstenPath : String = "res://Player/Characters/playerClawsten.tscn"

@onready var kaitoButton : Button = %Button
@onready var clawstenButton : Button = %Button2

func _ready() -> void:
	PlayerManager.updatePlayer( clawstenPath )
	LevelManager.loadNewLevel( "res://GUI/Map/Map.tscn", "LevelTransition", Vector2.ZERO )
