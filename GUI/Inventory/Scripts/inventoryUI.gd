class_name InventoryUI extends Control

const INVENTORYSLOT = preload("res://GUI/Inventory/inventorySlot.tscn")

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

func updateInventory( applyFocus : bool = true ) -> void:
	clearInventory()
	
	# Handles all regular inventory
	var inventorySlots : Array[ SlotData ] = data.inventorySlots()
	for i in inventorySlots.size():
		var slot : InventorySlotUI = get_child( i )
		slot.setSlotData( inventorySlots[ i ] )
	
	# Handles equipment slots
	var equipmentSlots : Array[ SlotData ] = data.equipmentSlots()
	inventory_slot_armour.setSlotData( equipmentSlots[ 0 ] )
	inventory_slot_weapon.setSlotData( equipmentSlots[ 1 ] )
	inventory_slot_amulet.setSlotData( equipmentSlots[ 2 ] )
	inventory_slot_ring.setSlotData( equipmentSlots[ 3 ] )
	
	if applyFocus:
		get_child( 0 ).grab_focus()

func onInventoryChanged() -> void:
	updateInventory( false )
