class_name SlotData extends Resource
#we dont create multiple instances of this one, we create stuff with this through code

@export var itemData : ItemData
@export var quantity : int = 0 : set = setQuantity

func setQuantity( value : int ) -> void:
	quantity = value
	if quantity < 1:
		emit_changed() #built in signal for resources
