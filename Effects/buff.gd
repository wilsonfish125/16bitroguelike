class_name Buff extends Resource

@export var buffName : String
@export var duration : float = 5.0
@export var attackBonus : int = 0
@export var defenseBonus : int = 0
@export var speedBonus : int = 0
@export var icon : Texture2D = null # For UI
@export var canMove : bool = true

#Future ideas: Stacking buffs, dispel type, synergies?

func _process( delta ):
	var expired = []
	
	for buff_dict in PlayerManager.player.activeBuffs:
		buff_dict.time_remaining -= delta
		if buff_dict.time_remaining <= 0:
			expired.append(buff_dict)
	
	for buff_dict in expired:
		if buff_dict.buff.has_method("expire"):
			buff_dict.buff.expire(self)
		PlayerManager.player.activeBuffs.erase(buff_dict)
	
	if expired.size() > 0:
		updateStats()


func applyBuff( buff : Buff ) -> void:
	PlayerManager.player.activeBuffs.append({
		"buff": buff,
		"time_remaining": buff.duration
	})
	# Apply immediate effects
	if buff.has_method("apply"):
		buff.apply(self)
	
	updateStats()

func updateStats():
	#STATS
	
	for buff_dict in PlayerManager.player.activeBuffs:
		var buff : Buff = buff_dict.buff
		PlayerManager.player.attackStat += buff.attackBonus
		PlayerManager.player.defenceStat += buff.defenseBonus
		PlayerManager.player.bodyStat += buff.speedBonus
	
	#hurt box stuff here
