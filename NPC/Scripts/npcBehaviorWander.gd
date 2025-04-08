@tool
extends NPCBehavior

const DIRECTIONS = [ Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT ]

@export var wanderRange : int = 2 : set = _setWanderRange
@export var wanderSpeed : float = 30.0
@export var wanderDuration : float = 1.0
@export var idleDuration : float = 1.0

var originalPosition : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super() #runs the parents ready function as well, holy shit
	$CollisionShape2D.queue_free()
	originalPosition = npc.global_position

func _process( _delta: float ) -> void:
	if Engine.is_editor_hint():
		return

func start() -> void:
	 #IDLE PHASE
	if npc.canDoBehavior == false:
		return
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.updateAnimation()
	await get_tree().create_timer( randf() * idleDuration + idleDuration ).timeout 
	if npc.canDoBehavior == false:
		return
	
	 #WALK PHASE
	npc.state = "walk"
	var _dir : Vector2 = DIRECTIONS[ randi_range( 0, 3 ) ]
	if abs( global_position.distance_to( originalPosition ) ) > wanderRange * 48 :
		#pick a new direction closest to wander area here instead of every frame
		var dirToArea : Vector2 = global_position.direction_to( originalPosition )
		var bestDirections : Array[ float ]
		for d in DIRECTIONS:
			bestDirections.append( d.dot( dirToArea ) )
		_dir = DIRECTIONS[ bestDirections.find( bestDirections.max() ) ] #biggest numba in array
	npc.direction = _dir
	npc.velocity = wanderSpeed * _dir
	npc.updateDirection( global_position + _dir )
	npc.updateAnimation()
	
	await get_tree().create_timer( randf() * wanderDuration + wanderDuration ).timeout 
	 #REPEAT
	if npc.canDoBehavior == false:
		return
	start()




func _setWanderRange( v : int ) -> void:
	wanderRange = v
	$CollisionShape2D.shape.radius = v * 32.0
