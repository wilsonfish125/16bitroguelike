class_name InventoryUI extends Control

const INVENTORYSLOT = preload("res://GUI/Inventory/inventorySlot.tscn")

var focusIndex : int = 0
var hoveredItem : InventorySlotUI

@export var data : InventoryData

@onready var inventory_slot_armour: InventorySlotUI = %InventorySlotArmour
@onready var inventory_slot_amulet: InventorySlotUI = %InventorySlotAmulet
@onready var inventory_slot_weapon: InventorySlotUI = %InventorySlotWeapon
@onready var inventory_slot_ring: InventorySlotUI = %InventorySlotRing

func _ready() -> void:
	PauseMenu.Shown.connect( updateInventory )
	PauseMenu.Hidden.connect( clearInventory )
	#when we run lets start with a clean slate
	clearInventory()
	data.changed.connect( onInventoryChanged )
	data.EquipmentChanged.connect( onInventoryChanged )

func clearInventory() -> void:
	for c in get_children():
		c.setSlotData( null )

# Populates inventory data
func updateInventory( applyFocus : bool = true ) -> void:
	clearInventory()
	
	# Handles all regular inventory
	var inventorySlots : Array[ SlotData ] = data.inventorySlots()
	for i in inventorySlots.size():
		var slot : InventorySlotUI = get_child( i )
		slot.setSlotData( inventorySlots[ i ] )
		connectItemSignals( slot )
	
	# Handles equipment slots
	var equipmentSlots : Array[ SlotData ] = data.equipmentSlots()
	inventory_slot_armour.setSlotData( equipmentSlots[ 0 ] )
	inventory_slot_weapon.setSlotData( equipmentSlots[ 1 ] )
	inventory_slot_amulet.setSlotData( equipmentSlots[ 2 ] )
	inventory_slot_ring.setSlotData( equipmentSlots[ 3 ] )
	
	if applyFocus:
		get_child( 0 ).grab_focus()

func itemFocused() -> void:
	
	pass

func onInventoryChanged() -> void:
	updateInventory( false )


func connectItemSignals( item : InventorySlotUI ) -> void:
	# If it is not connected, we connect
	if not item.button_up.is_connected( _onItemDrop ):
		item.button_up.connect( _onItemDrop.bind( item ) )
	
	if not item.mouse_entered.is_connected( _onItemMouseEntered ):
		item.mouse_entered.connect( _onItemMouseEntered.bind( item ) )
	
	if not item.mouse_exited.is_connected( _onItemMouseExit ):
		item.mouse_exited.connect( _onItemMouseExit )

func _onItemDrop( item : InventorySlotUI ) -> void:
	if item == null or item == hoveredItem or hoveredItem == null:
		return
	data.swapItemsByIndex( item.get_index(), hoveredItem.get_index() ) 
	updateInventory( false )
	# Godot just works, everything in the tree has a unique index. It's beautiful.

func _onItemMouseEntered( item : InventorySlotUI ) -> void:
	hoveredItem = item

func _onItemMouseExit() -> void:
	hoveredItem = null
