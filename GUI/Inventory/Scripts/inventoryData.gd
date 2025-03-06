class_name InventoryData extends Resource
#here is the resource that keeps track of inv data, see slotData.gd for other fun stuff

@export var slots : Array[ SlotData ]


#ready for resources
func _init() -> void:
	connectSlots()
	pass

#some cool stuff, we can add functions to resources! even though this just tracks data, funcs can organise
#return bool so that if the inv is full, we can return false. also needs to be smart enough to stack items
func addItem( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s: #if s is not null,
			if s.itemData == item: #does the item data of the slot equal the item we pass it in?
				s.quantity += count
				return true
	#what if we pick up an item, but we dont already have it?
	for i in slots.size(): #if it works it works!!
		if slots[ i ] == null: #if there is an empty slot, lets add the item
			var newSlot = SlotData.new() #we are programmers so all we do is copy paste
			newSlot.itemData = item
			newSlot.quantity = count
			slots[ i ] = newSlot #append this original null value with the new slot we just made
			newSlot.changed.connect( slotChanged )
			return true
	
	print("inventory was full stupido")
	return false

func connectSlots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slotChanged )

func slotChanged() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slotChanged )
				var index = slots.find( s ) #get the index number of slot in question
				slots[ index ] = null
				emit_changed()
	pass

#lets localise the save data stuff, keep it here 

#Gather the inventory into an array
func getSaveData() -> Array:
	var itemSave : Array = []
	for i in slots.size():
		itemSave.append( itemToSave( slots[i] ) )
	return itemSave

#Convert each inventory item into a dictionary
func itemToSave( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.itemData != null:
			result.item = slot.itemData.resource_path #path to the file
	
	return result

#Lets do the reverse for loading. Take the array of dictionary and convert back to array of slotdata
func parseSaveData( saveData : Array ) -> void:
	#if we change the number of slots we wanna change it here
	var arraySize = slots.size()
	slots.clear()
	slots.resize( arraySize )
	for i in saveData.size():
		slots[ i ] = itemFromSave( saveData[ i ] )
	connectSlots()

func itemFromSave( saveObj : Dictionary ) -> SlotData:
	if saveObj.item == "":
		return null
	var newSlot : SlotData = SlotData.new()
	newSlot.itemData = load( saveObj.item )
	newSlot.quantity = int( saveObj.quantity )
	return newSlot


func useItem( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s: #if there is a valid item in an inventory slot
			if s.itemData == item and s.quantity >= count: #is it the right item and amount REMEMBER GREATER OR EQUAL
				s.quantity -= count
				return true
	return false
