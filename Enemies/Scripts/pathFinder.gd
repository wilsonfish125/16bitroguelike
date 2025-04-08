class_name PathFinder extends Node2D

#We instantiate this at runtime so we dont NEED pathfinders on every enemy

var vectors : Array[Vector2] = [ # THIS IS IN CLOCKWISE ORDER OF NODE TREE BE AWARE
		Vector2(0, -1),     #UP
		Vector2( 1, -1 ),   #UPRIGHT
		Vector2( 1, 0 ),    #RIGHT
		Vector2( 1, 1 ),    #DOWNRIGHT
		Vector2( 0, 1 ),    #DOWN
		Vector2( -1, 1 ),   #DOWNLEFT
		Vector2( -1 ,0 ),   #LEFT
		Vector2( -1, -1 ),  #UPLEFT
]

#Instead of tracking if ray is hitting obstacle, track if obstacle is there with a float
#Clockwise around the circle of rays (see node)
var obstacles : Array[ float ]  = [0, 0, 0, 0, 0, 0, 0, 0]
var rays : Array[ RayCast2D ] #A ray array
var interests : Array[ float ] #Shows which directions are "interesting" for enemy to go

var outcomes : Array[ float ] = [ 0, 0, 0, 0, 0, 0, 0, 0 ] #Final array, combo of obstacles and interests

var moveDirection : Vector2 = Vector2.ZERO
var bestPath : Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer

func _ready() -> void:
	 # Gather all Raycast 2D Nodes
	for c in get_children():
		if c is RayCast2D:
			rays.append( c )
	
	 # Normalise our Vectors array
	for i in vectors.size():
		vectors[ i ] = vectors[ i ].normalized()
	
	 # Check initial path
	setPath()
	
	 # Connect timer
	timer.timeout.connect( setPath )

func _process( delta: float ) -> void:
	 # Update movedir towards best path
	 # Other scripts refer to movedir
	 # Lerp method stops jittering
	moveDirection = lerp( moveDirection, bestPath, 10 * delta )
	

 # Sets the best path that enemy would want to follow as a vector 
 # Done by checking desired direction and considering obstacles
func setPath() -> void:
	 # Get direction to the player with player singleton
	var playerDir : Vector2 = global_position.direction_to( PlayerManager.player.global_position )
	 # Reset pre existing obstacle and outcome values
	for i in 8:
		obstacles[ i ] = 0
		outcomes[ i ] = 0
	 # Check each RayCast2D for collisions & update values in obstacle array accordingly
	for i in 8:
		if rays[ i ].is_colliding():
			obstacles[ i ] += 4  
			obstacles[ getNextI( i ) ] += 1 #Bias surrounding rays
			obstacles[ getPrevI( i ) ] += 1
	 # If there are NO obstacles, reccomend path DIRECTLY in direction of player
	if obstacles.max() == 0:
		bestPath = playerDir
		return
	 # If there ARE obstacles, clear then populate our interest array
	interests.clear()
	for v in vectors: #Loop through each direction and compare them with the direction to player
		#WE WANT THE DOT PRODUCT, takes two vectors and returns a SCALAR value
		#Measures how close two vectors are to overlapping, higher values mean more similar vectors
		interests.append( v.dot( playerDir ) )
	 # Populate outcomes array by combining interest and obstacle arrays
	for i in 8:
		outcomes[ i ] = interests[ i ] - obstacles[ i ] #print these values for debug if u need understanding
	 # Set the best path according to the highest value of outcomes array as a vector2
	bestPath = vectors[ outcomes.find( outcomes.max() ) ]

 # Returns the next Index, wrapping at 8
func getNextI( i : int )  -> int:
	var nI : int = i + 1
	if nI >= 8:
		return 0
	else:
		return nI 

 # Returns the previous Index, wrapping at 8
func getPrevI( i : int ) -> int:
	var nI : int = i - 1
	if nI < 0:
		return 7 #0-7 is 8 numbers
	else:
		return nI
