class_name InventorySlotUI extends Button

#each button needs to keep track of slot data assigned to it
var slotData : SlotData : set = setSlotData #whenever we set slotData, call the function setSlotData

# The click and drag inventory system works by duplicating the TEXTYRE only
var clickPos : Vector2 = Vector2.ZERO
var dragging : bool = false
var dragTexture : Control
var dragThreshold : float = 16 * 3 # Change when scaling is fixed

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
	
	button_down.connect( onButtonDown )
	button_up.connect( onButtonUp )

func _process( _delta: float ) -> void:
	# Take our duplicated texture and move it around, only if we are dragging
	if dragging:
		dragTexture.position = get_local_mouse_position() - Vector2( 16, 16 )
		# If we have moved our mouse outside of the drag threshold, we hover texture
		if outsideDragThreshold() == true:
			dragTexture.modulate.a = 0.5
		else:
			dragTexture.modulate.a = 0.0

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
	if slotData and outsideDragThreshold() == false:
		if slotData.itemData:
			# Item is valid, get a reference to it
			var item = slotData.itemData
			
			# Equippable Items
			if item is EquippableItemData:
				PlayerManager.INVENTORYDATA.equipItem( slotData )
				return
			
			# Non equippable Items
			var wasUsed = item.use() #this returns a boolean remember
			if wasUsed == false:
				return
			slotData.quantity -= 1
			if slotData == null:
				return
			label.text = str( slotData.quantity )

func onButtonDown() -> void:
	# Set values of our dragging variables, get a COPY of the texture to follow mouse
	clickPos = get_global_mouse_position()
	dragging = true
	dragTexture = texture_rect.duplicate()
	dragTexture.z_index = 99 # Must be highest
	dragTexture.mouse_filter = Control.MOUSE_FILTER_IGNORE # Bugfix for preventing dragging backwards
	add_child( dragTexture )

func onButtonUp() -> void:
	dragging = false
	if dragTexture:
		dragTexture.free()

func outsideDragThreshold() -> bool:
	if get_global_mouse_position().distance_to( clickPos ) > dragThreshold:
		return true
	return false
