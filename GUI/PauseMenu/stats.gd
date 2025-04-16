class_name Stats extends PanelContainer

@onready var labelLevel: Label = %LabelLevel
@onready var labelXP: Label = %LabelXP
@onready var labelAttack: Label = %LabelAttack
@onready var labelDefense: Label = %LabelDefense
@onready var labelBody: Label = %LabelBody
@onready var labelSkillTreePoints: Label = %LabelSkillTreePoints
@onready var label_attack_change: Label = %LabelAttackChange
@onready var label_defense_change: Label = %LabelDefenseChange
@onready var label_body_change: Label = %LabelBodyChange


func _ready() -> void:
	PauseMenu.Shown.connect( updateStats )

func updateStats() -> void:
	# Grab the player, check stats, update stats
	var _p : Player = PlayerManager.player
	labelLevel.text = str( _p.level )
	
	if _p.level < PlayerManager.levelRequirements.size():
		labelXP.text = str( _p.xp ) + "/" + str( PlayerManager.levelRequirements[ _p.level ] )
	else: # Must mean we are at Max Level
		labelXP.text = "Max Level"
	
	labelAttack.text = str( _p.attackStat )
	labelDefense.text = str( _p.defenceStat )
	labelBody.text = str( _p.bodyStat )
	labelSkillTreePoints.text = str( _p.skillTreePoints )
