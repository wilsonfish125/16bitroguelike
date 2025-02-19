class_name PlayerStateMachine extends Node

var states : Array[ State ]
var previousState : State
var currentState : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState( currentState.Process( delta ) ) #we want it in the state form only, function returns either null or a state
	pass

func _physics_process(delta: float) -> void:
	changeState( currentState.Physics( delta ) ) #we want it in the state form only, function returns either null or a state
	pass

func _unhandled_input(event):
	changeState( currentState.HandleInput( event ) )


func initialise( _player : Player ) -> void:
	states = []
	#get (seek and destroy) all of our states in the machine and throw em in the array
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].stateMachine = self
	
	
	for state in states:
		state.init()
	
	changeState( states[0] )
	process_mode = Node.PROCESS_MODE_INHERIT


func changeState(newState : State) -> void:
	if newState == null || newState == currentState:
		return ##end of the function
	
	if currentState:
		currentState.Exit() #States ALL have an exit function
	
	previousState = currentState
	currentState = newState
	currentState.Enter() #States ALL have an enter function
	
