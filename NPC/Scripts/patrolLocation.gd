@tool #basically only using this in the editor, sprites disabled on runtime
class_name PatrolLocation extends Node2D

signal transformChanged

#how long the npc pauses at this location during patrol
@export var waitTime : float = 0.0 :
	set( v ): #good use of a set function when its simple and rarely used again
		waitTime = v
		_updateWaitTimeLabel()

var targetPosition : Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	set_notify_transform( true ) #now we are notified when the transform changes, but still need to emit signal

func _notification( what: int ) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transformChanged.emit()


func _ready() -> void:
	targetPosition = global_position
	_updateWaitTimeLabel()
	
	if Engine.is_editor_hint():
		return
	
	$Sprite2D.queue_free() #we only see sprites and children in editor


func updateLabel( _s : String ) -> void:
	$Sprite2D/Label.text = _s


func updateLine( nextLocation : Vector2 ) -> void:
	var line : Line2D = $Sprite2D/Line2D
	line.points[ 1 ] = nextLocation - position #offset as it is a child of the npc, goes nuts without -pos


func _updateWaitTimeLabel() -> void:
	if Engine.is_editor_hint():
		$Sprite2D/Label2.text = "wait: " + str( snappedf( waitTime, 0.1 ) ) + "s"
