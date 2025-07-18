#great place to handle functionality of player "spawner"
extends Node

const PLAYER = preload("res://Player/player2.tscn")
const INVENTORYDATA : InventoryData = preload("res://GUI/Inventory/playerInventory.tres")

signal CameraShook( trauma : float )
signal InteractPressed #any interactable thing can listen in, detection for button in states
signal PlayerLevelUp

var interactHandled : bool = true
var player : Player
var playerSpawned : bool = false

# Each index for each unique level in ascending
var levelRequirements = [ 0, 50, 150, 300, 500, 800, 1200 ]

func _ready() -> void:
	addPlayerInstance()
	#add a failsafe in case we have levels and we dont add a player spawn point
	await get_tree().create_timer( 0.2 ).timeout
	playerSpawned = true #after half a second if we havent had something try to spawn a player we set it to true

func addPlayerInstance() -> void:
	player = PLAYER.instantiate() #creates an instance of PLAYER and assigns it to the variable
	add_child( player ) #gotta add the player somewhere
	pass


func setPlayerPosition( _newPosition : Vector2 ) -> void:
	player.global_position = _newPosition
	pass

func setPlayerHealth( hp : int, maxHP : int ) -> void:
	player.maxHP = maxHP
	player.hp = hp
	player.updateHP(0) #this updates the UI
	pass

#bugfix methods for ysort issue


func rewardXP( _xp : int ) -> void:
	player.xp += _xp
	# Check for level up conditions
	checkForLevelAdvance()

# RECURSIVE FUNCTION
# Calls itself under certain conditions
# Once it completes conditions, it stops calling itself
func checkForLevelAdvance() -> void:
	if player.level >= levelRequirements.size():
		return # We are max level
	
	if player.xp >= levelRequirements[ player.level ]:
		# Level up the player
		player.level += 1
		player.attackStat += 1
		player.defenceStat += 1
		PlayerLevelUp.emit()
		checkForLevelAdvance()


func setAsParent( _p : Node2D ) -> void:
	#gotta remove player from any other nodes it could be a child of first
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )

func unparentPlayer( _p : Node2D ) -> void:
	_p.remove_child( player )

func playAudio( _audio : AudioStream ) -> void:
	player.audio.stream = _audio
	player.audio.play()

func interact() -> void:
	interactHandled = false
	InteractPressed.emit()

func shakeCamera( trauma : float = 1 ) -> void:
	CameraShook.emit( clampi( trauma, 0, 3 ) ) 
