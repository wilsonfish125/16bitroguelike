class_name DropData extends Resource

@export var item : ItemData #item we drop
@export_range( 0, 100, 1, "suffix:%" ) var probability : float = 100 #probability of drop of any item
@export_range( 1, 10, 1, "suffix:items" ) var minAmount : int = 1 #min amount to DROP
@export_range( 1, 10, 1, "suffix:items" ) var maxAmount : int = 1 

func getDropCount() -> int:
	if randf_range( 0, 100 ) >= probability:
		return 0
	return randi_range( minAmount, maxAmount ) #no need to use a variable
