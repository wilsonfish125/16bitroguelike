class_name ItemData extends Resource
#lets mess around with resources! for each item we wanna have some base stuff
@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D

#lets make this resource more powerful

@export_category("Item Use Effects")
@export var effects : Array[ ItemEffect ] #ANY RESOURCE that extends ItemEffect can be added here, infinte stuff

func use() -> bool:
	if effects.size() == 0:
		return false #if we try to use an item we cant use we say nah
	
	for e in effects:
		e.use() #for all the effects in there we call our use function
	return true
	
