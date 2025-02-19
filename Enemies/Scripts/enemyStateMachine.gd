class_name EnemyStateMachine extends Node


var states : Array[ EnemyState ]
var previousState : EnemyState
var currentState : EnemyState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState( currentState.process( delta ) )
	pass

func _physics_process(delta: float) -> void:
	changeState( currentState.physics( delta ) )


func initialise( _enemy : Enemy ) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	for s in states:
		s.enemy = _enemy
		s.stateMachine = self
		s.init()
	
	if states.size() > 0:
		changeState( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT #Allows enemies to pause with us when we pause the game


func changeState(newState : EnemyState) -> void:
	if newState == null || newState == currentState:
		return ##end of the function
	
	if currentState:
		currentState.exit() #States ALL have an exit function
	
	previousState = currentState
	currentState = newState
	currentState.enter() #States ALL have an enter function
	
