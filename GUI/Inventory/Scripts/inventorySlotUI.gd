class_name InventorySlotUI extends Button

#each button needs to keep track of slot data assigned to it
var slotData : SlotData : set = setSlotData #whenever we set slotData, call the function setSlotData

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	#since this is a button, lets take advantage of inbuilt godot button signals
	focus_entered.connect( itemFocused )
	focus_exited.connect( itemUnfocused )
	
	#lets check if the button gets pressed
	pressed.connect( itemPressed )
	pass

#we need a function to set the data of each inv slot
func setSlotData( value : SlotData ) -> void:
	slotData = value
	if slotData == null:
		# If there is an item here, and it becomes null, we want to clear its properties
		texture_rect.texture = null
		label.text = ""
		return
	
	texture_rect.texture = slotData.itemData.texture
	if slotData.itemData is EquippableItemData:
		label.text = "" # Equipment should only have one instance in the world
	else:
		label.text = str( slotData.quantity )
	

func itemFocused() -> void:
	PauseMenu.focusItemChanged( slotData )

func itemUnfocused() -> void:
	PauseMenu.updateItemDescription( "" )
	pass

func itemPressed() -> void:
	if slotData:
		if slotData.itemData:
			# Item is valid, get a reference to it
			var item = slotData.itemData
			
			# Equippable Items
			if item is EquippableItemData:
				PlayerManager.INVENTORYDATA.equipItem( slotData )
				return
			
			# Unequippable Items
			var wasUsed = item.use() #this returns a boolean remember
			if wasUsed == false:
				return
			slotData.quantity -= 1
			label.text = str( slotData.quantity )
