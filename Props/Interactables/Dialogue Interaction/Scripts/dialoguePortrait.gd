@tool
class_name DialoguePortrait extends Sprite2D


var blink : bool = false : set = _setBlink
var openMouth : bool = false : set = _setOpenMouth
var mouthOpenFrames : int = 0
var audioPitchBase : float = 1.0

@onready var audio : AudioStreamPlayer = $"../AudioStreamPlayer"


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogueSystem.LetterAdded.connect( checkMouthOpen )
	blinker()

func checkMouthOpen( l : String ) -> void:
	if 'aeiouy1234567890'.contains( l ):
		openMouth = true
		mouthOpenFrames += 3
		audio.pitch_scale = randf_range( audioPitchBase - 0.04, audioPitchBase + 0.04 )
		audio.play()
	elif '.,!?'.contains( l ):
		mouthOpenFrames = 0
	
	if mouthOpenFrames > 0:
		mouthOpenFrames -= 1
	
	if mouthOpenFrames == 0:
		openMouth = false
	

func updatePortrait() -> void:
	if openMouth == true:
		frame = 2
	else:
		frame = 0
	
	if blink == true:
		frame += 1

func blinker() -> void: #i needed an excuse to use this method name
	if blink == false:
		await get_tree().create_timer( randf_range( 0.1, 5 ) ).timeout
	else:
		await get_tree().create_timer( 0.15 ).timeout
	blink = not blink
	blinker()

func _setBlink( _value : bool ) -> void:
	if blink != _value:
		blink = _value
		updatePortrait()

func _setOpenMouth( _value : bool ) -> void:
	if openMouth != _value:
		openMouth = _value
		updatePortrait()
