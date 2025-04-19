extends CanvasLayer

const ERROR = preload("res://Resources/Michael Games Sprites/shopkeeper/shopkeeper/error.wav")
const OPENSHOP = preload("res://Resources/Michael Games Sprites/shopkeeper/shopkeeper/open_shop.wav")
const PURCHASE = preload("res://Resources/Michael Games Sprites/shopkeeper/shopkeeper/purchase.wav")
const MENUFOCUS = preload( "res://Resources/Michael Games Sprites/title_screen/menu_focus.wav" )
const MENUSELECT = preload("res://Resources/Michael Games Sprites/title_screen/menu_select.wav")
const SHOPITEMBUTTON = preload("res://GUI/Shop Menu/shopItemButton.tscn")

# Want this to be a var not a const since it should be a direct reference to the scene
var currency : ItemData = preload("res://Items/testgem.tres") #  CHANGE IN FUTURE

signal Shown
signal Hidden

var isActive : bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer
@onready var coin_label: Label = %CoinLabel
@onready var currency_animation_player: AnimationPlayer = $Control/PanelContainer/AnimationPlayer

@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_price: Label = %ItemPrice
@onready var item_held_count: Label = %ItemHeldCount

func _ready() -> void:
	# Hide and disable menu by default
	process_mode = Node.PROCESS_MODE_ALWAYS # Always able to be run and called
	hideMenu()
	close_button.pressed.connect( hideMenu )

func _unhandled_input( event: InputEvent ) -> void:
	if isActive == false:
		return
	
	if event.is_action_pressed( "pause" ):
		get_viewport().set_input_as_handled() # ESC Closes shop without bringing up pause
		hideMenu()
	

func showMenu( items : Array[ ItemData ], dialogueTriggered : bool = true ) -> void:
	# BUGFIX : Await the unpausing of the dialogue system a few frames later
	# Done with the dialogueTriggered argument which is optional
	if dialogueTriggered:
		await DialogueSystem.Finished
	
	enableMenu()
	populateItemList( items )
	updateCoins()
	shop_items_container.get_child( 0 ).grab_focus() # We know it is a button
	playAudio( OPENSHOP )
	Shown.emit()

func hideMenu() -> void:
	enableMenu( false )
	clearItemList()
	Hidden.emit()

# D.R.Y coding, DO not REPEAT YOURSELF. Make anything we use heaps a method.
func enableMenu( _enabled : bool = true ) -> void:
	# We want to pause the game when menu is enabled / vice versa
	get_tree().paused = _enabled
	visible = _enabled
	isActive = _enabled

func updateCoins() -> void:
	coin_label.text = str(getItemCount( currency ))

func getItemCount( item : ItemData ) -> int:
	return PlayerManager.INVENTORYDATA.getItemHeldCount( item )

func clearItemList() -> void:
	# Go through every child of ShopItemsContainer and queue_free
	for c in shop_items_container.get_children():
		c.queue_free()

func populateItemList( items : Array[ ItemData ] ) -> void:
	# Take the item data that we pass in, iterate over each item, and create a new shopItem
	for item in items:
		var shopItem : ShopItemButton = SHOPITEMBUTTON.instantiate()
		shopItem.setupItem( item )
		shop_items_container.add_child( shopItem )
		# Connect to signals
		shopItem.focus_entered.connect( updateItemDetails.bind( item ) )
		shopItem.pressed.connect( purchaseItem.bind( item ) )

func playAudio( _audio : AudioStream ) -> void:
	audio_stream_player.stream = _audio
	audio_stream_player.play()

func focusItemChanged( item : ItemData ) -> void:
	playAudio( MENUFOCUS )
	if item:
		updateItemDetails( item )

func updateItemDetails( item : ItemData ) -> void:
	# Looks at each field that we want to update and update them
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_price.text = str( item.cost )
	item_held_count.text = str( getItemCount( item ) )

func purchaseItem( item : ItemData ) -> void:
	# Either we have enough money and we buy item, or we don't and notify player
	var canPurchase : bool = getItemCount( currency ) >= item.cost
	if canPurchase:
		# Can buy
		playAudio( PURCHASE )
		# Add item to inventory and subtract currency
		var inv : InventoryData = PlayerManager.INVENTORYDATA
		inv.addItem( item )
		inv.useItem( currency, item.cost )
		updateCoins()
		updateItemDetails( item )
	else:
		# Cannot buy
		playAudio( ERROR )
		currency_animation_player.play( "notEnough" )
		currency_animation_player.seek( 0 ) # Brings to first frame every time
