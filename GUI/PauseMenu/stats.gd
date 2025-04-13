class_name Stats extends PanelContainer

@onready var labelLevel: Label = $VBoxContainer/HBoxContainer/Label2
@onready var labelXP: Label = $VBoxContainer/HBoxContainer2/Label2
@onready var labelAttack: Label = $VBoxContainer/HBoxContainer3/Label2
@onready var labelDefense: Label = $VBoxContainer/HBoxContainer4/Label2
@onready var labelBody: Label = $VBoxContainer/HBoxContainer5/Label2
@onready var labelSkillTreePoints: Label = $VBoxContainer/HBoxContainer6/Label2

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
