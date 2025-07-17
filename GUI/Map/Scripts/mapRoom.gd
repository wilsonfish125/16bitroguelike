class_name MapRoom extends Area2D

signal Selected(room : Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://GUI/Map/Icons/mapEnemyIcon.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://GUI/Map/Icons/mapBossIcon.png"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://GUI/Map/Icons/mapCampfireIcon.png"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://GUI/Map/Icons/mapShopIcon.png"), Vector2(0.6, 0.6)],
	Room.Type.BOSS: [preload("res://GUI/Map/Icons/mapBossIcon.png"), Vector2(1.5, 1.5)],
}

@onready var line_2d = $Visuals/Line2D
@onready var sprite_2d = $Visuals/Sprite2D
@onready var animation_player = $AnimationPlayer

var avaliable := false : set = setAvaliable
var room : Room : set = setRoom
var level : Level : set = setLevel
var levelName : String : set = setLevelName

func setAvaliable( newValue : bool ) -> void:
	avaliable = newValue
	
	if avaliable:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")

func setRoom( newData : Room) -> void:
	room = newData
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]

func setLevel( newData : Level ) -> void:
	level = newData
	print("Level Set")

func setLevelName( newData : String ) -> void:
	levelName = newData
	print("Level Name Set")

func showSelected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(viewport, event, shape_idx):
	if not avaliable or not event.is_action_pressed("left_click"):
		return
	
	room.selected = true
	animation_player.play("select")
	await get_tree().create_timer(2).timeout
	print(levelName)
	LevelManager.loadNewLevel(levelName, "LevelTransition", Vector2.ZERO)
	# Conditions for entering room here, by default monster
	

# Used in AnimationPlayer on MapRoom
func _onMapRoomSelected() -> void:
	Selected.emit(room)
