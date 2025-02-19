class_name LevelTilemap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.changeTilemapBounds( getTilemapBounds() )
	pass # Replace with function body.


func getTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	#in order to get the bounds, we append an item to the bounds array
	bounds.append(
		Vector2( get_used_rect().position * rendering_quadrant_size * 3) #we need the vector 2 to be a pixel number, NOT a tile number
	) #Top left of tileset
	bounds.append(
		Vector2( get_used_rect().end * rendering_quadrant_size * 3)
	) #Bottom right of tileset
	return bounds
