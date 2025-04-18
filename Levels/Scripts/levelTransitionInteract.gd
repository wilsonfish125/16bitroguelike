@tool
class_name LevelTransitionInteract extends LevelTransition

func _ready() -> void:
	super()
	area_entered.connect( _onAreaEntered )
	area_exited.connect( _onAreaExit )


func playerInteract() -> void:
	# What happens when the player interacts and the conditions are right?
	_playerEntered( PlayerManager.player )

func _onAreaEntered( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.connect( playerInteract )

func _onAreaExit( _a : Area2D ) -> void:
	PlayerManager.InteractPressed.disconnect( playerInteract )

func _updateArea() -> void:
	super()
