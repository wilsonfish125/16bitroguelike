class_name PlayerCamera extends Camera2D

@export_range( 0, 1, 0.05, "or_greater" ) var shakePower : float = 0.5 #Overall shake strength
@export var shakeMaxOffset : float = 5.0 #Max shake in pixels 
@export var shakeDecay : float = 1.0 #How quickly the shake stops

var shakeTrauma : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.TilemapBoundsChanged.connect( updateLimits )
	updateLimits( LevelManager.currentTilemapBounds ) #force update on first run of script
	PlayerManager.CameraShook.connect( addCameraShake ) 

func _physics_process(delta: float) -> void:
	
	if shakeTrauma > 0:
		shakeTrauma = max( shakeTrauma - shakeDecay * delta, 0 )
		shake()
	pass

func addCameraShake( val : float ) -> void:
	shakeTrauma = val

func shake() -> void:
	#calculate how much we shake each frame
	var amount : float = pow( shakeTrauma * shakePower, 2 )
	offset = Vector2( randf_range( -1, 1 ), randf_range( -1, 1 ) ) * shakeMaxOffset * amount
	pass

#Manipulates the limits of the camera node
func updateLimits( bounds : Array[ Vector2 ] ) -> void:
	if bounds == []:
		return
	#if not, we do this
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y ) #First Vector2 we pass in is top left corner
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y ) #Second Vector2 we pass in is bottom right corner
	pass
