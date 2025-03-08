extends Node

var musicAudioPlayerCount : int = 2
var currentMusicPlayer : int = 0 #index based, using against an array
var musicPlayers : Array[ AudioStreamPlayer ] = []
var musicBus : String = "Music" #string name of the audio bus we attatch to each music player

var musicFadeDuration : float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #even when paused/transitioning music still plays
	for i in musicAudioPlayerCount:
		var player = AudioStreamPlayer.new()
		add_child( player )
		player.bus = musicBus
		musicPlayers.append( player )
		player.volume_db = -40


func playMusic( _audio : AudioStream ) -> void:
	if _audio == musicPlayers[ currentMusicPlayer ].stream:
		return #if we are playing the same song we dont start it again
	
	currentMusicPlayer += 1
	if currentMusicPlayer > 1:
		currentMusicPlayer = 0
	
	var currentPlayer : AudioStreamPlayer  = musicPlayers[ currentMusicPlayer ] #not to be confused with the array
	currentPlayer.stream = _audio
	playAndFadeIn( currentPlayer )
	
	var oldPlayer = musicPlayers[ 1 ]
	if currentMusicPlayer == 1:
		oldPlayer = musicPlayers[ 0 ]
	fadeOutAndStop( oldPlayer )


func playAndFadeIn( player : AudioStreamPlayer ) -> void:
	player.play( 0 )
	var tween : Tween = create_tween()
	tween.tween_property( player, 'volume_db', 0, musicFadeDuration )

func fadeOutAndStop( player : AudioStreamPlayer ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( player, "volume_db", -40, musicFadeDuration )
	await tween.finished
	player.stop()
