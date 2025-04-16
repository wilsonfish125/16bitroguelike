class_name Stats extends PanelContainer

var inventory : InventoryData

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
	PauseMenu.PreviewStatsChanged.connect( _onPreviewStatsChanged )
	inventory = PlayerManager.INVENTORYDATA
	inventory.EquipmentChanged.connect( updateStats )

func updateStats() -> void:
	# Grab the player, check stats, update stats
	var _p : Player = PlayerManager.player
	labelLevel.text = str( _p.level )
	
	if _p.level < PlayerManager.levelRequirements.size():
		labelXP.text = str( _p.xp ) + "/" + str( PlayerManager.levelRequirements[ _p.level ] )
	else: # Must mean we are at Max Level
		labelXP.text = "Max Level"
	
	labelAttack.text = str( _p.attackStat + inventory.getAttackBonus() )
	labelDefense.text = str( _p.defenceStat + inventory.getDefenseBonus() )
	labelBody.text = str( _p.bodyStat + inventory.getBodyBonus() )
	labelSkillTreePoints.text = str( _p.skillTreePoints )

func _onPreviewStatsChanged( item : ItemData ) -> void:
	# Take bonus labels and change them according to item stats/if there is any item at all
	label_attack_change.text = ""
	label_defense_change.text = ""
	label_body_change.text = ""
	
	if not item is EquippableItemData:
		return # Regular items stop right here
	
	var equipment : EquippableItemData = item # We know it is equippable, cast it as such
	var attackChange : int = inventory.getAttackBonusDiff( equipment )
	var defenseChange : int = inventory.getDefenseBonusDiff( equipment )
	var bodyChange : int = inventory.getBodyBonusDiff( equipment )
	
	updageChangeLabel( label_attack_change, attackChange )
	updageChangeLabel( label_defense_change, defenseChange )
	updageChangeLabel( label_body_change, bodyChange )

func updageChangeLabel( label : Label, value : int ) -> void:
	# Update and Modulate label depending on if stat is below or above zero
	if value > 0:
		label.text = "+" + str( value )
		label.modulate = Color.LIGHT_GREEN
	elif value < 0:
		label.text = str( value )
		label.modulate = Color.INDIAN_RED
