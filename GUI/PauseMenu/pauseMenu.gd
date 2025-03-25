extends CanvasLayer

#hook up to inventory with signals
signal Shown
signal Hidden


@onready var button_load: Button = $Control/HBoxContainer/ButtonLoad
@onready var button_save: Button = $Control/HBoxContainer/ButtonSave
@onready var item_description: Label = $Control/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer


var isPaused : bool = false

func _ready() -> void:
	hidePauseMenu()
	#connecting save and load buttons, connect to signal and pass/call our functions
	button_save.pressed.connect( _onSavePressed )
	button_load.pressed.connect( _onLoadPressed )
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	#lets decide if we wanna show the puase screen or not
	if event.is_action_pressed("pause"):
		if isPaused == false: #hey its kinda like a flip flop (see below functions)
			if DialogueSystem.isActive:
				return
			showPauseMenu()
		else:
			hidePauseMenu()
		get_viewport().set_input_as_handled() #godot now consideres this input event as handled and any future scripts will not freak out
	

func showPauseMenu() -> void:
	get_tree().paused = true #gets the root of the whole game and pauses it
	visible = true
	isPaused = true
	Shown.emit()


func hidePauseMenu() -> void:
	get_tree().paused = false
	visible = false
	isPaused = false
	Hidden.emit()

func _onSavePressed() -> void:
	if isPaused == false:
		return
	#otherwise,
	SaveManager.saveGame()
	hidePauseMenu()
	pass

func _onLoadPressed() -> void:
	if isPaused == false:
		return
	SaveManager.loadGame()
	await LevelManager.LevelLoadStarted
	hidePauseMenu()
	pass

func updateItemDescription( newDescription : String ) -> void:
	item_description.text = newDescription
	pass

func playAudio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
	pass
