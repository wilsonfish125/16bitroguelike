class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.TilemapBoundsChanged.connect( updateLimits )
	updateLimits( LevelManager.currentTilemapBounds ) #force update on first run of script
	pass # Replace with function body.


#Manipulates the limits of the camera node, we use vectors cuz we are goated
func updateLimits( bounds : Array[ Vector2 ] ) -> void:
	if bounds == []:
		return
	#if not, we do this
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y ) #First Vector2 we pass in is top left corner
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y ) #Second Vector2 we pass in is bottom right corner
	pass
