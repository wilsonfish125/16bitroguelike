@tool
#ooh custom icons
@icon( "res://NPC/Icons/npc.svg" )
class_name NPC extends CharacterBody2D

signal behaviorEnabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var directionName : String = "Down" #this sucks in the player so lets try it differently
var canDoBehavior : bool = true

@export var npcResource : NPCResource : set = _setNPCResource

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	setupNPC()
	if Engine.is_editor_hint():
		return
	behaviorEnabled.emit()
	pass

#when you start the behavior this is what happens
func start() -> void:
	pass


func _physics_process( _delta: float ) -> void:
	move_and_slide()

func updateAnimation() -> void:
	animation.play( state + directionName )

func updateDirection( targetPosition : Vector2 ) -> void:
	direction = global_position.direction_to( targetPosition )
	updateDirectionName()
	if directionName == "Horizontal" and direction.x < 0 :
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func updateDirectionName() -> void:
	var threshold : float = 0.20
	if direction.y < -threshold:
		directionName = "Up"
	elif direction.y > threshold:
		directionName = "Down"
	elif direction.x > threshold || direction.x < -threshold:
		directionName = "Horizontal"



func setupNPC() -> void:
	if npcResource != null:
		if sprite:
			sprite.texture = npcResource.sprite
	pass

func _setNPCResource( _npc : NPCResource ) -> void:
	npcResource = _npc
	setupNPC()
