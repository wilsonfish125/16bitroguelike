class_name LockedDoor extends Node2D


var isOpen : bool = false

#what kind of key or itemdata can open the door?
@export var keyItem : ItemData 

@export var lockedAudio : AudioStream
@export var openAudio : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var isOpenData: PersistentDataHandler = $PersistentDataHandler
@onready var interact_area: Area2D = $InteractArea2D


func _ready() -> void:
	interact_area.area_entered.connect( _onAreaEnter )
	interact_area.area_exited.connect( _onAreaExit )
	isOpenData.DataLoaded.connect( setState )
	setState()

func openDoor(  ) -> void:
	if keyItem == null:
		return
	#did the player just try to open the door?
	var doorUnlocked = PlayerManager.INVENTORYDATA.useItem( keyItem )
	
	if doorUnlocked: #opens the door and saves a value since player has key
		animation_player.play( "openDoor" )
		audio.stream = openAudio
		isOpenData.setValue()
	else: #plays nono sound and does nothing since player has no key
		audio.stream = lockedAudio
	audio.play()


func closeDoor() -> void: #if you want the door to close
	animation_player.play( "closeDoor" )

#sets persistent state for saving and loading
func setState() -> void:
	isOpen = isOpenData.value
	if isOpen:
		animation_player.play( "opened" )
	else:
		animation_player.play( "closed" )


func _onAreaEnter( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.connect( openDoor )


func _onAreaExit( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.disconnect( openDoor )
