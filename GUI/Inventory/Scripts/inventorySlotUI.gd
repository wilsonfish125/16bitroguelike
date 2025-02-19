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
		return
	texture_rect.texture = slotData.itemData.texture
	label.text = str( slotData.quantity )
	pass

func itemFocused() -> void:
	if slotData != null:
		if slotData.itemData != null:
			PauseMenu.updateItemDescription( slotData.itemData.description )
	pass

func itemUnfocused() -> void:
	PauseMenu.updateItemDescription( "" )
	pass

func itemPressed() -> void:
	if slotData:
		if slotData.itemData:
			var wasUsed = slotData.itemData.use() #this returns a boolean remember
			if wasUsed == false:
				return
			slotData.quantity -= 1
			label.text = str( slotData.quantity )
	pass
