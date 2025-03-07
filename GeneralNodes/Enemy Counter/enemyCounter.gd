class_name EnemyCounter extends Node2D


signal EnemiesDefeated



func _ready() -> void:
	#anytime one of the children of this node exits the tree we connect to this signal and run func
	child_exiting_tree.connect( _onEnemyDestroyed )
	pass


#every time an enemy is destroyed we wanna check what happened
func _onEnemyDestroyed( e : Node2D ) -> void:
	if e is Enemy:
		if enemyCount() <= 1: #1 not 0, my code is necromancy
			EnemiesDefeated.emit()
	pass


func enemyCount() -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count += 1
	
	return _count
