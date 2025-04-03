extends Sprite2D

# This script controls the panning of the sprite texture

@export var speed : float = 100

var rect : Rect2

func _ready() -> void:
	rect = self.region_rect

func _process(delta: float) -> void:
	region_rect.position += Vector2( speed * delta, 0 )
