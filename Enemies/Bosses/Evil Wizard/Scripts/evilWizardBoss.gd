#This script aims to unify all three elements of the boss, BossNode, BeamAttacks, and PositionTargets

class_name EvilWizardBoss extends Node2D

const ENERGYEXPLOSIONSCENE : PackedScene = preload("res://Enemies/Bosses/Evil Wizard/energyExplosion.tscn")
const ENERGYORBSCENE : PackedScene = preload("res://Enemies/Hazards/Energy Orb/energyOrb.tscn")

@export var maxHP : int = 10
var hp : int = 10

var audioHurt : AudioStream = preload("res://Resources/Michael Games Sprites/wizard_boss/boss_hurt.wav")
var audioShoot : AudioStream = preload("res://Resources/Michael Games Sprites/wizard_boss/boss_fireball.wav")

var currentPositionIndex : int = 0
var positions : Array[ Vector2 ]
var beamAttacks : Array[ EnergyBeamAttack ]
var damageCount : int = 0

@onready var animation_player : AnimationPlayer = $BossNode/AnimationPlayer
@onready var animation_player_damaged: AnimationPlayer = $BossNode/AnimationPlayerDamaged
@onready var cloak_animation_player: AnimationPlayer = $BossNode/CloakSprite/AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $BossNode/AudioStreamPlayer2D
@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: hitBox = $BossNode/HitBox

@onready var hand_01: Sprite2D = $BossNode/CloakSprite/Hand01
@onready var hand_02: Sprite2D = $BossNode/CloakSprite/Hand02
@onready var hand_01_up: Sprite2D = $BossNode/CloakSprite/Hand01Up
@onready var hand_02_up: Sprite2D = $BossNode/CloakSprite/Hand02Up
@onready var hand_01_horizontal: Sprite2D = $BossNode/CloakSprite/Hand01Horizontal
@onready var hand_02_horizontal: Sprite2D = $BossNode/CloakSprite/Hand02Horizontal
@onready var door_block: TileMapLayer = $"../DoorBlock/Walls"

func _ready() -> void:
	persistent_data_handler.getValue()
	
	if persistent_data_handler.value == true: #True means boss has been defeated
		door_block.enabled = false
		print("GET SHIIIT ON")
		queue_free()
		return
	
	hp = maxHP
	PlayerHud.showBossHealth( "EEEEEvil Wizard" )
	hit_box.Damaged.connect( damageTaken )
	
	for c in $PositionTargets.get_children():
		positions.append( c.global_position )
	$PositionTargets.visible = false
	
	for b in $BeamAttacks.get_children():
		beamAttacks.append( b )
	
	print( persistent_data_handler.value )
	
	teleport( 0 )


func _process( _delta: float ) -> void:
	#Syncs unique hand frames and position
	#Offsets for positions of horizontal stuff done in OFFSET of parent node rather than transform
	hand_01_up.position = hand_01.position
	hand_01_up.frame = hand_01.frame + 4 #Animations must sync 
	hand_02_up.position = hand_02.position
	hand_02_up.frame = hand_02.frame + 4
	hand_01_horizontal.position = hand_01.position
	hand_01_horizontal.frame = hand_01.frame + 8
	hand_02_horizontal.position = hand_02.position
	hand_02_horizontal.frame = hand_02.frame + 12
	
	pass

func teleport( _location : int  ) -> void:
	#Make the boss disappear
	animation_player.play( "disappear" )
	enableHitboxes( false )
	damageCount = 0
	
	#Shoot Energy Orb after a sec if boss is damaged
	if hp < maxHP:
		shootOrb()
	await get_tree().create_timer( 1 ).timeout
	
	#Moves Location, making sure not to move to the same spot
	boss_node.global_position = positions[ _location ]
	currentPositionIndex = _location
	
	#Update Direction of animations
	updateAnimations()
	
	#Reappear the boss and go Idle
	animation_player.play( "appear" )
	await animation_player.animation_finished
	idle()

