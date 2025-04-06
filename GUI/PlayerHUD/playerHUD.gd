#do not want a classname for autoloads :(
extends CanvasLayer

var hearts : Array[ HeartGUI ] = []


@onready var boss_ui : Control = $Control/BossUI
@onready var bossHPBar : TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label : Label = $Control/BossUI/Label





func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false #turn em all off by default
	
	hideBossHealth()
	
	pass

func updateHP( _hp: int, _maxHP: int ) -> void:
	updateMaxHP( _maxHP )
	for i in _maxHP:
		updateHeart( i, _hp )
		pass
	pass

func updateHeart( _index : int, _hp : int ) -> void:
	var _value : int = clamp( _hp - _index * 2, 0, 2 ) #figures out half hearts
	hearts[ _index ].value = _value
	pass 


func updateMaxHP( _maxHP : int ) -> void:
	var _heartCount : int = roundi( _maxHP * 0.5 ) #rounded obvz
	for i in hearts.size():
		if i < _heartCount:
			hearts[i].visible = true
		else:
			hearts[i].visible = false #goes over every heart and turns them visible or invisible depending on max health
	pass


#Gameover stuff here


func showBossHealth( name : String ) -> void:
	boss_label.text = name 
	boss_ui.visible = true
	updateBossHealth( 1, 1 )

func hideBossHealth() -> void:
	boss_ui.visible = false

func updateBossHealth( hp : int, maxHP : int ) -> void:
	bossHPBar.value = clampf( float(hp) / float(maxHP) * 100, 0, 100 )
	pass
