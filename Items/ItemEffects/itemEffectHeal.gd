class_name ItemEffectHeal extends ItemEffect
#the reason inheritance is cool with resources and is useful is as follows

@export var healAmount : int = 1
@export var sound : AudioStream

func use() -> void:
	PlayerManager.player.updateHP( healAmount )
	#lets manage the sound in pause menu, its an autoload script
	PauseMenu.playAudio( sound )
