class_name InventoryData extends Resource
#here is the resource that keeps track of inv data, see slotData.gd for other fun stuff

signal EquipmentChanged

@export var slots : Array[ SlotData ]
var equipmentSlotCount : int = 4

#ready for resources
func _init() -> void:
	connectSlots()

func inventorySlots() -> Array[ SlotData ]:
	# We only want to return the inventory slots that are not equipped items
	return slots.slice( 0, -equipmentSlotCount )

func equipmentSlots() -> Array[ SlotData ]:
	# We only want to return the equippable slots
	return slots.slice( -equipmentSlotCount, slots.size() )


#some cool stuff, we can add functions to resources! even though this just tracks data, funcs can organise
#return bool so that if the inv is full, we can return false. also needs to be smart enough to stack items
func addItem( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.itemData == item: #does the item data of the slot equal the item we pass it in?
				s.quantity += count
				return true
	
	#what if we pick up an item, but we dont already have it?
	for i in inventorySlots().size():
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

func equipItem( slot : SlotData ) -> void:
	# Make sure that we have a valid slot or item to equip
	if slot == null or not slot.itemData is EquippableItemData:
		return
	
	var item : EquippableItemData = slot.itemData
	var slotIndex : int = slots.find( slot ) # Returns index of the parameter in the array
	var equipmentIndex : int = slots.size() - equipmentSlotCount # 20 (21) by default for Armour
	
	match item.type: # Weapon, Armour, Amulet, Ring
		EquippableItemData.Type.ARMOUR:
			equipmentIndex += 0
		EquippableItemData.Type.WEAPON:
			equipmentIndex += 1 # 21
		EquippableItemData.Type.AMULET:
			equipmentIndex += 2 # 22
		EquippableItemData.Type.RING:
			equipmentIndex += 3 # 23
	
	var unequippedSlot : SlotData = slots[ equipmentIndex ]
	
	# Swap slots in the array by overwriting whatever was at slotIndex
	slots[ slotIndex ] = unequippedSlot
	# Swap slot in the equipment index by overwriting with slot
	slots[ equipmentIndex ] = slot
	# The two items in two slots have now swapped in one process frame
	
	EquipmentChanged.emit()
	PauseMenu.focusItemChanged( unequippedSlot )

func getAttackBonus() -> int:
	return getEquipmentBonus( EquippableItemModifier.Type.ATTACK )

func getAttackBonusDiff( item : EquippableItemData ) -> int:
	# Calculate what the value is before and after any item would be equipped
	var before : int = getAttackBonus()
	var after : int = getEquipmentBonus( EquippableItemModifier.Type.ATTACK, item ) # Being compared
	
	return after - before

func getDefenseBonus() -> int:
	return getEquipmentBonus( EquippableItemModifier.Type.DEFENSE )

func getDefenseBonusDiff( item : EquippableItemData ) -> int:
	var before : int = getDefenseBonus()
	var after : int = getEquipmentBonus( EquippableItemModifier.Type.DEFENSE, item )
	return after - before

func getBodyBonus() -> int:
	return getEquipmentBonus( EquippableItemModifier.Type.BODY )

func getBodyBonusDiff( item : EquippableItemData ) -> int:
	var before : int = getBodyBonus()
	var after : int = getEquipmentBonus( EquippableItemModifier.Type.BODY, item )
	return after - before

# Can detect any type of bonus
func getEquipmentBonus( bonusType : EquippableItemModifier.Type, compare : EquippableItemData = null ) -> int:
	var bonus : int = 0
	# Calculate the bonus based on the type passed in
	for s in equipmentSlots():
		if s == null:
			continue
		var e : EquippableItemData = s.itemData
		if compare:
			if e.type == compare.type: # Same type, we want to update bonus labels
				e = compare
		for m in e.modifiers: # Iterate over all modifiers regardless of type
			if m.type == bonusType: # Goes through all types and increases/does nothing
				bonus += m.value
	
	return bonus
