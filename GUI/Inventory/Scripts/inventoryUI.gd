class_name InventoryUI extends Control

const INVENTORYSLOT = preload("res://GUI/Inventory/inventorySlot.tscn")

@export var data : InventoryData


func _ready() -> void:
	PauseMenu.Shown.connect( updateInventory )
	PauseMenu.Hidden.connect( clearInventory )
	#when we run lets start with a clean slate
	clearInventory()
	data.changed.connect( onInventoryChanged )
	pass


#in order to make our inventory work we wanna a. clear old items, b. update to display new ones

func clearInventory() -> void:
	for c in get_children():
		c.queue_free()

func updateInventory() -> void:
	for s in data.slots:
		#first we need to create a slot, add it to the container, and add some slot data
		var newSlot = INVENTORYSLOT.instantiate()
		add_child( newSlot )
		#as we add each slot to the inventory,
		newSlot.slotData = s
	
	get_child( 0 ).grab_focus()

func onInventoryChanged() -> void:
	clearInventory()
	updateInventory()
	pass
