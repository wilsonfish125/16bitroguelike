extends Node2D

const STARTLEVEL : String = "res://Levels/Pegasus Island/testnewtilemap.tscn"

@export var music : AudioStream
@export var buttonFocusAudio : AudioStream
@export var buttonPressedAudio : AudioStream

@onready var buttonNew : Button = $CanvasLayer/Control/ButtonNew
@onready var buttonContinue : Button = $CanvasLayer/Control/ButtonContinue
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	#hide the player and make it so we can't move him
	get_tree().paused = true
	PlayerManager.player.visible = false
	
	#stop the pause menu
	PlayerHud.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.getSaveFile() == null:
		buttonContinue.disabled = true
		buttonContinue.visible = false
	
	setupTitleScreen()
	
	LevelManager.LevelLoadStarted.connect( exitTitleScreen )
	

func setupTitleScreen() -> void:
	#anything we need to do when the title screen displays for first time goes here
	AudioManager.playMusic( music )
	buttonNew.pressed.connect( startGame )
	buttonContinue.pressed.connect( loadGame )
	buttonNew.grab_focus()
	#we pass in paramters to methods in signals with the bind method
	buttonNew.focus_entered.connect( playAudio.bind( buttonFocusAudio ) )
	buttonContinue.focus_entered.connect( playAudio.bind( buttonFocusAudio ) )
	

func startGame() -> void:
	#what happens upon starting the game
	playAudio( buttonPressedAudio )
	LevelManager.loadNewLevel( STARTLEVEL, "", Vector2.ZERO )
	

func loadGame() -> void:
	#what happens upon continuing a loaded game
	SaveManager.loadGame()
	

func exitTitleScreen() -> void:
	#anytime we exit the title screen, level manager handles unpausing tho
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	self.queue_free()

func playAudio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
