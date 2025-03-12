@tool
extends NPCBehavior

const COLOURS = [ Color(1, 0, 0), Color(1, 1, 0), Color(0, 1, 0), Color(0, 1, 1), Color(0, 0, 1), Color(1, 0, 1) ]

@export var walkSpeed : float = 60.0

var patrolLocations : Array = [ PatrolLocation ]
var currentLocationIndex : int = 0
var target : PatrolLocation


func _ready() -> void:
	gatherPatrolLocations()
	if Engine.is_editor_hint():
		child_entered_tree.connect( gatherPatrolLocations )
		child_order_changed.connect( gatherPatrolLocations )
		return
	super()
	if patrolLocations.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrolLocations[ 0 ]

func _process( _delta: float ) -> void:
	if Engine.is_editor_hint():
		return
	
	if npc.global_position.distance_to( target.targetPosition ) < 1:
		start()


func gatherPatrolLocations( _n : Node = null ) -> void: #only passing through a node to satisfy childenteredtree
	patrolLocations = []
	for c in get_children():
		if c is PatrolLocation:
			patrolLocations.append( c )
	
	if Engine.is_editor_hint():
		if patrolLocations.size() > 0:
			for i in patrolLocations.size():
				var _p = patrolLocations[ i ] as PatrolLocation
				
				
				if not _p.transformChanged.is_connected( gatherPatrolLocations ):
					_p.transformChanged.connect( gatherPatrolLocations )
				
				
				_p.updateLabel( str(i) )
				_p.modulate = _getColourByIndex( i )
				
				var _next : PatrolLocation
				if i < patrolLocations.size() - 1:
					_next = patrolLocations[ i + 1 ]
				#if above condition is not true we are on the last item, gotta reset back to start
				else:
					_next = patrolLocations[ 0 ]
				_p.updateLine( _next.position )
	pass

func start() -> void:
	if npc.canDoBehavior == false or patrolLocations.size() < 2:
		return
	
	 #IDLE PHASE
	npc.global_position = target.targetPosition
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.updateAnimation()
	
	var waitTime : float = target.waitTime #getting this now so that we can use it later for specific reason
	#the specific reason is so it doesnt simultaneously look for a target and be on a target
	currentLocationIndex += 1
	if currentLocationIndex >= patrolLocations.size():
		currentLocationIndex = 0
	
	target = patrolLocations[ currentLocationIndex ]
	
	await get_tree().create_timer( waitTime ).timeout
	
	if npc.canDoBehavior == false:
		return
	
	 #WALK PHASE
	
	npc.state = "walk"
	var _dir = global_position.direction_to( target.global_position )
	npc.direction = _dir
	npc.velocity = walkSpeed * _dir
	npc.updateDirection( target.targetPosition )
	npc.updateAnimation()

func _getColourByIndex( i : int ) -> Color :
	var colourCount : int = COLOURS.size()
	while i > colourCount - 1:
		i -= colourCount
	return COLOURS[ i ]
