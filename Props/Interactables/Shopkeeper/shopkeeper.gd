class_name Shopkeeper extends Node

@export var shopInventory : Array[ ItemData ]

@onready var dialogueBranchYes : DialogueBranch = $NPC/DialogueInteraction/DialogueChoice/DialogueBranch

func _ready() -> void:
	dialogueBranchYes.Selected.connect( showShopMenu )
	

func showShopMenu() -> void:
	ShopMenu.showMenu( shopInventory )