func idle() -> void:
	enableHitboxes()
	#Possible chance of variation and skipping idle anim to keep attacks spontaneous
	if randf() <= float(hp) / float(maxHP):
		#Play Idle animation
		animation_player.play( "idle" )
		await animation_player.animation_finished
		if hp < 1:
			return
	
	#Begin a beam attack based on position
	if damageCount < 1:
		energyBeamAttack()
		animation_player.play( "castSpell" )
		await animation_player.animation_finished
	
	if hp < 1:
			return
	
	#Teleport again to a random non current location
	var _t : int = currentPositionIndex #Int from 0-3
	while _t == currentPositionIndex:
		_t = randi_range( 0, 3 )
	teleport( _t )
	pass
	

func updateAnimations() -> void:
	#Syncs hands and body positions to match direction facing
	boss_node.scale = Vector2( 3, 3 )
	
	hand_01.visible = false
	hand_02.visible = false
	hand_01_up.visible = false
	hand_02_up.visible = false
	hand_01_horizontal.visible = false
	hand_02_horizontal.visible = false
	
	if currentPositionIndex == 0:
		cloak_animation_player.play( "down" )
		hand_01.visible = true
		hand_02.visible = true
	elif currentPositionIndex == 2:
		cloak_animation_player.play( "up" )
		hand_01_up.visible = true
		hand_02_up.visible = true
	else:
		cloak_animation_player.play( "horizontal" )
		hand_01_horizontal.visible = true
		hand_02_horizontal.visible = true
		if currentPositionIndex == 1:
			boss_node.scale = Vector2( -3, 3 ) #Scales the whole boss node to face left/right

func energyBeamAttack() -> void:
	var _b : Array[ int ]
	match currentPositionIndex:
		0, 2: #means we are at the top or bottom
			if currentPositionIndex == 0:
				_b.append( 0 ) #Beam on the boss
				_b.append( randi_range( 1, 2 ) ) #Beams below boss
			else:
				_b.append( 2 )
				_b.append( randi_range( 0, 1 ) )
			if hp < 5: #half health ish
				_b.append( randi_range( 3, 5 ) )
		1, 3:
			if currentPositionIndex == 3:
				_b.append( 5 )
				_b.append( randi_range( 3, 4 ) )
			else:
				_b.append( 3 )
				_b.append( randi_range( 4, 5 ) )
			if hp < 5: #half health ish
				_b.append( randi_range( 0, 2 ) )
	
	for b in _b:
		beamAttacks[ b ].attack()

func shootOrb() -> void:
	var b : Node2D = ENERGYORBSCENE.instantiate()
	b.global_position = boss_node.global_position + Vector2( 0, -34 )
	get_parent().add_child.call_deferred( b )
	playAudio( audioShoot )

func damageTaken( _hurtBox : HurtBox ) -> void:
	if animation_player_damaged.current_animation == "damaged" or _hurtBox.damage == 0:
		return #give our boss some i frames based on the animation length
	playAudio( audioHurt )
	hp = clampi( hp - _hurtBox.damage, 0, maxHP )
	damageCount += 1
	
	#Update boss healthbar
	PlayerHud.updateBossHealth( hp, maxHP )
	
	animation_player_damaged.play( "damaged" )
	animation_player_damaged.seek( 0 ) #possibility we were already playing anim
	animation_player_damaged.queue( "default" )
	if hp < 1:
		defeat()
	

func playAudio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()

func defeat() -> void:
	animation_player.play( "destroy" )
	enableHitboxes( false ) #disables hitboxes
	PlayerHud.hideBossHealth()
	persistent_data_handler.setValue()
	await animation_player.animation_finished
	door_block.enabled = false

func enableHitboxes( _v : bool = true ) -> void:
	hit_box.set_deferred( "monitorable", _v )
	hurt_box.set_deferred( "monitoring", _v )

func explosion( _p : Vector2 = Vector2.ZERO ) -> void:
	var e : Node2D = ENERGYEXPLOSIONSCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred( e )
