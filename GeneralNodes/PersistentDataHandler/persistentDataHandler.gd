class_name PersistentDataHandler extends Node
#this nodes sole purpose is to be dragged and dropped onto stuff we want to be persistent/saved
# It will save data for us

signal DataLoaded #indicates whenever data is loaded so things can respond to that
var value : bool = false

func _ready() -> void:
	getValue() #we always wanna check if value is true (open) or false (closed)
	pass

func setValue() -> void:
	SaveManager.addPersistentValue( _getName() )
	pass

func getValue() -> void:
	value = SaveManager.checkPersistentValue( _getName() )
	DataLoaded.emit()
	pass

func removeValue() -> void:
	SaveManager.removePersistentValue( _getName() )
	pass

func _getName() -> String: #this is how we get the unique identifier of every object and its level root
	#gonna look like "res://levels/area01/01.tscn/treasurechest/PersistentDataHandler"
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
