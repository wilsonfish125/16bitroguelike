extends CanvasLayer

#hook up to inventory with signals
signal Shown
signal Hidden
# Whenever we highlight an item and it is equippable, emit this
signal PreviewStatsChanged( item : ItemData ) 

@onready var tab_container: TabContainer = $Control/TabContainer

@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/ButtonLoad
@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/ButtonSave
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/ButtonQuit

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer


var isPaused : bool = false

func _ready() -> void:
	hidePauseMenu()
	#connecting save and load buttons, connect to signal and pass/call our functions
	button_save.pressed.connect( _onSavePressed )
	button_load.pressed.connect( _onLoadPressed )
	button_quit.pressed.connect( _onQuitPressed )

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
	
	if isPaused:
		if event.is_action_pressed("right_bumper"):
			# Change the tab on the pause screen
			changeTab( 1 )
		elif event.is_action_pressed("left_bumper"):
			changeTab( -1 )
	

func showPauseMenu() -> void:
	get_tree().paused = true #gets the root of the whole game and pauses it
	visible = true
	isPaused = true
	tab_container.current_tab = 0 #always sets to inventory upon reopening
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

func _onLoadPressed() -> void:
	if isPaused == false:
		return
	SaveManager.loadGame()
	await LevelManager.LevelLoadStarted
	hidePauseMenu()

func _onQuitPressed() -> void:
	get_tree().quit()

func focusItemChanged( slot : SlotData ) -> void:
	if slot:
		if slot.itemData:
			updateItemDescription( slot.itemData.description )
			# Update Stats
			previewStats( slot.itemData )
	else:
		updateItemDescription( "" )
		# Update Stats
		previewStats( null )

func updateItemDescription( newDescription : String ) -> void:
	item_description.text = newDescription

func playAudio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

func changeTab( _i : int = 1 ) -> void:
	tab_container.current_tab = wrapi( 
			tab_container.current_tab + _i,  # Current Value
			0,                               # Minimum Value
			tab_container.get_tab_count()    # Maximum Value
		 ) 
	tab_container.get_tab_bar().grab_focus() # Resets focus to tab bar accordingly

func previewStats( item : ItemData ) -> void:
	PreviewStatsChanged.emit( item )
